Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1784C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiL3Wka (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3Wka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:40:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F3C17E33
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:40:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40603B81C06
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D48C433EF;
        Fri, 30 Dec 2022 22:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440027;
        bh=VRQ/6UlKzAiBE7yPzp4on35PfXVeqyFijwESNoPJjNo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AIgnwvfzty3nR4B9IWN8EGCdD2O/vY0amGeHYKYjRUl93D+QK1Ew6xJsaH6gs4Bt2
         EoxwiraZKRVvQelHTHem0a148DwSB2ohTSQmDvixJaxN+9uMIsGeAy1qE2YeQAshXA
         wN9PB7SVOJU8p37j936ob5xKliCFct4H+Ri8z/6mX2ReY+SMb7K40469laNNinsWST
         byIuPadcKmlPNzn0zByVl1kgJLxm5naOuv9ccpTz9+P4jNpyXoebYnxKqF+R/GWGrH
         mACqZxCKNUhe4Ai0ihOnZiIYr/5VzWHjG7aJhKM4AiqR7/7dp5dYB1ZZlx3+a39lOd
         Y9XnKGeUdINOQ==
Subject: [PATCH 2/3] xfs: hoist rmap record flag checks from scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:15 -0800
Message-ID: <167243827569.684088.7112623579861724945.stgit@magnolia>
In-Reply-To: <167243827537.684088.11219968589590305107.stgit@magnolia>
References: <167243827537.684088.11219968589590305107.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the rmap record flag checks from xchk_rmapbt_rec into
xfs_rmap_check_irec so that they are applied everywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index e66ecd794a84..da008d317f83 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -254,6 +254,11 @@ xfs_rmap_check_irec(
 	if (!is_inode && (is_bmbt || is_unwritten || is_attr))
 		return __this_address;
 
+	/* Check for a valid fork offset, if applicable. */
+	if (is_inode && !is_bmbt &&
+	    !xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))
+		return __this_address;
+
 	return NULL;
 }
 

