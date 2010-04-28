Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SEdNYJ242010 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 09:39:24 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1727D1DDFB44
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:41:27 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id OA3V6oLerFyHYdaS for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:41:27 -0700 (PDT)
From: Tao Ma <tao.ma@oracle.com>
Subject: [PATCH v3] XFS: Let the broken fiemap work in query mode.
Date: Wed, 28 Apr 2010 22:39:09 +0800
Message-Id: <1272465549-6503-1-git-send-email-tao.ma@oracle.com>
In-Reply-To: <20100428113359.GB27769@infradead.org>
References: <20100428113359.GB27769@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, Tao Ma <tao.ma@oracle.com>, xfs@oss.sgi.com

> On Wed, Apr 28, 2010 at 11:00:25AM +0800, Tao Ma wrote:
>> -	bm.bmv_count = fieinfo->fi_extents_max + 1;
>> +	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
>> +					fieinfo->fi_extents_max + 1;
>> +	bm.bmv_count = MIN(bm.bmv_count,
>> +			   (__s32)(PAGE_SIZE * 16 / sizeof(struct getbmapx)));
>
> I would use min_t here instead of the case, but otherwise the patch
> looks good to me
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Ok, here comes the v3. Thanks for the review.

Regards,
Tao

>From c735bccfbb925841545dcb1853fa8ffb3f3c8785 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 28 Apr 2010 21:57:32 +0800
Subject: [PATCH v3] XFS: Let the broken fiemap work in query mode.

According to Documentation/filesystems/fiemap.txt, If fm_extent_count
is zero, then the fm_extents[] array is ignored (no extents will be
returned), and the fm_mapped_extents count will hold the number of
extents needed.

But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
bmv_count to the caller's input buffer, this number query function can't
work any more. As this commit is written to change bmv_count from
MAXEXTNUM because of ENOMEM.

This patch just try to  set bm.bmv.count to something sane.
Thanks to Dave Chinner <david@fromorbit.com> for the suggestion.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Alex Elder <aelder@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 2259460..68531fc 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -662,7 +662,10 @@ xfs_vn_fiemap(
 		bm.bmv_length = BTOBB(length);
 
 	/* We add one because in getbmap world count includes the header */
-	bm.bmv_count = fieinfo->fi_extents_max + 1;
+	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
+					fieinfo->fi_extents_max + 1;
+	bm.bmv_count = min_t(__s32, bm.bmv_count,
+			     (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
 	bm.bmv_iflags = BMV_IF_PREALLOC;
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
 		bm.bmv_iflags |= BMV_IF_ATTRFORK;
-- 
1.6.3.3.334.g916e1.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
