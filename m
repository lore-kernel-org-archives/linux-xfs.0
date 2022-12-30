Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0A2C46467
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiLaDXG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236371AbiLaDWn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:22:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E1512AB2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 993D461D65
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06298C433D2;
        Sat, 31 Dec 2022 03:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456962;
        bh=jxPD6AMno68mYlUWqi8+37x51cTNTquJcuYDcCQEENc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nWzffMecSfaZWRyNFl7Q9eXdGHSgVT0DyONJnkept8YjsQs5rshEUNje5pIcEkm4H
         6xdOiYvnkMts8BtKSNeARSZDgTMgZ6RlMTH4z1bB6kcgEcVTSG5Y5PC58jyTMt9oQk
         N40d104lhGqYrUJ08Vr7RTb44aY7MhmMVIXtr12Di3wjk8bFOt6RA8zghh1IKlhY9U
         WrSX1McLL9z5/6vRBdFQRBlZH1IJukGcowKKLQzEMgWCdBTtposkExFsFWvKVjuRao
         USIp6umat6Fvk8tzpNDir3SaZQkNOckKWs/AfNWNlFrsz4NkyOOZyi/SsYnog0yPYa
         dziS35kT6KcEQ==
Subject: [PATCH 1/3] xfs: only free posteof blocks on first close
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876038.726374.1959841327619200697.stgit@magnolia>
In-Reply-To: <167243876021.726374.15071907725836376245.stgit@magnolia>
References: <167243876021.726374.15071907725836376245.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Certain workloads fragment files on XFS very badly, such as a software
package that creates a number of threads, each of which repeatedly run
the sequence: open a file, perform a synchronous write, and close the
file, which defeats the speculative preallocation mechanism.  We work
around this problem by only deleting posteof blocks the /first/ time a
file is closed to preserve the behavior that unpacking a tarball lays
out files one after the other with no gaps.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d50cbd0eb260..f0e44c96b769 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1381,9 +1381,7 @@ xfs_release(
 		if (error)
 			goto out_unlock;
 
-		/* delalloc blocks after truncation means it really is dirty */
-		if (ip->i_delayed_blks)
-			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
+		xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
 	}
 
 out_unlock:

