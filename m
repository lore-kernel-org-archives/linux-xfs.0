Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4B0C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjBPVFF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjBPVFE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:05:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B285F505D3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:05:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 11D2ACE2D78
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5ABC433EF;
        Thu, 16 Feb 2023 21:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581500;
        bh=QV1IyaaqkGuQNVpfSet+j6EQKRL8H/mVL5G1Nw79xXk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=aT+m7HTnn1ei7JL1/DOSQvzD0TKXIXFG9/NsAKRJRcs9ubcdfq/Mxez7JC7Nqy/V7
         7UuoDVR2fUOiSk2sktteADp0jLxUVfE3Wp45oSrWhLe6QaTrclmGPLiPsVpvFxaJVV
         ZGR3h6EmRmijcwe45whMxvAa4pGSXzU4J4x5yko5Rva/HEkT4hD78uHTpJMpC4Z4kg
         hnQxxMPIgTvX+Khs/YyW+dyWEF1CATRWJfkLPhXW52VOzazkCNNL6mOjebrND7bhTc
         +ksR8j0nfmNvKs06ablExcrWHmnNPdKFOEUBiGleGJ+bH1eMJSb1tT1sDZtWb6weju
         27h7mddoaEHjw==
Date:   Thu, 16 Feb 2023 13:04:59 -0800
Subject: [PATCH 07/10] libfrog: only walk one parent pointer at a time in
 handle_walk_parent_path_ptr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880350.3477097.7538603843264282258.stgit@magnolia>
In-Reply-To: <167657880257.3477097.11495108667073036392.stgit@magnolia>
References: <167657880257.3477097.11495108667073036392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

handle_walk_parents already walks each returned parent pointer record,
so we don't need a loop in handle_walk_parent_path_ptr.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/pptrs.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)


diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index ef91a919..8d9e62a2 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -134,26 +134,22 @@ handle_walk_parent_path_ptr(
 {
 	struct walk_ppath_level_info	*wpli = arg;
 	struct walk_ppaths_info		*wpi = wpli->wpi;
-	unsigned int			i;
 	int				ret = 0;
 
 	if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT)
 		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
 
-	for (i = 0; i < pi->pi_ptrs_used; i++) {
-		p = xfs_ppinfo_to_pp(pi, i);
-		ret = path_component_change(wpli->pc, p->xpp_name,
+	ret = path_component_change(wpli->pc, p->xpp_name,
 				strlen((char *)p->xpp_name), p->xpp_ino);
-		if (ret)
-			break;
-		wpli->newhandle.ha_fid.fid_ino = p->xpp_ino;
-		wpli->newhandle.ha_fid.fid_gen = p->xpp_gen;
-		path_list_add_parent_component(wpi->path, wpli->pc);
-		ret = handle_walk_parent_paths(wpi, &wpli->newhandle);
-		path_list_del_component(wpi->path, wpli->pc);
-		if (ret)
-			break;
-	}
+	if (ret)
+		return ret;
+
+	wpli->newhandle.ha_fid.fid_ino = p->xpp_ino;
+	wpli->newhandle.ha_fid.fid_gen = p->xpp_gen;
+
+	path_list_add_parent_component(wpi->path, wpli->pc);
+	ret = handle_walk_parent_paths(wpi, &wpli->newhandle);
+	path_list_del_component(wpi->path, wpli->pc);
 
 	return ret;
 }

