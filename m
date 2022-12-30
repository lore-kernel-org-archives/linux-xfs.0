Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10014C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbiLaCT7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiLaCT5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:19:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3E713F7E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:19:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC36E61C19
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24619C433D2;
        Sat, 31 Dec 2022 02:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453196;
        bh=BZLMUXaNCLK1GkfOXXa5aEYMx8KZn6EiDRKdY+WYN7A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sx7/yNASBNW4/T/sHwv8Y5dnsQeaGrAV9srhmLrpvkuoP6otfx21uBMjw7V/twTAa
         S5AyGvxmNIfXDBkWf8AZ4ONAW5gWsfA/uPGblkRnHWyG7lMLhSHjWqXyqgEM6hQgrS
         pDoRtfQJvdIgpfLY2hssXt2vLgoBZ0UWvPCJwG+DWW/RhPBUQKKH+AbX/prmq5BI0w
         IzUTGaakL2kNAdZQKYiZ8VQxYpFZ4hkbOZJmE6WnNavpqRsuHcX7xkjtsRNcEKZ6Pw
         /9De8QPGHyK3wgDVk8CTjSKmEVb49Np7ZbORGH8kJaOINwvAv23L225TZABcdoilSX
         GlHAOPvhMh1xQ==
Subject: [PATCH 39/46] xfs_repair: adjust keep_fsinos to handle metadata
 directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876443.725900.5476388310002551122.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

On a filesystem with metadata directories, we only want to automatically
mark the two root directories present because those are the only two
statically allocated inode numbers -- the rt summary inode is now just a
regular file in a directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase5.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 361e5649b29..252442c9fd8 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -421,13 +421,14 @@ static void
 keep_fsinos(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	int			i;
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 
-	for (i = 0; i < 3; i++)
-		set_inode_used(irec, i);
+	set_inode_used(irec, 0);	/* root dir */
+	set_inode_used(irec, 1);	/* rt bitmap or metadata dir root */
+	if (!xfs_has_metadir(mp))
+		set_inode_used(irec, 2);	/* rt summary */
 }
 
 static void

