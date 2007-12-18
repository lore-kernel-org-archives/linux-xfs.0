Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 06:04:34 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBIE4Tha004017
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:04:30 -0800
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C364496F78
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:04:36 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204]) by cuda.sgi.com with ESMTP id hM0iJajM6qP7pACA for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:04:36 -0800 (PST)
Date: Tue, 18 Dec 2007 15:04:03 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Do not reset xfsquota flags on quotaless ro mount
Message-ID: <Pine.LNX.4.64.0712181459210.32270@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi,


In https://bugzilla.novell.com/show_bug.cgi?id=345338 it is claimed that
resetting the quota flags in the mounting sequence rw,ro,rw is a bug, but I
would say this is not the case, as quota is metadata, and the log is replayed
in ro mode even for other filesystems. Yet, it is still not nice, and I have
been trying with this patch, which does not do the right thing yet. (It does a
recovery when mounting for the 3rd time, which probably just says that I did
not know too much of xfs internals to cook up a nicely working patch.)
Opinions?

===

In the following action sequence, quota is unnecessarily recalculated
at the 3rd mount invocation:

	mount -o usrquota,grpquota /dev/mapper/myxfs /mnt
	umount /mnt
	mount -o ro /dev/mapper/myxfs /mnt
	umount /mnt
	mount -o usrquota,grpquota /dev/mapper/myxfs /mnt

This patch skips clearing the quota flags on read-only mounts.

---
 fs/xfs/xfs_qmops.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/xfs/xfs_qmops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_qmops.c
+++ linux-2.6/fs/xfs/xfs_qmops.c
@@ -134,7 +134,14 @@ static struct xfs_qmops xfs_qmcore_stub 
 int
 xfs_qmops_get(struct xfs_mount *mp, struct xfs_mount_args *args)
 {
-	if (args->flags & (XFSMNT_UQUOTA | XFSMNT_PQUOTA | XFSMNT_GQUOTA)) {
+	bool c;
+
+	c = args->flags & (XFSMNT_UQUOTA | XFSMNT_GQUOTA | XFSMNT_PQUOTA);
+#ifdef CONFIG_XFS_QUOTA
+	c |= mp->m_flags & XFS_MOUNT_RDONLY;
+#endif
+
+	if (c) {
 #ifdef CONFIG_XFS_QUOTA
 		mp->m_qm_ops = &xfs_qmcore_xfs;
 #else
