Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996BDC388F7
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 19:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58C6320897
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 19:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgKITKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 14:10:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:51158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730189AbgKITKU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Nov 2020 14:10:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0809AB004;
        Mon,  9 Nov 2020 19:10:19 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] xfs: show the dax option in mount options.
Date:   Mon,  9 Nov 2020 20:10:08 +0100
Message-Id: <f9f7ba25e97dacd92c09eb3ee6a4aca8b4f72b00.1604948373.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1604948373.git.msuchanek@suse.de>
References: <cover.1604948373.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs accepts both dax and dax_enum but shows only dax_enum. Show both
options.

Fixes: 8d6c3446ec23 ("fs/xfs: Make DAX mount option a tri-state")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e3e229e52512..a3b00003840d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -163,7 +163,7 @@ xfs_fs_show_options(
 		{ XFS_MOUNT_GRPID,		",grpid" },
 		{ XFS_MOUNT_DISCARD,		",discard" },
 		{ XFS_MOUNT_LARGEIO,		",largeio" },
-		{ XFS_MOUNT_DAX_ALWAYS,		",dax=always" },
+		{ XFS_MOUNT_DAX_ALWAYS,		",dax,dax=always" },
 		{ XFS_MOUNT_DAX_NEVER,		",dax=never" },
 		{ 0, NULL }
 	};
-- 
2.26.2

