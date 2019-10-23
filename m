Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B04CA9EB6
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 10:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 010F62064A
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 10:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404447AbfJWKhY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 06:37:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:50362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404332AbfJWKhY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Oct 2019 06:37:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 017CAAFC1;
        Wed, 23 Oct 2019 10:37:23 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B3EED1E4A89; Wed, 23 Oct 2019 12:37:22 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>,
        Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Sanity check flags of Q_XQUOTARM call
Date:   Wed, 23 Oct 2019 12:37:19 +0200
Message-Id: <20191023103719.28117-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Flags passed to Q_XQUOTARM were not sanity checked for invalid values.
Fix that.

Fixes: 9da93f9b7cdf ("xfs: fix Q_XQUOTARM ioctl")
Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_quotaops.c | 3 +++
 1 file changed, 3 insertions(+)

Strictly speaking this may cause user visible regression
(invalid flags are no longer getting ignored) but in this particular
case I think we could get away with it.


diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index cd6c7210a373..c7de17deeae6 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -201,6 +201,9 @@ xfs_fs_rm_xquota(
 	if (XFS_IS_QUOTA_ON(mp))
 		return -EINVAL;
 
+	if (uflags & ~(FS_USER_QUOTA | FS_GROUP_QUOTA | FS_PROJ_QUOTA))
+		return -EINVAL;
+
 	if (uflags & FS_USER_QUOTA)
 		flags |= XFS_DQ_USER;
 	if (uflags & FS_GROUP_QUOTA)
-- 
2.16.4

