Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51959 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdKQT4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 14:56:50 -0500
Subject: [PATCH 1/5] xfs_db: print structure padding fields consistently
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 11:56:47 -0800
Message-ID: <151094860737.27182.5422098949147661107.stgit@magnolia>
In-Reply-To: <151094860143.27182.12022983202520916281.stgit@magnolia>
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We are very inconsistent about how we print padding fields in on-disk
structures -- sometimes we hide it from printall, sometimes we deviate
from unsigned hex values, etc.  Make this all consistent -- never hide
padding values, always print them as unsigned hex integers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attr.c  |   10 +++++-----
 db/dir2.c  |    4 ++--
 db/dquot.c |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index 75fe239..ba8313c 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -73,7 +73,7 @@ const field_t	attr_blkinfo_flds[] = {
 	{ "forw", FLDT_ATTRBLOCK, OI(BOFF(forw)), C1, 0, TYP_ATTR },
 	{ "back", FLDT_ATTRBLOCK, OI(BOFF(back)), C1, 0, TYP_ATTR },
 	{ "magic", FLDT_UINT16X, OI(BOFF(magic)), C1, 0, TYP_NONE },
-	{ "pad", FLDT_UINT16X, OI(BOFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "pad", FLDT_UINT16X, OI(BOFF(pad)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
@@ -94,7 +94,7 @@ const field_t	attr_leaf_entry_flds[] = {
 	{ "local", FLDT_UINT1,
 	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_LOCAL_BIT - 1), C1, 0,
 	  TYP_NONE },
-	{ "pad2", FLDT_UINT8X, OI(LEOFF(pad2)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "pad2", FLDT_UINT8X, OI(LEOFF(pad2)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
@@ -105,7 +105,7 @@ const field_t	attr_leaf_hdr_flds[] = {
 	{ "usedbytes", FLDT_UINT16D, OI(LHOFF(usedbytes)), C1, 0, TYP_NONE },
 	{ "firstused", FLDT_UINT16D, OI(LHOFF(firstused)), C1, 0, TYP_NONE },
 	{ "holes", FLDT_UINT8D, OI(LHOFF(holes)), C1, 0, TYP_NONE },
-	{ "pad1", FLDT_UINT8X, OI(LHOFF(pad1)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "pad1", FLDT_UINT8X, OI(LHOFF(pad1)), C1, 0, TYP_NONE },
 	{ "freemap", FLDT_ATTR_LEAF_MAP, OI(LHOFF(freemap)),
 	  CI(XFS_ATTR_LEAF_MAPSIZE), FLD_ARRAY, TYP_NONE },
 	{ NULL }
@@ -567,7 +567,7 @@ const field_t	attr3_leaf_hdr_flds[] = {
 	{ "usedbytes", FLDT_UINT16D, OI(LH3OFF(usedbytes)), C1, 0, TYP_NONE },
 	{ "firstused", FLDT_UINT16D, OI(LH3OFF(firstused)), C1, 0, TYP_NONE },
 	{ "holes", FLDT_UINT8D, OI(LH3OFF(holes)), C1, 0, TYP_NONE },
-	{ "pad1", FLDT_UINT8X, OI(LH3OFF(pad1)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "pad1", FLDT_UINT8X, OI(LH3OFF(pad1)), C1, 0, TYP_NONE },
 	{ "freemap", FLDT_ATTR_LEAF_MAP, OI(LH3OFF(freemap)),
 	  CI(XFS_ATTR_LEAF_MAPSIZE), FLD_ARRAY, TYP_NONE },
 	{ NULL }
@@ -589,7 +589,7 @@ const field_t	attr3_node_hdr_flds[] = {
 	{ "info", FLDT_ATTR3_BLKINFO, OI(H3OFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(H3OFF(__count)), C1, 0, TYP_NONE },
 	{ "level", FLDT_UINT16D, OI(H3OFF(__level)), C1, 0, TYP_NONE },
-	{ "pad", FLDT_UINT32D, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/dir2.c b/db/dir2.c
index 3e21a7b..bd9c6aa 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -171,7 +171,7 @@ const field_t	da_blkinfo_flds[] = {
 	{ "forw", FLDT_DIRBLOCK, OI(DBOFF(forw)), C1, 0, TYP_INODATA },
 	{ "back", FLDT_DIRBLOCK, OI(DBOFF(back)), C1, 0, TYP_INODATA },
 	{ "magic", FLDT_UINT16X, OI(DBOFF(magic)), C1, 0, TYP_NONE },
-	{ "pad", FLDT_UINT16X, OI(DBOFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "pad", FLDT_UINT16X, OI(DBOFF(pad)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
@@ -977,7 +977,7 @@ const field_t	da3_node_hdr_flds[] = {
 	{ "info", FLDT_DA3_BLKINFO, OI(H3OFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(H3OFF(__count)), C1, 0, TYP_NONE },
 	{ "level", FLDT_UINT16D, OI(H3OFF(__level)), C1, 0, TYP_NONE },
-	{ "pad", FLDT_UINT32D, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/dquot.c b/db/dquot.c
index 4e35df4..222c082 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -76,7 +76,7 @@ const field_t	disk_dquot_flds[] = {
 	{ "btimer", FLDT_INT32D, OI(DOFF(btimer)), C1, 0, TYP_NONE },
 	{ "iwarns", FLDT_QWARNCNT, OI(DOFF(iwarns)), C1, 0, TYP_NONE },
 	{ "bwarns", FLDT_QWARNCNT, OI(DOFF(bwarns)), C1, 0, TYP_NONE },
-	{ "pad0", FLDT_INT32D, OI(DOFF(pad0)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "pad0", FLDT_UINT32X, OI(DOFF(pad0)), C1, 0, TYP_NONE },
 	{ "rtb_hardlimit", FLDT_QCNT, OI(DOFF(rtb_hardlimit)), C1, 0,
 	  TYP_NONE },
 	{ "rtb_softlimit", FLDT_QCNT, OI(DOFF(rtb_softlimit)), C1, 0,
@@ -84,7 +84,7 @@ const field_t	disk_dquot_flds[] = {
 	{ "rtbcount", FLDT_QCNT, OI(DOFF(rtbcount)), C1, 0, TYP_NONE },
 	{ "rtbtimer", FLDT_INT32D, OI(DOFF(rtbtimer)), C1, 0, TYP_NONE },
 	{ "rtbwarns", FLDT_QWARNCNT, OI(DOFF(rtbwarns)), C1, 0, TYP_NONE },
-	{ "pad", FLDT_UINT16X, OI(DOFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "pad", FLDT_UINT16X, OI(DOFF(pad)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 

