Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767A8C433E5
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58FC8619BC
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCWEVC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhCWEUh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8592761990;
        Tue, 23 Mar 2021 04:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473237;
        bh=djgiOIA2t6B4PdbxlgRaRqXxdVhoX+2/s9d5wFItJDc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JyAQCn5MuXRmpj29djYyd4O83VSzSOCSPYMFcD1OomHV5G2O+AWJ0YY9TVK0NaUA+
         yuYDwO7+qD7Zh22MLfByR5nPEyQVv2/78ToJoXfZY0mVoiTeXCKHB4aliXbQWSKSxq
         hTckeJ9OD3XnDy0RwbBjRNQ9HCMG356eq08oelVZHALE0mnDq7QnjowCndQaECuxvd
         ysYlNVyNnfuzASn/7N1HOIV/PLLeH14kT04xOVTCNvh4DZt+I6lP+mT6s18ckm/cKl
         asMblMuuj8j065ZXMxRFddByG8nij9xRyx/FPNpwZiS8rlH+oEKlciwFqXFsOW3r1T
         3vlcm/RMRekGQ==
Subject: [PATCH 1/2] common/xfs: support realtime devices with
 _scratch_xfs_admin
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:37 -0700
Message-ID: <161647323723.3431002.10715201555327186329.stgit@magnolia>
In-Reply-To: <161647323173.3431002.17140233881930299974.stgit@magnolia>
References: <161647323173.3431002.17140233881930299974.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach _scratch_xfs_admin to support passing the realtime device to
xfs_admin so that we can actually test xfs_admin functionality with
those setups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/common/xfs b/common/xfs
index 69f76d6e..9cb373ba 100644
--- a/common/xfs
+++ b/common/xfs
@@ -269,9 +269,15 @@ _test_xfs_db()
 _scratch_xfs_admin()
 {
 	local options=("$SCRATCH_DEV")
+	local rtopts=()
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		options+=("$SCRATCH_LOGDEV")
-	$XFS_ADMIN_PROG "$@" "${options[@]}"
+	if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ]; then
+		$XFS_ADMIN_PROG --help 2>&1 | grep -q 'rtdev' || \
+			_notrun 'xfs_admin does not support rt devices'
+		rt_opts+=(-r "$SCRATCH_RTDEV")
+	fi
+	$XFS_ADMIN_PROG "${rt_opts[@]}" "$@" "${options[@]}"
 }
 
 _scratch_xfs_logprint()

