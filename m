Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D189C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjBPVCS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjBPVCQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:02:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4019C52CCC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:02:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFE82B829AB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C8CC433D2;
        Thu, 16 Feb 2023 21:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581326;
        bh=lGxe/3NSkCR2N4qIznRETgwDZYuohvDsOAEyphDQIak=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ak5xHSkt0Z/C1uXpGG0C8XSBxO3qLN6laJoZO6ihIn5qDCaZiA0cDBpRaUZ/XTGeY
         jIGv5HqBAWGt4QgCF150QASnXqKa8A5ys+hCI41ZcJjvM/TtMD03GvSP1Jl4ERUlZN
         tKk1gBLQ4ZJGwqesu7r0+PobXcelNuq0dQHAN56V7695Vp8oY8yau56WT+Ue+5yQWJ
         vrezJOo+seUqMGhqLgO1+QPIKXSw6mN2KCUtlAhkzsgwu0/p9JfjgdVwMjdKeZqyxK
         fn3kryRNKrrEx5hcyCEpjuBumS5D0VuhhHvHPUnjbPYHBm62q4OqNNePZXSNoHIP4e
         Quuf61lcteTgg==
Date:   Thu, 16 Feb 2023 13:02:06 -0800
Subject: [PATCH 2/6] mkfs: fix libxfs api misuse
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879922.3476911.12374504204515101304.stgit@magnolia>
In-Reply-To: <167657879895.3476911.2211427543938389071.stgit@magnolia>
References: <167657879895.3476911.2211427543938389071.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix libxfs usage problems as pointed out by xfs/437.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/proto.c             |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index f8efcce7..e44b0b29 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -124,6 +124,7 @@
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
+#define xfs_init_parent_name_rec	libxfs_init_parent_name_rec
 
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 36d8cde2..ac7ffbe9 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -613,8 +613,8 @@ parseproto(
 			.value = (void *)xname.name,
 			.valuelen = xname.len,
 		};
-		xfs_init_parent_name_rec(&rec, pip, offset);
-		error = xfs_attr_set(&args);
+		libxfs_init_parent_name_rec(&rec, pip, offset);
+		error = -libxfs_attr_set(&args);
 		if (error)
 			fail(_("Error creating parent pointer"), error);
 	}

