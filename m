Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF9807CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 14:13:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2069304039
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 12:13:46 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EuO7w3W3cikfTaoH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 12:13:43 -0700 (PDT)
Date: Tue, 28 Jun 2016 12:13:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] block: invalidate the page cache when issuing
	BLKZEROOUT.
Message-ID: <20160628191302.GE16181@birch.djwong.org>
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
	<146612625412.12764.6647932282740152837.stgit@birch.djwong.org>
	<7589fc01-a000-a912-f9b5-cf099cc2d27a@acm.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7589fc01-a000-a912-f9b5-cf099cc2d27a@acm.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "hch@infradead.org" <hch@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Mon, Jun 20, 2016 at 02:35:29PM +0200, Bart Van Assche wrote:
> On 06/17/2016 03:18 AM, Darrick J. Wong wrote:
> >Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
> >returning stale cache contents at a later time.
> >
> >v5: Refactor the 4.4 refactoring of the ioctl code into separate functions.
> >Split the page invalidation and the new ioctl into separate patches.
> >
> >Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >Reviewed-by: Christoph Hellwig <hch@lst.de>
> >---
> > block/ioctl.c |   29 +++++++++++++++++++++++------
> > 1 file changed, 23 insertions(+), 6 deletions(-)
> >
> >
> >diff --git a/block/ioctl.c b/block/ioctl.c
> >index ed2397f..d001f52 100644
> >--- a/block/ioctl.c
> >+++ b/block/ioctl.c
> >@@ -225,7 +225,9 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
> > 		unsigned long arg)
> > {
> > 	uint64_t range[2];
> >-	uint64_t start, len;
> >+	struct address_space *mapping;
> >+	uint64_t start, end, len;
> >+	int ret;
> >
> > 	if (!(mode & FMODE_WRITE))
> > 		return -EBADF;
> >@@ -235,18 +237,33 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
> >
> > 	start = range[0];
> > 	len = range[1];
> >+	end = start + len - 1;
> >
> > 	if (start & 511)
> > 		return -EINVAL;
> > 	if (len & 511)
> > 		return -EINVAL;
> >-	start >>= 9;
> >-	len >>= 9;
> >-
> >-	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
> >+	if (end >= (uint64_t)i_size_read(bdev->bd_inode))
> >+		return -EINVAL;
> >+	if (end < start)
> > 		return -EINVAL;
> >
> >-	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL, false);
> >+	/* Invalidate the page cache, including dirty pages */
> >+	mapping = bdev->bd_inode->i_mapping;
> >+	truncate_inode_pages_range(mapping, start, end);
> >+
> >+	ret = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
> >+				    false);
> >+	if (ret)
> >+		return ret;
> >+
> >+	/*
> >+	 * Invalidate again; if someone wandered in and dirtied a page,
> >+	 * the caller will be given -EBUSY.
> >+	 */
> >+	return invalidate_inode_pages2_range(mapping,
> >+					     start >> PAGE_SHIFT,
> >+					     end >> PAGE_SHIFT);
> > }
> 
> Hello Darrick,
> 
> Maybe this has already been discussed, but anyway: in the POSIX spec
> (http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html) I
> found the following: "This volume of POSIX.1-2008 does not specify behavior
> of concurrent writes to a file from multiple processes. Applications should
> use some form of concurrency control."
> 
> Do we really need the invalidate_inode_pages2_range() call?

It's not strictly necessary.  I like the idea of having the kernel bonking
userspace when they don't coordinate and collide, but we could just jump
out after the blkdev_*() calls and let userspace fend for themselves. :)

--D

> 
> Thanks,
> 
> Bart.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
