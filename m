Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C11C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjBPVFg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjBPVFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:05:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0382B632
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:05:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE547B8217A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBA6C433EF;
        Thu, 16 Feb 2023 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581531;
        bh=jeQTcEnLwNtEyVnstGH88DzGARpu5kuAm98IrTfeDgg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=sSIHdNtRQU5IHgz+Ca0qYKMaZNnJFod5IX5T6x4Oto0lEKf2NT9WqtYhdsRp/24vo
         EplLmpu3Ro8vYwXskQ6NYb0gZhmVGglmKAA3GNGm9GLD60WQh3321Rc/W6chcWCVP3
         N1eO3yznroDSIFBCWEumWmO2E/8jy5m7B1YYoG6rfwrbrmDZamwo91kgLb5uPECFiK
         oijatS3ZxPFwMWr2AUjql6jcR/1F1g325zDpndw69NHbMJkPTbxTvxsCxR9p4dudZU
         W67TxVDKjLmcWpMxCSvtBZF2J1eUcQAf+WXCCH60iG2g0LTx0bWehAoUfGyDQHMVUQ
         w+dawelakOzIA==
Date:   Thu, 16 Feb 2023 13:05:30 -0800
Subject: [PATCH 09/10] xfs_io: parent command is not experts-only
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880376.3477097.9371089403493745661.stgit@magnolia>
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

This command isn't dangerous, so don't make it experts-only.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/parent.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index 694c0839..36522f26 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -275,6 +275,5 @@ parent_init(void)
 	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
 
-	if (expert)
-		add_command(&parent_cmd);
+	add_command(&parent_cmd);
 }

