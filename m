Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46362 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754167AbcJYXE4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:04:56 -0400
Subject: [PATCH 12/39] xfs_db: deal with the CoW extent size hint
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:04:52 -0700
Message-ID: <147743669238.11035.5109317961875719512.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Display the CoW extent hint size when dumping inodes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/inode.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/db/inode.c b/db/inode.c
index 702cdf8..cac19fc 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -172,12 +172,16 @@ const field_t	inode_v3_flds[] = {
 	{ "change_count", FLDT_UINT64D, OI(COFF(changecount)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
 	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
+	{ "cowextsize", FLDT_EXTLEN, OI(COFF(cowextsize)), C1, 0, TYP_NONE },
 	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
 	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },
 	{ "reflink", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(__uint64_t) - XFS_DIFLAG2_REFLINK_BIT-1), C1,
 	  0, TYP_NONE },
+	{ "cowextsz", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(__uint64_t) - XFS_DIFLAG2_COWEXTSIZE_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 

