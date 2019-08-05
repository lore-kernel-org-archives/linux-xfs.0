Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56384 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHESPa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 14:15:30 -0400
Date: Mon, 5 Aug 2019 11:15:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Block device direct read EIO handling broken?
Message-ID: <20190805181524.GE7129@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, axboe@kernel.dk, linux-block@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

Hi Damien,

I noticed a regression in xfs/747 (an unreleased xfstest for the
xfs_scrub media scanning feature) on 5.3-rc3.  I'll condense that down
to a simpler reproducer:

# dmsetup table
error-test: 0 209 linear 8:48 0
error-test: 209 1 error 
error-test: 210 6446894 linear 8:48 210

Basically we have a ~3G /dev/sdd and we set up device mapper to fail IO
for sector 209 and to pass the io to the scsi device everywhere else.

On 5.3-rc3, performing a directio pread of this range with a < 1M buffer
(in other words, a request for fewer than MAX_BIO_PAGES bytes) yields
EIO like you'd expect:

# strace -e pread64 xfs_io -d -c 'pread -b 1024k 0k 1120k' /dev/mapper/error-test
pread64(3, 0x7f880e1c7000, 1048576, 0)  = -1 EIO (Input/output error)
pread: Input/output error
+++ exited with 0 +++

But doing it with a larger buffer succeeds(!):

# strace -e pread64 xfs_io -d -c 'pread -b 2048k 0k 1120k' /dev/mapper/error-test
pread64(3, "XFSB\0\0\20\0\0\0\0\0\0\fL\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1146880, 0) = 1146880
read 1146880/1146880 bytes at offset 0
1 MiB, 1 ops; 0.0009 sec (1.124 GiB/sec and 1052.6316 ops/sec)
+++ exited with 0 +++

(Note that the part of the buffer corresponding to the dm-error area is
uninitialized)

On 5.3-rc2, both commands would fail with EIO like you'd expect.  The
only change between rc2 and rc3 is commit 0eb6ddfb865c ("block: Fix
__blkdev_direct_IO() for bio fragments").

AFAICT we end up in __blkdev_direct_IO with a 1120K buffer, which gets
split into two bios: one for the first BIO_MAX_PAGES worth of data (1MB)
and a second one for the 96k after that.

I think the problem is that every time we submit a bio, we increase ret
by the size of that bio, but at the time we do that we have no idea if
the bio is going to succeed or not.  At the end of the function we do:

	if (!ret)
		ret = blk_status_to_errno(dio->bio.bi_status);

Which means that we only pick up the IO error if we haven't already set
ret.  I suppose that was useful for being able to return a short read,
but now that we always increment ret by the size of the bio, we act like
the whole buffer was read.  I tried a -rc2 kernel and found that 40% of
the time I'd get an EIO and the rest of the time I got a short read.

Not sure where to go from here, but something's not right...

--D
