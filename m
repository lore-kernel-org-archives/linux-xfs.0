Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14EAC4321E
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 17:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E9E611CA
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 17:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhIORY0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 13:24:26 -0400
Received: from sandeen.net ([63.231.237.45]:33376 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhIORYY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 13:24:24 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 924E578C9; Wed, 15 Sep 2021 12:22:53 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     dan.j.williams@intel.com
Subject: [PATCH 2/3] ext4: remove dax EXPERIMENTAL warning
Date:   Wed, 15 Sep 2021 12:22:40 -0500
Message-Id: <1631726561-16358-3-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1631726561-16358-1-git-send-email-sandeen@redhat.com>
References: <1631726561-16358-1-git-send-email-sandeen@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As there seems to be no significant outstanding concern about
dax on ext4 at this point, remove the scary EXPERIMENTAL
warning when in use.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0775950..82948d6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2346,8 +2346,6 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 					     "both data=journal and dax");
 				    return -1;
 			}
-			ext4_msg(sb, KERN_WARNING,
-				"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 			sbi->s_mount_opt |= EXT4_MOUNT_DAX_ALWAYS;
 			sbi->s_mount_opt2 &= ~EXT4_MOUNT2_DAX_NEVER;
 			break;
-- 
1.8.3.1

