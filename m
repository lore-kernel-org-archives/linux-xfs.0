Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88B427FBA
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2014 20:41:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77259304032
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2014 18:41:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nECE9PsMhVGk9Fgg for <xfs@oss.sgi.com>;
	Sun, 28 Sep 2014 18:41:37 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XYPxu-0000rQ-3F
	for xfs@oss.sgi.com; Mon, 29 Sep 2014 11:41:26 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XYPxu-0003BO-25
	for xfs@oss.sgi.com; Mon, 29 Sep 2014 11:41:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: compat_xfs_bstat does not have forkoff
Date: Mon, 29 Sep 2014 11:41:26 +1000
Message-Id: <1411954886-12200-1-git-send-email-david@fromorbit.com>
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

struct compat_xfs_bstat is missing the di_forkoff field and so does
not fully translate the structure correctly. Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl32.c | 2 ++
 fs/xfs/xfs_ioctl32.h | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index a554646..94ce027 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -160,6 +160,7 @@ xfs_ioctl32_bstat_copyin(
 	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
 	    get_user(bstat->bs_projid_lo, &bstat32->bs_projid_lo) ||
 	    get_user(bstat->bs_projid_hi, &bstat32->bs_projid_hi) ||
+	    get_user(bstat->bs_forkoff,	&bstat32->bs_forkoff)	||
 	    get_user(bstat->bs_dmevmask, &bstat32->bs_dmevmask)	||
 	    get_user(bstat->bs_dmstate,	&bstat32->bs_dmstate)	||
 	    get_user(bstat->bs_aextents, &bstat32->bs_aextents))
@@ -214,6 +215,7 @@ xfs_bulkstat_one_fmt_compat(
 	    put_user(buffer->bs_gen,	  &p32->bs_gen)		||
 	    put_user(buffer->bs_projid,	  &p32->bs_projid)	||
 	    put_user(buffer->bs_projid_hi,	&p32->bs_projid_hi)	||
+	    put_user(buffer->bs_forkoff,  &p32->bs_forkoff)	||
 	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask)	||
 	    put_user(buffer->bs_dmstate,  &p32->bs_dmstate)	||
 	    put_user(buffer->bs_aextents, &p32->bs_aextents))
diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
index 80f4060..b1bb454 100644
--- a/fs/xfs/xfs_ioctl32.h
+++ b/fs/xfs/xfs_ioctl32.h
@@ -67,8 +67,9 @@ typedef struct compat_xfs_bstat {
 	__u32		bs_gen;		/* generation count		*/
 	__u16		bs_projid_lo;	/* lower part of project id	*/
 #define	bs_projid	bs_projid_lo	/* (previously just bs_projid)	*/
+	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
 	__u16		bs_projid_hi;	/* high part of project id	*/
-	unsigned char	bs_pad[12];	/* pad space, unused		*/
+	unsigned char	bs_pad[10];	/* pad space, unused		*/
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
