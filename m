Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24574 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030400AbcJ0XSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2016 19:18:33 -0400
Date: Fri, 28 Oct 2016 10:16:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161027231633.GP14023@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
 <20161027214244.GO14023@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161027214244.GO14023@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nicholas Piggin <npiggin@gmail.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>

On Fri, Oct 28, 2016 at 08:42:44AM +1100, Dave Chinner wrote:
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

FWIW, I just noticed that qemu is now passing through hardware CRC
feature bits to the guest, so it's now using the hardware
accelerated intel module for CRCs. That "2-3%" I mentioned I used
to see from __crc32c_le is now:

   0.35%  [kernel]  [k] crc32c_pcl_intel_update

And there's about 250MB/s of log+metadata IO being CRC'd in this
workload, so I don't think that the way XFS splits the CRCs into
multiple segments is really all that significant...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
