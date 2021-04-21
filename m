Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D64C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 06:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0303613F0
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 06:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhDUGNg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 02:13:36 -0400
Received: from verein.lst.de ([213.95.11.211]:53106 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230440AbhDUGNg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 02:13:36 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5E0BC68BFE; Wed, 21 Apr 2021 08:13:01 +0200 (CEST)
Date:   Wed, 21 Apr 2021 08:13:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: [PATCH 2/1] xfs: rename struct xfs_legacy_ictimestamp
Message-ID: <20210421061300.GC28961@lst.de>
References: <20210420162603.4057289-1-hch@lst.de> <20210420164209.GG3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420164209.GG3122264@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rename struct xfs_legacy_ictimestamp to struct xfs_log_legacy_timestamp
as it is a type used for logging timestamps with no relationship to the
in-core inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h  | 2 +-
 fs/xfs/xfs_inode_item.c         | 4 ++--
 fs/xfs/xfs_inode_item_recover.c | 4 ++--
 fs/xfs/xfs_ondisk.h             | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 5900772d678a90..3e15ea29fb8de6 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -371,7 +371,7 @@ static inline int xfs_ilog_fdata(int w)
 typedef uint64_t xfs_log_timestamp_t;
 
 /* Legacy timestamp encoding format. */
-struct xfs_legacy_ictimestamp {
+struct xfs_log_legacy_timestamp {
 	int32_t		t_sec;		/* timestamp seconds */
 	int32_t		t_nsec;		/* timestamp nanoseconds */
 };
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6cc4ca15209ce5..6764d12342da3e 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -304,13 +304,13 @@ xfs_inode_to_log_dinode_ts(
 	struct xfs_inode		*ip,
 	const struct timespec64		tv)
 {
-	struct xfs_legacy_ictimestamp	*lits;
+	struct xfs_log_legacy_timestamp	*lits;
 	xfs_log_timestamp_t		its;
 
 	if (xfs_inode_has_bigtime(ip))
 		return xfs_inode_encode_bigtime(tv);
 
-	lits = (struct xfs_legacy_ictimestamp *)&its;
+	lits = (struct xfs_log_legacy_timestamp *)&its;
 	lits->t_sec = tv.tv_sec;
 	lits->t_nsec = tv.tv_nsec;
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 9b877de2ce5e3d..7b79518b6c20b8 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -128,14 +128,14 @@ xfs_log_dinode_to_disk_ts(
 	const xfs_log_timestamp_t	its)
 {
 	struct xfs_legacy_timestamp	*lts;
-	struct xfs_legacy_ictimestamp	*lits;
+	struct xfs_log_legacy_timestamp	*lits;
 	xfs_timestamp_t			ts;
 
 	if (xfs_log_dinode_has_bigtime(from))
 		return cpu_to_be64(its);
 
 	lts = (struct xfs_legacy_timestamp *)&ts;
-	lits = (struct xfs_legacy_ictimestamp *)&its;
+	lits = (struct xfs_log_legacy_timestamp *)&its;
 	lts->t_sec = cpu_to_be32(lits->t_sec);
 	lts->t_nsec = cpu_to_be32(lits->t_nsec);
 
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 66b541b7bb643d..25991923c1a8aa 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -127,7 +127,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
 	XFS_CHECK_STRUCT_SIZE(xfs_log_timestamp_t,		8);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_ictimestamp,	8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_log_legacy_timestamp,	8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
-- 
2.30.1

