Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E432C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3203964EAA
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhBMFeH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:34:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhBMFeF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A614864E68;
        Sat, 13 Feb 2021 05:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194404;
        bh=FYVEQml7T+mXk9rt0BArNzRnHQq6c5j+WIAX0bWJHtg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZlGR+jAYlKYW6jRbYT1Q6FoYpkTe83C4ufLdOqtiNSLYOdOcPdjnafEZ6cx0oLWzm
         tX1X6IHh3OaEZzvIqE8AcXZmM+gjGC3+UIklQy7oahgw0MlD/7thmI7Jza4bcI7Yv/
         zwITfLY9S1cuBIlJivYHQW4AvkI5AgTosAJs1lH24T38hnE5YGavx8WQajbPNdtg7K
         fKa3KoUko5NLoA0CDYp9+SnF8mf+KTAbdq6+7HpvpZWi1aDjEZtxCnFbXUQguZZqFj
         c/lkzsIzpDk5FEx872tEYx9M9ZGjvKHIyPNs582g5SYzsInu06hdnliZmEbVLkZMLX
         WEbM+df1niOUQ==
Subject: [PATCH 1/2] common/xfs: support realtime devices with
 _scratch_xfs_admin
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:33:24 -0800
Message-ID: <161319440432.403424.15638591212385638807.stgit@magnolia>
In-Reply-To: <161319439859.403424.12347303262615931894.stgit@magnolia>
References: <161319439859.403424.12347303262615931894.stgit@magnolia>
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
index fe4dea99..7795856a 100644
--- a/common/xfs
+++ b/common/xfs
@@ -260,9 +260,15 @@ _test_xfs_db()
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

