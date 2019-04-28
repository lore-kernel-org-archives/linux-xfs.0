Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53862 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfD1MBg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Apr 2019 08:01:36 -0400
Received: from clnet-b08-202.ikbnet.co.at ([83.175.123.202] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hKiUx-0002TS-OS
        for linux-xfs@vger.kernel.org; Sun, 28 Apr 2019 12:01:36 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: don't parse the mtpt mount option
Date: Sun, 28 Apr 2019 14:00:57 +0200
Message-Id: <20190428120057.14503-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The text isn't really any more useful than the default unknown option
handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f093ea244849..d1bd55d87f49 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -66,7 +66,7 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 enum {
 	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
 	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
-	Opt_mtpt, Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
+	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
 	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
 	Opt_noikeep, Opt_largeio, Opt_nolargeio, Opt_attr2, Opt_noattr2,
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
@@ -87,7 +87,6 @@ static const match_table_t tokens = {
 	{Opt_sunit,	"sunit=%u"},	/* data volume stripe unit */
 	{Opt_swidth,	"swidth=%u"},	/* data volume stripe width */
 	{Opt_nouuid,	"nouuid"},	/* ignore filesystem UUID */
-	{Opt_mtpt,	"mtpt"},	/* filesystem mount point */
 	{Opt_grpid,	"grpid"},	/* group-ID from parent directory */
 	{Opt_nogrpid,	"nogrpid"},	/* group-ID from current process */
 	{Opt_bsdgroups,	"bsdgroups"},	/* group-ID from parent directory */
@@ -236,9 +235,6 @@ xfs_parseargs(
 			if (!mp->m_logname)
 				return -ENOMEM;
 			break;
-		case Opt_mtpt:
-			xfs_warn(mp, "%s option not allowed on this system", p);
-			return -EINVAL;
 		case Opt_rtdev:
 			kfree(mp->m_rtname);
 			mp->m_rtname = match_strdup(args);
-- 
2.20.1
