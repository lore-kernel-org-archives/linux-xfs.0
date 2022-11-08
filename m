Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E04C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Nov 2022 01:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiKHBbR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 20:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbiKHBay (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 20:30:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4672AE21
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 17:29:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 697F461366
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 01:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA38CC433C1
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 01:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667870942;
        bh=keyt8RrlCMib3YEicAg2Q7Doq3R+3mr8ZJj4IrYKQg4=;
        h=Date:From:To:Subject:From;
        b=mgtPPv6i8ZwioGjwuwMdsK0grI8JUP6ZUVfu+f4Vbbjx1+IOl5zXTFpap/zS902OR
         M4xNARPACSpHc27LtJHz3KasAdlEa/A0FvsKsMHIahNw+OO3u2acjrN3XqPymRMfDO
         j5tI0vD9ISBkDlUqllZV1UAJq9NuuKvbXil3D9FXSWKain7PH00EGhuP1B7PJ7CQMM
         Cbrv/elOffNT3SYaMv+zc1PHZb/UVv6DLMX1BDjBR923gws4YLNZprKCTpanNoIDae
         jmOXNKF977rzW6KFUYHkEiuhkRNwEma4ACL34vSUsk/gPJ92aoTXk9t0psAkGSeTot
         mbP7QmKxztLyw==
Date:   Mon, 7 Nov 2022 17:29:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix incorrect error-out in xfs_remove
Message-ID: <Y2mw3oZ2YVyReWeg@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clean up resources if resetting the dotdot entry doesn't succeed.
Observed through code inspection.

Fixes: 5838d0356bb3 ("xfs: reset child dir '..' entry when unlinking child")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aa303be11576..d354ea2b74f9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2479,7 +2479,7 @@ xfs_remove(
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
 					tp->t_mountp->m_sb.sb_rootino, 0);
 			if (error)
-				return error;
+				goto out_trans_cancel;
 		}
 	} else {
 		/*
