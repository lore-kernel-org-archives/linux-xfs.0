Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33828 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034285AbcJ1CMt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2016 22:12:49 -0400
Received: by mail-pf0-f193.google.com with SMTP id u84so4147126pfj.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2016 19:12:49 -0700 (PDT)
Date: Fri, 28 Oct 2016 13:12:34 +1100
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
In-Reply-To: <20161027214244.GO14023@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
        <20161027214244.GO14023@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, 28 Oct 2016 08:42:44 +1100
Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Oct 28, 2016 at 03:17:47AM +1100, Nicholas Piggin wrote:
> > Hi guys,
> > 
> > We're seeing crc32c_le show up in xfs log checksumming on a MySQL benchmark
> > on powerpc. I could reproduce similar overheads with dbench as well.
> > 
> > 1.11%  mysqld           [kernel.vmlinux]            [k] __crc32c_le
> >         |
> >         ---__crc32c_le
> >            |          
> >             --1.11%--chksum_update
> >                       |          
> >                        --1.11%--crypto_shash_update
> >                                  crc32c
> >                                  xlog_cksum
> >                                  xlog_sync
> >                                  _xfs_log_force_lsn
> >                                  xfs_file_fsync
> >                                  vfs_fsync_range
> >                                  do_fsync
> >                                  sys_fsync
> >                                  system_call
> >                                  0x17738
> >                                  0x17704
> >                                  os_file_flush_func
> >                                  fil_flush  
> 
> 2-3% is the typical CRC CPU overhead I see on metadata/log intensive
> workloads on x86-64, so this doesn't seem unreasonable.
> 
> Looking more closely at xlog_cksum, it does:
> 
> 	crc = xfs_start_cksum(sizeof(struct xlog_rec_header) ...
> 	for (i = 0; i < xheads; i++) {
> 		...
> 		crc = crc32c(crc, ... sizeof(struct xlog_rec_ext_header));
> 		...
> 	}
> 	/* ... and finally for the payload */
> 	crc = crc32c(crc, dp, size);
> 
> 	return xfs_end_cksum(crc);
> 
> The vast majority of the work it does is in the ".. and finally for
> the payload " call. The first is a sector, the loop (up to 8 times
> for 256k log buffer sizes) is over single sectors, and the payload
> is up to 256kb of data. So the payload CRC is the vast majority of
> the data being CRCed and so should dominate the CPU usage here.  It
> doesn't look like optimising xfs_start_cksum() would make much
> difference...
> 
> > As a rule, it helps the crc implementation if it can operate on as large a
> > chunk as possible (alignment, startup overhead, etc). So I did a quick hack
> > at getting XFS checksumming to feed crc32c() with larger chunks, by setting
> > the existing crc to 0 before running over the entire buffer. Together with
> > some small work on the powerpc crc implementation, crc drops below 0.1%.  
> 
> I wouldn't have expected reducing call numbers and small alignment
> changes to make that amount of difference given the amount of data
> we are actually checksumming. How much of that difference was due to
> the improved CRC implementation?

Sorry, I should have been more clear about what was happening. Not enough
sleep. The larger sizes allows the vectorized crc implementation to kick in.

We should still be able to improve things on the powerpc side without any
changes to XFS, it was just something I noticed would be nice to improve.

As Darrick noted, it is modifying the field in-place for the verifiers,
which is nasty and the reason I don't propose it as a real patch (because I
don't know enough fo XFS to say whether it's completely safe).


> FWIW, can you provide some additional context by grabbing the log
> stats that tell us the load on the log that is generating this
> profile?  A sample over a minute of a typical workload (with a
> corresponding CPU profile) would probably be sufficient. You can get
> them simply by zeroing the xfs stats via
> /proc/sys/fs/xfs/stats_clear at the start of the sample period and
> then dumping /proc/fs/xfs/stat at the end.

Yeah I'll get some better information for you.

> > I don't know if something like this would be acceptable? It's not pretty,
> > but I didn't see an easier way.  
> 
> ISTR we made the choice not to do that to avoid potential problems
> with potential race conditions and bugs (i.e. don't modify anything
> in objects on read access) but I can't point you at anything
> specific...

Sounds pretty reasonable, especially for the verifiers. For the paths
that create/update the checksums (including this log checksum), it seems
like it should be less controversial.

But yes let me get more data first. Thanks for taking a look.

Thanks,
Nick
