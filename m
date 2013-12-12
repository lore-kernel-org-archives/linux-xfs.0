Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 055747F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:34:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D78F0304067
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:34:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HBVZdLbv04M3KjGX for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 21:34:43 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vqyv2-0000bo-BP
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vqyv2-0003cZ-AF
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 16:34:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: swalloc doesn't align allocations properly
Date: Thu, 12 Dec 2013 16:34:36 +1100
Message-Id: <1386826478-13846-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1386826478-13846-1-git-send-email-david@fromorbit.com>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When swalloc is specified as a mount option, allocations are
supposed to be aligned to the stripe width rather than the stripe
unit of the underlying filesystem. However, it does not do this.

What the implementation does is round up the allocation size to a
stripe width, hence ensuring that all allocations span a full stripe
width. It does not, however, ensure that that allocation is aligned
to a stripe width, and hence the allocations can span multiple
underlying stripes and so still see RMW cycles for things like
direct IO on MD RAID.

So, if the swalloc mount option is set, change the allocation
alignment in xfs_bmap_btalloc() to use the stripe width rather than
the stripe unit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 8401f11..3b2c14b 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3648,10 +3648,19 @@ xfs_bmap_btalloc(
 	int		isaligned;
 	int		tryagain;
 	int		error;
+	int		stripe_align;
 
 	ASSERT(ap->length);
 
 	mp = ap->ip->i_mount;
+
+	/* stripe alignment for allocation is determined by mount parameters */
+	stripe_align = 0;
+	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+		stripe_align = mp->m_swidth;
+	else if (mp->m_dalign)
+		stripe_align = mp->m_dalign;
+
 	align = ap->userdata ? xfs_get_extsz_hint(ap->ip) : 0;
 	if (unlikely(align)) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
@@ -3660,6 +3669,8 @@ xfs_bmap_btalloc(
 		ASSERT(!error);
 		ASSERT(ap->length);
 	}
+
+
 	nullfb = *ap->firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
 	if (nullfb) {
@@ -3735,7 +3746,7 @@ xfs_bmap_btalloc(
 	 */
 	if (!ap->flist->xbf_low && ap->aeof) {
 		if (!ap->offset) {
-			args.alignment = mp->m_dalign;
+			args.alignment = stripe_align;
 			atype = args.type;
 			isaligned = 1;
 			/*
@@ -3760,13 +3771,13 @@ xfs_bmap_btalloc(
 			 * of minlen+alignment+slop doesn't go up
 			 * between the calls.
 			 */
-			if (blen > mp->m_dalign && blen <= args.maxlen)
-				nextminlen = blen - mp->m_dalign;
+			if (blen > stripe_align && blen <= args.maxlen)
+				nextminlen = blen - stripe_align;
 			else
 				nextminlen = args.minlen;
-			if (nextminlen + mp->m_dalign > args.minlen + 1)
+			if (nextminlen + stripe_align > args.minlen + 1)
 				args.minalignslop =
-					nextminlen + mp->m_dalign -
+					nextminlen + stripe_align -
 					args.minlen - 1;
 			else
 				args.minalignslop = 0;
@@ -3788,7 +3799,7 @@ xfs_bmap_btalloc(
 		 */
 		args.type = atype;
 		args.fsbno = ap->blkno;
-		args.alignment = mp->m_dalign;
+		args.alignment = stripe_align;
 		args.minlen = nextminlen;
 		args.minalignslop = 0;
 		isaligned = 1;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
