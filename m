Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAuKrU121245 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 600141E6531A
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 03:57:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	f5mhB2h2bKHGwB0q for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 03:57:07 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38985544-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:27:06 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTCC-0004PD-PM
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:57:04 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTBv-0000QV-BH
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/18] xfs: remove buftarg hash for external devices
Date: Tue, 14 Sep 2010 20:56:12 +1000
Message-Id: <1284461777-1496-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

For RT and external log devices, we never use hashed buffers on them
now.  Remove the buftarg hash tables that are set up for them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_buf.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 304515b..1c6206e 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1456,7 +1456,11 @@ xfs_alloc_bufhash(
 {
 	unsigned int		i;
 
-	btp->bt_hashshift = external ? 3 : 12;	/* 8 or 4096 buckets */
+	if (external) {
+		btp->bt_hash = NULL;
+		return;
+	}
+	btp->bt_hashshift = 12;	/* 4096 buckets */
 	btp->bt_hash = kmem_zalloc_large((1 << btp->bt_hashshift) *
 					 sizeof(xfs_bufhash_t));
 	for (i = 0; i < (1 << btp->bt_hashshift); i++) {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
