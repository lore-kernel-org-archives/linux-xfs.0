Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F1FC7FD8
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:11:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE711AC007
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id s8yydy4TBkjLCOhn for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:13 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AGBD8u003825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:13 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s3AGBCQw000747
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 12/20] xfsprogs/db: finobt support
Date: Thu, 10 Apr 2014 12:11:02 -0400
Message-Id: <1397146270-42993-13-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
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

Add the AGI finobt fields and fibt layouts.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/agi.c     |  2 ++
 db/btblock.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/db/agi.c b/db/agi.c
index 398bdbb..6f167ac 100644
--- a/db/agi.c
+++ b/db/agi.c
@@ -57,6 +57,8 @@ const field_t	agi_flds[] = {
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "free_root", FLDT_AGBLOCK, OI(OFF(free_root)), C1, 0, TYP_INOBT },
+	{ "free_level", FLDT_UINT32D, OI(OFF(free_level)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/btblock.c b/db/btblock.c
index 1ea0cff..cdb8b1d 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -60,6 +60,12 @@ struct xfs_db_btree {
 		sizeof(xfs_inobt_rec_t),
 		sizeof(__be32),
 	},
+	{	XFS_FIBT_MAGIC,
+		XFS_BTREE_SBLOCK_LEN,
+		sizeof(xfs_inobt_key_t),
+		sizeof(xfs_inobt_rec_t),
+		sizeof(__be32),
+	},
 	{	XFS_BMAP_CRC_MAGIC,
 		XFS_BTREE_LBLOCK_CRC_LEN,
 		sizeof(xfs_bmbt_key_t),
@@ -84,6 +90,12 @@ struct xfs_db_btree {
 		sizeof(xfs_inobt_rec_t),
 		sizeof(__be32),
 	},
+	{	XFS_FIBT_CRC_MAGIC,
+		XFS_BTREE_SBLOCK_CRC_LEN,
+		sizeof(xfs_inobt_key_t),
+		sizeof(xfs_inobt_rec_t),
+		sizeof(__be32),
+	},
 	{	0,
 	},
 };
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
