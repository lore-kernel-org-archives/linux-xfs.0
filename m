Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O5vr3k013829 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 00:57:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 772781F036E8
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 22:57:52 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vtxE0p8O5YSFy9AE for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 22:57:52 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6TH-0002vn-CC
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 05:57:51 +0000
Date: Wed, 24 Aug 2011 01:57:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] xfs: deprecate the nodelaylog mount option
Message-ID: <20110824055750.GA11175@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/Documentation/feature-removal-schedule.txt
===================================================================
--- xfs.orig/Documentation/feature-removal-schedule.txt	2011-08-24 07:45:56.450196165 +0200
+++ xfs/Documentation/feature-removal-schedule.txt	2011-08-24 07:47:17.049759519 +0200
@@ -592,3 +592,11 @@ Why:    In 3.0, we can now autodetect in
 	interface that was used by acer-wmi driver. It will replaced by
 	information log when acer-wmi initial.
 Who:    Lee, Chun-Yi <jlee@novell.com>
+
+----------------------------
+What:	The XFS nodelaylog mount option
+When:	3.3
+Why:	The delaylog mode that has been the default since 2.6.39 has proven
+	stable, and the old code is in the way of additional improvements in
+	the log code.
+Who:	Christoph Hellwig <hch@lst.de>
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-08-24 07:47:53.696227656 +0200
+++ xfs/fs/xfs/xfs_super.c	2011-08-24 07:48:53.249238363 +0200
@@ -356,6 +356,8 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_DELAYLOG;
 		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
 			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
+			xfs_warn(mp,
+	"nodelaylog is deprecated and will be removed in Linux 3.3");
 		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
 			mp->m_flags |= XFS_MOUNT_DISCARD;
 		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
