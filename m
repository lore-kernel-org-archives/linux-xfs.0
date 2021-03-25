Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E8DC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 23:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9338961A0D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 23:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhCYXT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 19:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231307AbhCYXTd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 19:19:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF65D61A0F;
        Thu, 25 Mar 2021 23:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616714372;
        bh=tKzCvvv88QDjtjKN5JzT/7F4ttkl5n4A/cwERoqky9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RXmSuObW4wtOqZgjUrw0VGu7iZKh1kXag2NGaF8aU1bnAIqa6n4KmKAGFloWgfB0m
         ZDn8xKE2gySFzmI7rW+7rnoGwDHcQivX45DYQL80WV72xGOY8KjwfWA9bDuXLm9E5X
         5afrkJddnG8wcAUiSuDuOuiTU3oRm+A3HHXHRdeV+WAqLV1v5pjUQNrARinD1Vhw9M
         GSl99lNX9hwnvQnabl7631ouAhaX4OgLUIikbBjayObMztTJty5p2m10kOp+GqHRRF
         m7d+uctezMBUVV+GxskvxCNPc1N3IG9dx7ZY90DedH/0aCH4O7/PpOkjF+rMEmZDwy
         G9BlX1sCHMIbw==
Date:   Thu, 25 Mar 2021 16:19:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.1 1/2] common/xfs: support realtime devices with
 _scratch_xfs_admin
Message-ID: <20210325231932.GL1670408@magnolia>
References: <161647323173.3431002.17140233881930299974.stgit@magnolia>
 <161647323723.3431002.10715201555327186329.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647323723.3431002.10715201555327186329.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach _scratch_xfs_admin to support passing the realtime device to
xfs_admin so that we can actually test xfs_admin functionality with
those setups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: fix rt_ops variable naming problems
---
 common/xfs |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index f5e98c1e..06989d1c 100644
--- a/common/xfs
+++ b/common/xfs
@@ -269,9 +269,15 @@ _test_xfs_db()
 _scratch_xfs_admin()
 {
 	local options=("$SCRATCH_DEV")
+	local rt_opts=()
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
