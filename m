Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67DBoD2170219 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 08:11:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC8C65358F
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 06:11:49 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CEFNutTJdnS4EXFP for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 06:11:49 -0700 (PDT)
Date: Thu, 7 Jul 2011 09:11:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.38.8: quota check oops
Message-ID: <20110707131148.GA21278@infradead.org>
References: <201107060832.03640.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201107060832.03640.arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Wed, Jul 06, 2011 at 08:32:03AM +0200, Arkadiusz Miskiewicz wrote:
> 
> quota check code (mount with user+group quota) likes to oops
> for me (usually after system hang and hard reset). 
> 
> This is on 2.6.38.8 on top of raid10 soft raid. Mount without
> quota succeeds without a problem.

Looking over the oops mutex_lock is dereferencing a member at offset
0x20 of a structure that unexpectly is a NULL pointer.  The only
mutex_lock calls in xfs_qm_sync are on qi_dqlist_lock, which happens
to be exactly at the offset 0x20 that the oops is complaining about.

So the quick patch below should prevent the OOPS for you and print
a warnings instead, although I'll have to dig a bit deeper to figure
out the root cause.

Index: linux-2.6/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm.c	2011-07-07 15:02:25.206920700 +0200
+++ linux-2.6/fs/xfs/quota/xfs_qm.c	2011-07-07 15:03:59.576915891 +0200
@@ -939,6 +939,11 @@ xfs_qm_sync(
 	restarts = 0;
 
   again:
+ 	if (!q) {
+		printk("XFS: %s called without valid quotainfo\n", __func__);
+		dump_stack();
+		return 0;
+	}
 	mutex_lock(&q->qi_dqlist_lock);
 	/*
 	 * dqpurge_all() also takes the mplist lock and iterate thru all dquots
@@ -1003,6 +1008,12 @@ xfs_qm_sync(
 		else if (error)
 			return error;
 
+ 		if (!q) {
+			printk("XFS: %s called without valid quotainfo (2)\n",
+				__func__);
+			dump_stack();
+			return 0;
+		}
 		mutex_lock(&q->qi_dqlist_lock);
 		if (recl != q->qi_dqreclaims) {
 			if (++restarts >= XFS_QM_SYNC_MAX_RESTARTS)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
