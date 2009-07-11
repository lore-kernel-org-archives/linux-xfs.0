Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6B5H0Is147697 for <xfs@oss.sgi.com>; Sat, 11 Jul 2009 00:17:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1C2F1BD4133
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 22:17:37 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id jIWxSQ2OImBjnyut for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2009 22:17:37 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id B6479A7CE6A
	for <xfs@oss.sgi.com>; Sat, 11 Jul 2009 00:17:36 -0500 (CDT)
Message-ID: <4A582070.9040907@sandeen.net>
Date: Sat, 11 Jul 2009 00:17:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH, RFC] xfs_repair - clear inodes in incorrect btree format
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
To: xfs-oss <xfs@oss.sgi.com>

See also RH bug #510823:
https://bugzilla.redhat.com/show_bug.cgi?id=510823

This check in xfs_iformat_btree() tripped:

        /*
         * blow out if -- fork has less extents than can fit in
         * fork (fork shouldn't be a btree format), root btree
         * block has more records than can fit into the fork,
         * or the number of extents is greater than the number of
         * blocks.
         */

leading to:

Jul 10 23:22:45 hermes kernel: Filesystem "dm-11": corrupt inode 2339503222
(btree).  Unmount and run xfs_repair.
Jul 10 23:22:45 hermes kernel: Filesystem "dm-11": XFS internal error
xfs_iformat_btree at line 625 of file fs/xfs/xfs_inode.c.

but repair finds nothing at all.  xfs_check, however, does flag the inodes
as problematic:

extent count for ino 2339503222 data fork too low (6) for file format

So I copied the xfs_check test into xfs_repair, and voila, it clears
these inodes.

But questions remain...

1) How'd it get into this state? ... but maybe more importantly...
2) Should these really get cleared?  It's possibly a sane extent list,
it's just that it -could- be in extents rather than btree format...
3) By the same token, should the kernel really be choking on it?

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index 84e1d05..3fc6cac 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1280,6 +1280,14 @@ process_btinode(
 			last_key = cursor.level[level-1].first_key;
 		}
 	}
+	if (*nex <= XFS_DFORK_SIZE(dip, mp, whichfork) / sizeof(xfs_bmbt_rec_t)) {
+		do_warn(_("extent count for ino %lld %s fork too low "
+			  "(%d) for file format\n"),
+				lino,
+				whichfork == XFS_DATA_FORK ? _("data") : _("attr"),
+				*nex);
+		return(1);
+	}
 	/*
 	 * Check that the last child block's forward sibling pointer
 	 * is NULL.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
