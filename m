Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC08C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbiLaDQT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236347AbiLaDQO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:16:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950C31021;
        Fri, 30 Dec 2022 19:16:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3150561D13;
        Sat, 31 Dec 2022 03:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9217EC433D2;
        Sat, 31 Dec 2022 03:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456572;
        bh=sTVMu5E9IQhwbE2zne25D5bc5o6/8AXt8uYNzmSb1rg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YeU2U/ren37JKgw+49FvWJPtZAxjIFVMLJGUbLkbgS1s4zgd8RYxmnGvvZZDR3As0
         AWfYsp75u2MdmrXQkqtNLTDk1KTEJNRXaxcC2D6VsTTRRa9qsO9Z8M8eDsgjGGXP+S
         nPKQVTQ+rl0FoWx4f9kem3FwbYu3Lj08hSO4LySkWE0lTfq0hQrH44fguj9iiAEASp
         mP2hB3CGxxM2ESCoBs0I7YyDKojn57Sei4oOXXi7oRWKzWHi5HdYfSu8dvM5EjoGkZ
         2YHKfQVkIzCLe8AxG1S5jNQ6kFJ3cQ3AKGD/jfqNX+pVtD8LyKElF8oNCwsJ1hX9j2
         1Jg/ufKRrj9Fw==
Subject: [PATCH 01/10] xfs/122: update fields for realtime reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:48 -0800
Message-ID: <167243884866.740253.14358952001799945323.stgit@magnolia>
In-Reply-To: <167243884850.740253.18400210873595872110.stgit@magnolia>
References: <167243884850.740253.18400210873595872110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a few more ondisk structures for realtime reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index e0801f9660..3239a655f9 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -116,6 +116,9 @@ sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
 sizeof(struct xfs_rtbuf_blkinfo) = 48
 sizeof(struct xfs_rtgroup_geometry) = 128
+sizeof(struct xfs_rtrefcount_key) = 4
+sizeof(struct xfs_rtrefcount_rec) = 12
+sizeof(struct xfs_rtrefcount_root) = 4
 sizeof(struct xfs_rtrmap_key) = 20
 sizeof(struct xfs_rtrmap_rec) = 24
 sizeof(struct xfs_rtrmap_root) = 4

