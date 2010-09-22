Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8M6hx7L050891 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 01:43:59 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8464F903EC
	for <xfs@oss.sgi.com>; Tue, 21 Sep 2010 23:44:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	IyXAsSaqCCYC9uC2 for <xfs@oss.sgi.com>;
	Tue, 21 Sep 2010 23:44:52 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39842544-1927428
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 16:14:48 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OyJ4Q-0003uH-S9
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:46 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OyJ4E-0002lF-Mg
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/16] xfs: remove buftarg hash for external devices
Date: Wed, 22 Sep 2010 16:44:23 +1000
Message-Id: <1285137869-10310-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1285137869-10310-1-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 1497362..6de9513 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1458,7 +1458,11 @@ xfs_alloc_bufhash(
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
