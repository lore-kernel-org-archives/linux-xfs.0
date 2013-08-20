Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B6D837FD7
	for <linux-xfs@oss.sgi.com>; Tue, 20 Aug 2013 18:14:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7FD6A304032
	for <linux-xfs@oss.sgi.com>; Tue, 20 Aug 2013 16:14:19 -0700 (PDT)
Message-ID: <5213F849.7080308@redhat.com>
Date: Tue, 20 Aug 2013 18:14:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: add prototype for alloc_ex_data()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>

3ac87fbf xfsprogs: fix inode crash in xfs_repair

un-static'd alloc_ex_data and used it in phase6.c,
but didn't put a prototype in a header, so:

 phase6.c: In function =91mk_orphanage=92:
 phase6.c:943: warning: implicit declaration of function =91alloc_ex_data=
=92

Fix it...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/incore.h b/repair/incore.h
index 8a578b5..38caa6d 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -483,6 +483,11 @@ void		set_inode_parent(ino_tree_node_t *irec, int ino_=
offset,
 xfs_ino_t	get_inode_parent(ino_tree_node_t *irec, int ino_offset);
 =

 /*
+ * Allocate extra inode data
+ */
+void		alloc_ex_data(ino_tree_node_t *irec);
+
+/*
  * bmap cursor for tracking and fixing bmap btrees.  All xfs btrees number
  * the levels with 0 being the leaf and every level up being 1 greater.
  */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
