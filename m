Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24666C54EBC
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbiLaDII (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiLaDH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:07:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0262210540;
        Fri, 30 Dec 2022 19:07:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EDE361D33;
        Sat, 31 Dec 2022 03:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094DFC433EF;
        Sat, 31 Dec 2022 03:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456075;
        bh=kE8TtzatSYZ+X71XfAWYa6GAAtZBAoO2+y6B92LdhXw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SgB7a6DR69mvi5pKQjKX4kCyOHR8tGch6edERFj4Op0770h0nWzHTvE3WVEz2+jBB
         268cEryD72ZmkTvMivNh1CWiQyxmsUWMHd2j2luX6htTMZu3DI0EH4HE+iWhp3AVi/
         IWFJnFf2CEE/p2bWaiWL5UJcmbK6ibJwlYW9mk61mVA2Uhw4H1b8RcIFWIKr/hBiCD
         bndeCfOKqrEeOflN8ShEw94XJv3p5Nsx1a2f7Fb2dVkVYJXLqJ8LAdFMTarHNAXl27
         KIOsJZf1QGLDMXhIYdtynBinjROMtKOtdloPJ77AMclW/OE/zSF0+c+RJkANyGTcR/
         LTJpxhuZWMDZw==
Subject: [PATCH 7/9] xfs/769: add metadir upgrade to test matrix
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:33 -0800
Message-ID: <167243883329.736753.2626034785600768252.stgit@magnolia>
In-Reply-To: <167243883244.736753.17143383151073497149.stgit@magnolia>
References: <167243883244.736753.17143383151073497149.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add metadata directory trees to the features that this test will try to
upgrade.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/769 |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/769 b/tests/xfs/769
index 7613048f52..624dd2a338 100755
--- a/tests/xfs/769
+++ b/tests/xfs/769
@@ -174,12 +174,14 @@ if rt_configured; then
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
+	check_repair_upgrade metadir && FEATURES+=("metadir")
 else
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
 	check_repair_upgrade reflink && FEATURES+=("reflink")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
+	check_repair_upgrade metadir && FEATURES+=("metadir")
 fi
 
 test "${#FEATURES[@]}" -eq 0 && \

