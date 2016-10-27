Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:1230 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933724AbcJ0VnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2016 17:43:01 -0400
Date: Fri, 28 Oct 2016 08:42:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161027214244.GO14023@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nicholas Piggin <npiggin@gmail.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>

On Fri, Oct 28, 2016 at 03:17:47AM +1100, Nicholas Piggin wrote:
> Hi guys,
> 
> We're seeing crc32c_le show up in xfs log checksumming on a MySQL benchmark
> on powerpc. I could reproduce similar overheads with dbench as well.
> 
> 1.11%  mysqld           [kernel.vmlinux]            [k] __crc32c_le
>         |
>         ---__crc32c_le
>            |          
>             --1.11%--chksum_update
>                       |          
>                        --1.11%--crypto_shash_update
>                                  crc32c
>                                  xlog_cksum
>                                  xlog_sync
>                                  _xfs_log_force_lsn
>                                  xfs_file_fsync
>                                  vfs_fsync_range
>                                  do_fsync
>                                  sys_fsync
>                                  system_call
>                                  0x17738
>                                  0x17704
>                                  os_file_flush_func
>                                  fil_flush

2-3% is the typical CRC CPU overhead I see on metadata/log intensive
workloads on x86-64, so this doesn't seem unreasonable.

Looking more closely at xlog_cksum, it does:

	crc = xfs_start_cksum(sizeof(struct xlog_rec_header) ...
	for (i = 0; i < xheads; i++) {
		...
		crc = crc32c(crc, ... sizeof(struct xlog_rec_ext_header));
		...
	}
	/* ... and finally for the payload */
	crc = crc32c(crc, dp, size);

	return xfs_end_cksum(crc);

The vast majority of the work it does is in the ".. and finally for
the payload " call. The first is a sector, the loop (up to 8 times
for 256k log buffer sizes) is over single sectors, and the payload
is up to 256kb of data. So the payload CRC is the vast majority of
the data being CRCed and so should dominate the CPU usage here.  It
doesn't look like optimising xfs_start_cksum() would make much
difference...

> As a rule, it helps the crc implementation if it can operate on as large a
> chunk as possible (alignment, startup overhead, etc). So I did a quick hack
> at getting XFS checksumming to feed crc32c() with larger chunks, by setting
> the existing crc to 0 before running over the entire buffer. Together with
> some small work on the powerpc crc implementation, crc drops below 0.1%.

I wouldn't have expected reducing call numbers and small alignment
changes to make that amount of difference given the amount of data
we are actually checksumming. How much of that difference was due to
the improved CRC implementation?

FWIW, can you provide some additional context by grabbing the log
stats that tell us the load on the log that is generating this
profile?  A sample over a minute of a typical workload (with a
corresponding CPU profile) would probably be sufficient. You can get
them simply by zeroing the xfs stats via
/proc/sys/fs/xfs/stats_clear at the start of the sample period and
then dumping /proc/fs/xfs/stat at the end.

> I don't know if something like this would be acceptable? It's not pretty,
> but I didn't see an easier way.

ISTR we made the choice not to do that to avoid potential problems
with potential race conditions and bugs (i.e. don't modify anything
in objects on read access) but I can't point you at anything
specific...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
