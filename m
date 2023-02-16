Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC09C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjBPU5E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjBPU5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:57:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA965034B
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:56:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06AB160B42
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E0DC433EF;
        Thu, 16 Feb 2023 20:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581014;
        bh=VtdOvAar+LlFzjfI4PucUHHS/smwnawW8hlc3QUw86Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oXYHuVgVR5qruCBoH0x02UJuGaWvaYy441BvzDIJdpXCkEiT9INODhby2h1Q3als/
         KJBidTxc2kSH7iLYHvy8GDH04ju1MDHEEHnyIM6uETRH4rLxZ39gFSlPIYDBUjnJMI
         IEycqk+k2a3WHqpD9w/TlAXOtnOX/AU5cUTXUfYueTAG4tpTvaQYS9C5LDDjCxKvBU
         2QzS/HH++qnHTmvobmft6gbO4CvsEtDC2021xJkhd8f2YfEaR8dLlUdtwUNPcwnhvI
         uLCbzwkODE/61I5wnSPlNeNIwL3wnyLmyyfZv0VYm+n4kYaYC74OmTbMyIaDdFbWb8
         pYaUheWZ4xUCw==
Date:   Thu, 16 Feb 2023 12:56:53 -0800
Subject: [PATCH 13/25] xfsprogs: add parent attributes to symlink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879079.3476112.4128801881562451403.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_trans_space.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index f7220792..25a55650 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 

