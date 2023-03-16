Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1367CC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjCPTaK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjCPTaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1638E77E00
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DA28620EB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA017C4339E;
        Thu, 16 Mar 2023 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995004;
        bh=FgP25QasVGi1HXwOnRihELZ5cgFmJw7oQXQ2X2+/DwI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=nvVANrxUGfuRFDDQmijTpxhKO22DJy7rp0TruQTP2im1mxVFYK+m9TWUp/TQ25kpP
         2yy7dkGHD1CSIEfWeRIltLnldVWvxsOisuN6ANlda0Yj4uYLkhaGZw6/zaMCMnbhM+
         jiZx4OlmtaqEJ3QtsQK2RMNyvKuMcuWnyLcJfgFOpBkmYGyjHdJ9k4c55hDozRSobK
         78G/sGQFI3Bq3FckKhRcvBL9eAJSdAMVXagQlgNlVeC9LGCl/kNh3U4Duhu1jZVXWB
         Xx9J7QSuOFMN5lmjY+ZysLQs6TcrWSDVNQGJyRUCuig26Erwaby2YIXCmGdFptKh53
         oTN5+rVrn98Jg==
Date:   Thu, 16 Mar 2023 12:30:04 -0700
Subject: [PATCH 5/7] libfrog: only walk one parent pointer at a time in
 handle_walk_parent_path_ptr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416135.16628.9821897460513031802.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
References: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
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
index ac7fcea28..b61a4e005 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -133,26 +133,22 @@ handle_walk_parent_path_ptr(
 {
 	struct walk_ppath_level_info	*wpli = arg;
 	struct walk_ppaths_info		*wpi = wpli->wpi;
-	unsigned int			i;
 	int				ret = 0;
 
 	if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT)
 		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
 
-	for (i = 0; i < pi->pi_count; i++) {
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

