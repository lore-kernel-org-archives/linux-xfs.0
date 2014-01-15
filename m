Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F161E29E21
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 717D8AC004
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:53 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UsiS003656
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:54 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000852.491725328@sgi.com>
Date: Wed, 15 Jan 2014 16:00:27 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 15/17] xfsprogs: add basic parent pointer support to xfs_db
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=03-xfsprogs-pptr-add-to-xfs_db.patch
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

Add basic parent pointer support to xfs_db. Not at all complete.

---
 db/inode.c              |    2 ++

---
 db/inode.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/db/inode.c
===================================================================
--- a/db/inode.c
+++ b/db/inode.c
@@ -175,6 +175,8 @@ const field_t	inode_v3_flds[] = {
 	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
 	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },
+	{ "parent", FLDT_UINT64D, OI(COFF(parent)), C1, 0, TYP_NONE },
+	{ "poffset", FLDT_UINT32X, OI(OFF(poffset)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
