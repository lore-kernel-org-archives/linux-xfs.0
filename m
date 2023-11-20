Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD8BC197A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 19:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjKTTfZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 14:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjKTTfY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 14:35:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3611BB9
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 11:35:21 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6177C433C8;
        Mon, 20 Nov 2023 19:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700508920;
        bh=Oyk70GbW6Tj0CE5UHvYe7fszuQmextVmqY/WFoNDt6w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JvWfvxv2PzsaviUjgyubDrOxzn82b/2DPAi0eG30NMDQ7J7IcaehUsJB8KomxImlY
         qFgADVt+mZ+ajnOZfxlmoYPH1D/PlC/AaU5EmNlRfPTVXua/ugr/PQ5L3fIgi+0UxN
         Bpmj06BNevsRIsVgk6jofA4Siin/5NVeCKnMIBig683VU8Ixv/502CCEvhwjtaRPWx
         8AR4hXw0dd9WgTLo/8FtQLE2UR1si/3JLCjAFqzI5lIKnZGOSg04U11sjUxZQYiSdO
         +hTovDlSMx7ye8nojwgp7TT3Y020KB6dkNTTY8Nf5Ut6Lof2gzlsg4kd8nPLQnJlvO
         52mNAcHUJbH+Q==
Subject: [PATCH 2/2] xfs/604: add missing falloc test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Date:   Mon, 20 Nov 2023 11:35:20 -0800
Message-ID: <170050892015.536459.5750821914760062267.stgit@frogsfrogsfrogs>
In-Reply-To: <170050890870.536459.4420904342934916414.stgit@frogsfrogsfrogs>
References: <170050890870.536459.4420904342934916414.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test requires both the xfs_io falloc and fpunch commands to run.
falloc isn't supported on alwayscow=1 mounts, which means this test
fails there.

While we're at it, update the commit id since the fix was committed to
6.7-rc2.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/604 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/604 b/tests/xfs/604
index 50cdebcd50..bb6db797e5 100755
--- a/tests/xfs/604
+++ b/tests/xfs/604
@@ -13,9 +13,10 @@ _begin_fstest auto prealloc punch
 
 _supported_fs xfs
 _require_scratch
+_require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
 _require_test_program punch-alternating
-_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: fix internal error from AGFL exhaustion"
+_fixed_by_kernel_commit f63a5b3769ad "xfs: fix internal error from AGFL exhaustion"
 
 # Disable the rmapbt so we only need to worry about splitting the bnobt and
 # cntbt at the same time.

