Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A56C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiLaDKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbiLaDKs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:10:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340A6C7D;
        Fri, 30 Dec 2022 19:10:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE62D61C7A;
        Sat, 31 Dec 2022 03:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26016C433D2;
        Sat, 31 Dec 2022 03:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456246;
        bh=SaTtuIDKWjtXJHTCqaBfB3+SSvG07GWba4d4SvzcejE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f1PPDlPmUq5Xu6o7C1qex0Lt7D6sW22TikTeHu0QygTf3Kb2RQrKn9V7xEcudtPdS
         OqlxjLne8za9L6BaojbSbmJU8MdvvS6zi9mqdIe8KzmhFq7f62uOV/dXM/5Zgnh00t
         lwSPldp3EnWmpRreDGLdW+UMOfDbAZeF3qc9qesVbHbvh+WZl2oqLkZqavySSLoaSU
         qHApDAMRL/CjZQ/rVpk4Aj2XG86KC8GSKNqMYAjAkrDLDwG+kLCB1G4xskoQBhXeRH
         Kj97NB/OrTdiXbFEM5f5XujAHoklTHTNRhkAQbeVx5wfF/ev2MKTEWB1X0AV9kNwC2
         ueMrsrRtZMmeg==
Subject: [PATCH 05/12] common: filter rtgroups when we're disabling metadir
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884013.739029.9709263667215231940.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we're forcing a filesystem to be created without the metadir feature,
we should forcibly disable rtgroups as well.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/xfs b/common/xfs
index 0d1e0ec4bc..ccdcf45d0d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1821,6 +1821,10 @@ _scratch_xfs_find_metafile()
 # Force metadata directories off.
 _scratch_xfs_force_no_metadir()
 {
+	if echo "$MKFS_OPTIONS" | grep -q 'rtgroups='; then
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/rtgroups=\([01]\)/rtgroups=0/g')"
+	fi
+
 	if echo "$MKFS_OPTIONS" | grep -q 'metadir='; then
 		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/metadir=\([01]\)/metadir=0/g')"
 		return

