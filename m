Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F17C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjEZBb1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjEZBb0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631EC189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED3FA64C30
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55659C433EF;
        Fri, 26 May 2023 01:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064684;
        bh=IoCgZiE7s3Rjqcw4D3OJxdEsBbS7gvpwrxGpwMAebiw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jfLVN68vXa9cYXx4P2UE1I9hJ28XIdNkyQ3X6GtohETh4vDk4bXp3hm3kIHyV186G
         5NJ6Vx50rNcl5PBt+cezWsUzWXOxFZ7emHyhl9kMpJ90A6PIjIzIbRuGx2tXoFC2aD
         U6VfHnOj6ek1LPDTcsYFgfxgTRFajHvBu1GxKj9VW2w+8tZxCTbE+V1o7+L+/c6/AX
         ZCQr+VzpAjVm97sP6u7USKElDvfnYPcamtrKFMtPkMiuMtnrfRnnOWzClPXul9nKuT
         5JrJ5N9a6SfIF9MGUzmZfI4hLHGQaMFCgzSjDveDE+vLYtZvQpukzvfMv3OZvDlGu+
         1oT1PYH4a4nPw==
Date:   Thu, 25 May 2023 18:31:23 -0700
Subject: [PATCH 4/9] xfs: validate attr remote value buffer owners
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066434.3735378.17969098519472969791.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
References: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check the owner field of xattr remote value blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_remote.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index b8cdd15c4e1a..3dd0b6b0956c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -280,12 +280,12 @@ xfs_attr_rmtval_copyout(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	int			*offset,
 	int			*valuelen,
 	uint8_t			**dst)
 {
 	char			*src = bp->b_addr;
-	xfs_ino_t		ino = dp->i_ino;
 	xfs_daddr_t		bno = xfs_buf_daddr(bp);
 	int			len = BBTOB(bp->b_length);
 	int			blksize = mp->m_attr_geo->blksize;
@@ -299,11 +299,11 @@ xfs_attr_rmtval_copyout(
 		byte_cnt = min(*valuelen, byte_cnt);
 
 		if (xfs_has_crc(mp)) {
-			if (xfs_attr3_rmt_hdr_ok(src, ino, *offset,
+			if (xfs_attr3_rmt_hdr_ok(src, owner, *offset,
 						  byte_cnt, bno)) {
 				xfs_alert(mp,
 "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
-					bno, *offset, byte_cnt, ino);
+					bno, *offset, byte_cnt, owner);
 				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
 			}
@@ -427,8 +427,7 @@ xfs_attr_rmtval_get(
 				return error;
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp,
-							&offset, &valuelen,
-							&dst);
+					args->owner, &offset, &valuelen, &dst);
 			xfs_buf_relse(bp);
 			if (error)
 				return error;

