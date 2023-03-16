Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758C0C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCPT2G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCPT2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5704977E08
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:28:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71F1F620DC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA19AC4339C;
        Thu, 16 Mar 2023 19:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994879;
        bh=9fJd78QrYq4Ag6uwblqrjwOAKaC6AYqzK5FVV+4gDPc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=r1cSQxFRgjL3uPjEtQB7BwUrR/SgX3XOlqw/vPWbW951pGkOtLlk63w+E6lLfbdih
         e9PO53Ncy7/KmwXonaJZsE4mR+hig/1WdHuGx1mRlDLqmXA7iWSrkOnXN/AXWmwdnN
         gpYcyFq9K8ewJvc9XIZatNw/0/RfprZ1/Vk0boY/vyVuOW8BdAEAyBuh+/5F8VWLKt
         UAj0bvp/NKCMIrORwW3l2Z0nWMvFGzjGTfWa5IlrcmlUJy32mMHUPR3TGXwyuoza3a
         NFG8oeK+5ZD3RQqOzlfzikLAvykw5Ywn84ONHmTUj2L7wpLrys0k0Y4vUV3iFPd/2l
         1tTn2WQk6QFDw==
Date:   Thu, 16 Mar 2023 12:27:59 -0700
Subject: [PATCH 8/9] xfs_io: parent command is not experts-only
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415481.16278.10590382222132683875.stgit@frogsfrogsfrogs>
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

This command isn't dangerous, so don't make it experts-only.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/parent.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index b18e02c4b..6af342820 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -250,6 +250,5 @@ parent_init(void)
 	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
 
-	if (expert)
-		add_command(&parent_cmd);
+	add_command(&parent_cmd);
 }

