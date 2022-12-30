Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814E4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbiLaCUO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiLaCUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A0F13F62
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 515E460CF0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC959C433EF;
        Sat, 31 Dec 2022 02:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453211;
        bh=vJdjn54zjoyukZrSLPrjiOEIoWvSWdUm3G6Z/B8aTxU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RLJnE6pFKOjojbDmh18+xJFWgiKZ1xOxI6p2yGcD8v+qJznlpHrCkljFh7PgufQPf
         TzkqjodcHTi+EgV9/SwM9IusdZG1A/z29AF7EkcP+NqCLhqqRhAfWaIuyvFALqp/mS
         Qfzf7o6rHNqLFrkxoDG8xVO2FN/ttvgZF/BLK4wtBx91Z9h8e/Ktoav5KBjHZFpEQ7
         fxEYtqk8W3dn8pgvhQdcTnlGT3aesarbHAaIfjrL2rr0lVjPY7wquRIF3Km4v9yZvz
         aImZ7h9Z+YzL1eLgvPGStoOrp97qCxgtRcNXSISRs0CCPBj6feF3UJFNqiOhDMxOSu
         KVEGr20t5raDA==
Subject: [PATCH 40/46] xfs_repair: metadata dirs are never plausible root dirs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876456.725900.3074310036981491469.stgit@magnolia>
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

Metadata directories are never candidates to be the root of the
user-accessible directory tree.  Update has_plausible_rootdir to ignore
them all, as well as detecting the case where the superblock incorrectly
thinks both trees have the same root.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/xfs_repair.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 53d45c5b189..fe3fe341530 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -530,9 +530,15 @@ has_plausible_rootdir(
 	int			error;
 	bool			ret = false;
 
+	if (xfs_has_metadir(mp) &&
+	    mp->m_sb.sb_rootino == mp->m_sb.sb_metadirino)
+		goto out;
+
 	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip);
 	if (error)
 		goto out;
+	if (xfs_is_metadata_inode(ip))
+		goto out_rele;
 	if (!S_ISDIR(VFS_I(ip)->i_mode))
 		goto out_rele;
 

