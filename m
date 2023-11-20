Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB60C197A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 15:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbjKTPLF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 10:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjKTPLE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 10:11:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66458BE
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 07:11:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA93C433C9;
        Mon, 20 Nov 2023 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700493061;
        bh=kqbp2wQEUmnFWF9IEVPTu7Sei4oKZj14Ua3vPSnUqIE=;
        h=From:To:Cc:Subject:Date:From;
        b=VFxL+x5t8uRQ6dunpnULqy1tICW7ZXPpMrEOFlyk4QHODkbdOBEyFXfs9rSB1HU2e
         dLX3z58wtbTE8nNsc1+h1M+V0uxTxXJ7JgrxDOPk2iLsPYG126T2w+/CtR8fyjkd+j
         a8MgbikouzbtFNqFu/I0GqKGXx5I+La11A8ABdwAxJuUSjjyT87w+u8BURJRA5NA1/
         vNZbJRV1d9pYUn6PPM3Nfx/16XxcTPVSxR4kfob+oI+kGkzkOJVmy+7eu7ZcHoRxXo
         LUa39Mn2VFpnd+4tTJqEvRlzF1AX+XvsDB4sK7dfOCaIjxlPYFPU+f06fL/u/nEDdA
         7TM5RrrFFr7bg==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Subject: [PATCH 1/2] libxf-apply: Ignore Merge commits
Date:   Mon, 20 Nov 2023 16:10:46 +0100
Message-ID: <20231120151056.710510-1-cem@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cem@kernel.org>

Merge commits in the kernel tree, only polutes the patch list to be
imported into libxfs, explicitly ignore them.

Signed-off-by: Carlos Maiolino <cem@kernel.org>
---

I'm considering here my own usecase, I never used merge commits, and sometimes
they break the synchronization, so they make no good for me during libxfs-sync.

 tools/libxfs-apply | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 097a695f9..aa2530f4d 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -445,8 +445,8 @@ fi
 
 # grab and echo the list of commits for confirmation
 echo "Commits to apply:"
-commit_list=`git rev-list $hashr | tac`
-git log --oneline $hashr |tac
+commit_list=`git rev-list --no-merges $hashr | tac`
+git log --oneline --no-merges $hashr |tac
 read -r -p "Proceed [y|N]? " response
 if [ -z "$response" -o "$response" != "y" ]; then
 	fail "Aborted!"
-- 
2.41.0

