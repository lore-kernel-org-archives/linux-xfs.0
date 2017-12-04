Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42532 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdLDXyK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Dec 2017 18:54:10 -0500
Subject: [PATCH 1/5 V2] xfs_db: print structure padding fields consistently
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
 <151094860737.27182.5422098949147661107.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bb3d13c6-d692-7ac4-852e-00f8523cffef@sandeen.net>
Date: Mon, 4 Dec 2017 17:54:09 -0600
MIME-Version: 1.0
In-Reply-To: <151094860737.27182.5422098949147661107.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We are very inconsistent about how we print padding fields in on-disk
structures -- sometimes we hide it from printall, sometimes we deviate
from unsigned hex values, etc.  Make this all consistent -- always hide
padding values when printing the whole structure, always print them as
unsigned hex integers when explicitly requested.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[sandeen: switch to never-print instead of always-print]
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

V2: constant-ify by never printing instead of always printing,
    but still make format consistent.

diff --git a/db/attr.c b/db/attr.c
index 75fe239..9cbb20d 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -589,7 +589,7 @@ const field_t	attr3_node_hdr_flds[] = {
 	{ "info", FLDT_ATTR3_BLKINFO, OI(H3OFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(H3OFF(__count)), C1, 0, TYP_NONE },
 	{ "level", FLDT_UINT16D, OI(H3OFF(__level)), C1, 0, TYP_NONE },
-	{ "pad", FLDT_UINT32D, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(H3OFF(__pad32)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/dir2.c b/db/dir2.c
index 3e21a7b..7f7ea5a 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -977,7 +977,7 @@ const field_t	da3_node_hdr_flds[] = {
 	{ "info", FLDT_DA3_BLKINFO, OI(H3OFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(H3OFF(__count)), C1, 0, TYP_NONE },
 	{ "level", FLDT_UINT16D, OI(H3OFF(__level)), C1, 0, TYP_NONE },
-	{ "pad", FLDT_UINT32D, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(H3OFF(__pad32)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/dquot.c b/db/dquot.c
index 4e35df4..4fd1289 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -76,7 +76,7 @@ const field_t	disk_dquot_flds[] = {
 	{ "btimer", FLDT_INT32D, OI(DOFF(btimer)), C1, 0, TYP_NONE },
 	{ "iwarns", FLDT_QWARNCNT, OI(DOFF(iwarns)), C1, 0, TYP_NONE },
 	{ "bwarns", FLDT_QWARNCNT, OI(DOFF(bwarns)), C1, 0, TYP_NONE },
-	{ "pad0", FLDT_INT32D, OI(DOFF(pad0)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "pad0", FLDT_UINT32X, OI(DOFF(pad0)), C1, FLD_SKIPALL, TYP_NONE },
 	{ "rtb_hardlimit", FLDT_QCNT, OI(DOFF(rtb_hardlimit)), C1, 0,
 	  TYP_NONE },
 	{ "rtb_softlimit", FLDT_QCNT, OI(DOFF(rtb_softlimit)), C1, 0,

