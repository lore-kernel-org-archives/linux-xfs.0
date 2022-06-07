Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF1BC43334
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 01:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiFHBMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842708AbiFHAJ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 20:09:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDEC20E6E0
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 14:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAFF4618D3
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 21:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473DEC3411C;
        Tue,  7 Jun 2022 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654635800;
        bh=FLxXZAWuxC7O0Fm+om5dY6kd16B52wMe5sXvPb8Mmus=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iz0mydMmw1u8TkteesNbzZDcDN59Y5uFa03hMGLoywKXyBZt4RzAJb+Tw9C4KDYS2
         e8fn2/U5bMckUdtIvDjLbDSJhU2kjaAYJ8TEEouL/DLSQ8Jn1xXK6qVRJLCCUIoP3M
         /v/ZQX4Kcf5PogtjZO/3ru9dteSY8+9SEj8CC4BWPUfXvaUVxJcv2IPrYcLWbie2Hh
         jbjuWVdyV7OdbehdITlIB//iSiuvabNE57CSj2cbyCjBRJN0qoQEWHnwMjHKHP3k74
         R7LfmoOFGMGzW/n5yoX1jUtej8B5IvXh0br+hjDd7fEitIw75nGfU5I5koTsdZ5ugd
         9WsmlWklS4oSg==
Subject: [PATCH 3/3] xfs: preserve DIFLAG2_NREXT64 when setting other inode
 attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com, chandan.babu@oracle.com
Date:   Tue, 07 Jun 2022 14:03:19 -0700
Message-ID: <165463579982.417102.16435790324978634359.stgit@magnolia>
In-Reply-To: <165463578282.417102.208108580175553342.stgit@magnolia>
References: <165463578282.417102.208108580175553342.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It is vitally important that we preserve the state of the NREXT64 inode
flag when we're changing the other flags2 fields.

Fixes: 9b7d16e34bbe ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5a364a7d58fd..0d67ff8a8961 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1096,7 +1096,8 @@ xfs_flags2diflags2(
 {
 	uint64_t		di_flags2 =
 		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
-				   XFS_DIFLAG2_BIGTIME));
+				   XFS_DIFLAG2_BIGTIME |
+				   XFS_DIFLAG2_NREXT64));
 
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;

