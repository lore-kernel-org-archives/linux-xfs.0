Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D45C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3235061953
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhCaBIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhCaBIM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B08E619C1;
        Wed, 31 Mar 2021 01:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152892;
        bh=C3LMpm9/bbFKDjD+2lRl6JMrfRT6cK64OYeo4Zre+2w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HwYN13ieknTe4veyfvpifMa/fpylxboj0DCJFU4eJvXsowsLu7oxeZmnpN1G0ml3U
         o1WtYYfp9fvS+t60jepU4ySt+BCyvj1HLk5ITdR/dKYJeTqL331J6i3d9R0qJlTyYH
         eKr/EwV+vg1lixDRk6ISz6tI9ZNNuisdBPTUokjTrtJjpEcu/DPCwLEd5XeKu1SQOP
         zZK7FhOPGibv0Iyo3EiSC7zx5qfbJpKn1wereJLqeKmeuyt4EnPg4LZ8qCjM+tSHCO
         Kjbi2MPZkGHPQpKkGi/3JP9DyaEey4/WoDN2ANXNdbVtWBlp3qOTqavl5IpXQpecy1
         57bI1shpftaCA==
Subject: [PATCH 1/3] common/xfs: support realtime devices with
 _scratch_xfs_admin
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:10 -0700
Message-ID: <161715289029.2703773.9509352442264553944.stgit@magnolia>
In-Reply-To: <161715288469.2703773.13448230101596914371.stgit@magnolia>
References: <161715288469.2703773.13448230101596914371.stgit@magnolia>
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
index 69f76d6e..189da54b 100644
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

