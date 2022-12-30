Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F06DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbiLaCfQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaCfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:35:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EA11CB1F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:35:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6674761A32
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83E1C433EF;
        Sat, 31 Dec 2022 02:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454113;
        bh=Cpdtn+YwVxZiD4sZo/Mo6nxdqUAjt6hlWF8P5YlX0Yk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PM/Vkg+il2dLnrUZwKx4iSd87PgHKgZYthbIFhEUfW1dyIdkbyO/7OfpXtDUZXWT9
         ZM5PAGzcLsB+K21+0RwzWfbThqvRI4tDjoQkkep2lRztQQoSVyF+6hqzNo8w5YPuPp
         dSvdlJ5SGMz/pJ3ShW2n7/RZNgXhOKpYy45H6n+Iks+0iEvsFY/+GvVT9kHrc7WIAM
         slGRNgRtyBeDUIOgpI5JbKwExMeHSiMa2/ovOjvakab6GAmsB7cc1nDsCRTwVHOfrN
         kXH+7z2lPEKxfOIl9RJP9i4NX9M9FTT+fnzKS/dj/U8KTqaZ234NKENqVHt5AxaETN
         j39MWSGgnzTgw==
Subject: [PATCH 20/45] libfrog: report rt groups in output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:46 -0800
Message-ID: <167243878628.731133.15946823593658902489.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report realtime group geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsgeom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 3f4c38d1e1b..66e813a863f 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -63,7 +63,8 @@ xfs_report_geom(
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
-"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
+"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
+"         =%-22s rgcount=%-4d rgsize=%u blks\n"),
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
@@ -78,7 +79,8 @@ xfs_report_geom(
 		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
 		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
-			(unsigned long long)geo->rtextents);
+			(unsigned long long)geo->rtextents,
+		"", geo->rgcount, geo->rgblocks);
 }
 
 /* Try to obtain the xfs geometry.  On error returns a negative error code. */

