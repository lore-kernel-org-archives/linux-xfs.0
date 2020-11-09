Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5783EC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 19:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 174FC20789
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 19:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgKITKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 14:10:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:51200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730205AbgKITKV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Nov 2020 14:10:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E1F1DB016;
        Mon,  9 Nov 2020 19:10:19 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ext4: show the dax option in mount options
Date:   Mon,  9 Nov 2020 20:10:09 +0100
Message-Id: <936bf701626dfdf5b2e51186067cf5e5f5bdb282.1604948373.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1604948373.git.msuchanek@suse.de>
References: <cover.1604948373.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

ext4 accepts both dax and dax_always option but shows only dax_always.
Show both options.

Fixes: 9cb20f94afcd ("fs/ext4: Make DAX mount option a tri-state")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ef4734b40e2a..7656c519cbe6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2647,7 +2647,7 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 		if (IS_EXT2_SB(sb))
 			SEQ_OPTS_PUTS("dax");
 		else
-			SEQ_OPTS_PUTS("dax=always");
+			SEQ_OPTS_PUTS("dax,dax=always");
 	} else if (test_opt2(sb, DAX_NEVER)) {
 		SEQ_OPTS_PUTS("dax=never");
 	} else if (test_opt2(sb, DAX_INODE)) {
-- 
2.26.2

