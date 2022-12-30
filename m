Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB1CC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbiLaAso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbiLaAsf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:48:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2423B1C90A;
        Fri, 30 Dec 2022 16:48:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F8AB81DAF;
        Sat, 31 Dec 2022 00:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9379FC433D2;
        Sat, 31 Dec 2022 00:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447712;
        bh=Jz+QHhSSZtzitkTImYkhY+r3TEqNMGIf2bOSiP1y6yo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=szL63PlSDIMZVJ0Hy4sgAUuWpd5oAQp9m3LyudPmycA7ijhcZJlv0A4QhxaVqJOrW
         REu8msTBLIXsVj2l3wFP5tu34lhqw+FrP6ZxG6NDs2bPGe7TvXQBuhw3EVHusj5J4z
         xC09jyRm+XreeGi6rKoM7HGYGxQF+eQ6S5uF91O1yxu1IEQhku/jGu9hTDBpVCUXnh
         GzkzzePQ6yOl1sncfBxca7Y61VYlR2bH0CPZc/fh/rny+6LwEKJa3ygOYOaF5f1W4l
         404KWA9yPJd0I1V/F4C5AlmTmw477NvukJv7scJ9GYTKKcD3B0FgRa+GsufoAKgu62
         2kt68Oozftsng==
Subject: [PATCH 17/24] common/fuzzy: evaluate xfs_check vs xfs_repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:41 -0800
Message-ID: <167243878128.730387.16863204052245480568.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When fuzzing a filesystem and using the offline repair strategy, compare
the outputs of xfs_check against xfs_repair to ensure that the newer
xfs_repair catches at least as many things as xfs_check does.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index e9a5d67592..cf085f8b28 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -253,6 +253,17 @@ __scratch_xfs_fuzz_field_offline() {
 	test $res -eq 0 && \
 		(>&2 echo "${fuzz_action}: offline scrub didn't fail.")
 
+	# Make sure xfs_repair catches at least as many things as the old
+	# xfs_check did.
+	if [ -n "${SCRATCH_XFS_FUZZ_CHECK}" ]; then
+		__fuzz_notify "+ Detect fuzzed field (xfs_check)"
+		_scratch_xfs_check 2>&1
+		res1=$?
+		if [ $res1 -ne 0 ] && [ $res -eq 0 ]; then
+			(>&2 echo "${fuzz_action}: xfs_repair passed but xfs_check failed ($res1).")
+		fi
+	fi
+
 	# Repair the filesystem offline
 	__fuzz_notify "+ Try to repair the filesystem (offline)"
 	_repair_scratch_fs -P 2>&1

