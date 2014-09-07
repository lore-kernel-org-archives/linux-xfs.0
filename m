Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 697BF7F50
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 11:41:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D2208F8033
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 09:41:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zavfwSWDH7LbFfdS for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 09:41:07 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/5] xfs_repair: set proper ftype when moving to lost+found
Date: Sun,  7 Sep 2014 11:41:05 -0500
Message-Id: <1410108065-18156-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
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

When we move files to lost+found, we're setting the
filetype to UNKNOWN.  This leaves an inconsistency which
is discovered on a subsequent repair:

 would fix ftype mismatch (0/1) in directory/child inode 5838/5839

Setting the proper ftype at the time of the move
resolves this:

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/phase6.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index cc36a9c..02714c2 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1091,14 +1091,13 @@ mv_orphanage(
 	ino_tree_node_t		*irec;
 	int			ino_offset = 0;
 	struct xfs_name		xname;
+	__uint16_t		di_mode;
 
 	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
 
 	xname.name = fname;
 	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
 				(unsigned long long)ino);
-	/* XXX use xfs_mode_to_ftype[] when userspace gains it */
-	xname.type = XFS_DIR3_FT_UNKNOWN;
 
 	err = libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip, 0);
 	if (err)
@@ -1117,6 +1116,10 @@ mv_orphanage(
 	if ((err = libxfs_iget(mp, NULL, ino, 0, &ino_p, 0)))
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
+	di_mode = ino_p->i_d.di_mode;
+	di_mode = (di_mode & S_IFMT) >> S_SHIFT;
+	xname.type = xfs_mode_to_ftype[di_mode];
+
 	if (isa_dir)  {
 		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, orphanage_ino),
 				XFS_INO_TO_AGINO(mp, orphanage_ino));
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
