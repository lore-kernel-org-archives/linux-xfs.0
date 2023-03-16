Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6CAC6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjCPT03 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCPT02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:26:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4385F4393E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:26:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEFC6620F5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FD9C433EF;
        Thu, 16 Mar 2023 19:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994786;
        bh=AmApFvqePLIKF4FAie0JOquoAlMKO/Af0U4G6HlmnZU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=o/A0vRXkukkNzxG8OcQUKZbEfv/1K8GKH5XvNjTjXOMX9H1ZUfZfqI5+mr6NVIKvl
         aKIlfChhg8BNSmmKAeoC8GfR8MbRFDCJ5DLxmnu+QKpapsIAUk1WWMAYqJWNoENyiY
         oKkQaIQBSV6ST7s/eoXtH390uiu7Ys2bRCWH6Kbv1bUZd5xwjZp1olLOvKja+b90Eu
         /gujJIdgyb8dkStRQX2yWt/C6AdGRp+8Z9BtLHdsaXKPAW6qPCNMAHQVt9EmyaNCFa
         zMRxo4PYtTOaO8YeNG9F9bgiGa7g50j75jrRB992btNBJO+TWCFTiiXTHkcRE0Yl43
         BaaBvE6p6S0+g==
Date:   Thu, 16 Mar 2023 12:26:25 -0700
Subject: [PATCH 2/9] mkfs: fix libxfs api misuse
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415403.16278.8241552212949054742.stgit@frogsfrogsfrogs>
In-Reply-To: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
References: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
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
index f8efcce77..e44b0b29e 100644
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
index 36d8cde21..ac7ffbe9d 100644
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

