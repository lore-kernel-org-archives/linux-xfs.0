Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87236C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 11:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ABE62333F
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 11:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbhAMLR4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 06:17:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:35950 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbhAMLRz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jan 2021 06:17:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610536629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FZdTwyKkf0cyWEtrVipKEpgR3vbT1AfRNaFwxyyVy74=;
        b=QNA2b1hpDM6QbEu3KrMs1jg1TIaaoFuzwcA2neOLiaA3xBRIgXwE4+5HgjvVa0bLBgFCwF
        N3Ike1VCdE+yNsW3Tmrg3M8oNUs36tYSuezeScNbvKLtUrqHFWhnE2EVcMRyn4CVLBQ0Zn
        QLEoOtTDwKKelfdz+cyC51HmsjSeEy0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4F953AEE0;
        Wed, 13 Jan 2021 11:17:09 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Nikolay Borisov <nborisov@suse.com>
Subject: [RFC PATCH 1/3] xfs: Add is_rwsem_write_locked function
Date:   Wed, 13 Jan 2021 13:17:04 +0200
Message-Id: <20210113111707.756662-2-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210113111707.756662-1-nborisov@suse.com>
References: <20210113111707.756662-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is going to be used to check if an rwsem is held for write.
Mimicking what current mrlock->mr_writer variable provides but using
the generic rwsem infrastructure. One might argue that redefining the
locked bit is a layering violation since RWSEM_WRITE_LOCKED is not
exposed, however I'd argue back that this is only used in a debugging
scenario and the physical layout of the rwsem is unlikely to change.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b7352bc4c815..499e63da935c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -345,6 +345,13 @@ xfs_ilock_demote(
 }
 
 #if defined(DEBUG) || defined(XFS_WARN)
+static bool is_rwsem_write_locked(struct rw_semaphore *rwsem)
+{
+	/* Copy of RWSEM_WRITE_LOCKED from rwsem.c */
+#define LOCK_BIT (1UL << 0)
+	return atomic_long_read(&rwsem->count) & LOCK_BIT;
+}
+
 int
 xfs_isilocked(
 	xfs_inode_t		*ip,
-- 
2.25.1

