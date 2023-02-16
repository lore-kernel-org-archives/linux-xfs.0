Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB02CC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjBPUlS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPUlR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:41:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EF0CC0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:41:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EBD260C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB69C433EF;
        Thu, 16 Feb 2023 20:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580075;
        bh=ngHn1aT/JEpttoVPHOFtIHzQ6KyBXFPZNGAnV3RLPtk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=W1gVOxzIOa+2fKrEDsuRiJGuwYkjSFVQke+K11wG0U8PWHzNo4hBWkubBTMqKgFPg
         EsfEOyBHw+dHXyU9lMWVi+bKJrpiIlSOddax499MBcB4tzUHIwd3V6cf41EnfiWplo
         31ZUrRjzflH3ZT+nVvOiLUE4zi4FTXFxv6u1yPvBEW6RfhF4J2YSrMQdhkqj6HNrQV
         Hn1H8EVp2EGhZ+hsUd7gHrZ9NeI0bDOuivYAp8IskmRuQQrxISZMo9rnxqc9D5laQi
         na1ZnBjAGjf3g7ymeNrJMenqv6FG+njXRh8JNP0CGM6gbgznNMLZUFI43RVyMWgewN
         BOhdjoDZckMxg==
Date:   Thu, 16 Feb 2023 12:41:15 -0800
Subject: [PATCH 2/4] xfs: use kvalloc for the parent pointer info buffer
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873464.3474196.18224451151576077528.stgit@magnolia>
In-Reply-To: <167657873432.3474196.15004300376430244372.stgit@magnolia>
References: <167657873432.3474196.15004300376430244372.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's possible that userspace could call us with large(ish) 64k buffer.
Use kvalloc for this, so that the kernel doesn't have to find a
contiguous physical region.  Zero the realloc buffer so that we don't
leak kernel contents to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a1929b08c539..19f71d6eb561 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1702,7 +1702,7 @@ xfs_ioc_get_parent_pointer(
 		return -EPERM;
 
 	/* Allocate an xfs_pptr_info to put the user data */
-	ppi = kmalloc(sizeof(struct xfs_pptr_info), 0);
+	ppi = kvmalloc(sizeof(struct xfs_pptr_info), GFP_KERNEL);
 	if (!ppi)
 		return -ENOMEM;
 
@@ -1729,7 +1729,9 @@ xfs_ioc_get_parent_pointer(
 	 * Now that we know how big the trailing buffer is, expand
 	 * our kernel xfs_pptr_info to be the same size
 	 */
-	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size), 0);
+	ppi = kvrealloc(ppi, sizeof(struct xfs_pptr_info),
+			xfs_pptr_info_sizeof(ppi->pi_ptrs_size),
+			GFP_KERNEL | __GFP_ZERO);
 	if (!ppi)
 		return -ENOMEM;
 
@@ -1774,7 +1776,7 @@ xfs_ioc_get_parent_pointer(
 out:
 	if (call_ip != file_ip)
 		xfs_irele(call_ip);
-	kmem_free(ppi);
+	kvfree(ppi);
 	return error;
 }
 

