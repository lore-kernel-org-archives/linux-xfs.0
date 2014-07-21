Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1EBC37F3F
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2014 14:21:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F26398F8035
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2014 12:21:39 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id wbSxTE7hXpBvC3B5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Jul 2014 12:21:35 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A7408AD7C
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2014 19:21:33 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] repair: Set ftype for entries in lost+found
Date: Mon, 21 Jul 2014 21:21:25 +0200
Message-Id: <1405970485-19888-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

So far all entries in lost+found had file type XFS_DIR3_FT_UNKNOWN which
is somewhat annoying as the next xfs_repair pass will find these and
report as an error. Set proper file type when creating these entries.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 repair/phase6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index f13069f4cd71..0ec4f07ca1c2 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1097,8 +1097,6 @@ mv_orphanage(
 	xname.name = fname;
 	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
 				(unsigned long long)ino);
-	/* XXX use xfs_mode_to_ftype[] when userspace gains it */
-	xname.type = XFS_DIR3_FT_UNKNOWN;
 
 	err = libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip, 0);
 	if (err)
@@ -1117,6 +1115,8 @@ mv_orphanage(
 	if ((err = libxfs_iget(mp, NULL, ino, 0, &ino_p, 0)))
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
+	xname.type = xfs_mode_to_ftype[(ino_p->i_d.di_mode & S_IFMT)>>S_SHIFT];
+
 	if (isa_dir)  {
 		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, orphanage_ino),
 				XFS_INO_TO_AGINO(mp, orphanage_ino));
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
