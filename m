Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC24FC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbiLaAth (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbiLaAtg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:49:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3071C90A;
        Fri, 30 Dec 2022 16:49:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A4061D62;
        Sat, 31 Dec 2022 00:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3BBC433D2;
        Sat, 31 Dec 2022 00:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447774;
        bh=EGOSjDBjojcDX/0QFWZrdfMrZPsEkrHx+pjvzqnebdk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LlxRXHG1dfYa9edrVP37mImfvLVspvtWO9CTSi7jxp03SGu++WWZS/sWS5FleVVDp
         6hcC/6mRfNN4bCzMs6JCOYf0kjnkF1tvHZHC7mWJSmzHEmj1SL9aKuDkW7IIJxtqIo
         y1p4PwLB8PuB9HQCA6bmpaLl0BQU3HRUJG+TIQkCnUPPuoG6zlrvNrPwJiBrnNpPj7
         8UaN/X6FnMHTX5rLTcBKSeCsWP9lW4n/OUYupDzwrLEya8NKfrGospaTo6c6jHWuau
         ZLqc42HpGXRprx1Ref1JxhalS19Ml5uqwoabAEO14qu6YwYEr071AQJAhdYfOUZlEa
         8OUYjD38fbWsA==
Subject: [PATCH 21/24] fuzzy: compress coredumps created while fuzzing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:41 -0800
Message-ID: <167243878174.730387.1210805783525611354.stgit@magnolia>
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

Compress the coredumps and put them in the results directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index 939f5e5ef2..7eaf883c0f 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -554,6 +554,14 @@ _scratch_xfs_fuzz_metadata() {
 		echo "${verbs}" | while read fuzzverb; do
 			__scratch_xfs_fuzz_mdrestore
 			__scratch_xfs_fuzz_field_test "${field}" "${fuzzverb}" "${repair}" "$@"
+
+			# Collect compresssed coredumps in the test results
+			# directory if the sysadmin didn't override the default
+			# coredump strategy.
+			for i in core core.*; do
+				test -f "$i" || continue
+				_save_coredump "$i"
+			done
 		done
 	done
 }

