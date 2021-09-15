Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46956C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 17:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3512061242
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 17:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhIORYZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 13:24:25 -0400
Received: from sandeen.net ([63.231.237.45]:33378 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhIORYY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 13:24:24 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id AB44579F9; Wed, 15 Sep 2021 12:22:53 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     dan.j.williams@intel.com
Subject: [PATCH 3/3] ext2: remove dax EXPERIMENTAL warning
Date:   Wed, 15 Sep 2021 12:22:41 -0500
Message-Id: <1631726561-16358-4-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1631726561-16358-1-git-send-email-sandeen@redhat.com>
References: <1631726561-16358-1-git-send-email-sandeen@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As there seems to be no significant outstanding concern about
dax on ext2 at this point, remove the scary EXPERIMENTAL
warning when in use.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext2/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d8d580b..1915733 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -587,8 +587,6 @@ static int parse_options(char *options, struct super_block *sb,
 			fallthrough;
 		case Opt_dax:
 #ifdef CONFIG_FS_DAX
-			ext2_msg(sb, KERN_WARNING,
-		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 			set_opt(opts->s_mount_opt, DAX);
 #else
 			ext2_msg(sb, KERN_INFO, "dax option not supported");
-- 
1.8.3.1

