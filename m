Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27E4C10F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbiLMTph (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236663AbiLMTpg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:45:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598D02495F;
        Tue, 13 Dec 2022 11:45:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9C5161714;
        Tue, 13 Dec 2022 19:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52538C433D2;
        Tue, 13 Dec 2022 19:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960734;
        bh=ltWqaiufNC3gpMLFPtfkgj/+btiwZFyTbXZV4MkwhP8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Kh1+AJvsjOcMJ+7Rmjd2tTPcxqCQjLn++kljYUjCvHTKHEa3HILzMDnnYEj81SqLh
         NVEvR5nrhvIr9kxQca4MjgOPRDS0Q2lt8Ys59qzmUj0lT/8sXslJY9yoSHhcMnN4ej
         SWyb2N6jNSDOtVX1Lb2Uk6zp0ILY+19mR4MSokzdnDZsVuBhtVVWqtss7qG7TSZVIN
         ZsqaPXKxkVHHRQaIPZYEvJYriV7X0cYSW7rWnsZF6aWiIqMUP0gNp2QpseXE4IPADl
         O51r7GxdqOebvfu110BYEV8yH5aDNB4Csh+LI6ntBVdL91Y6hKrHZL1/kyy2xw+1gc
         YEVumQ3vW+ewg==
Subject: [PATCH 4/4] fuzzy: don't fail on compressed metadumps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Dec 2022 11:45:33 -0800
Message-ID: <167096073394.1750373.2942809607367883189.stgit@magnolia>
In-Reply-To: <167096070957.1750373.5715692265711468248.stgit@magnolia>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This line in __scratch_xfs_fuzz_mdrestore:

	test -e "${POPULATE_METADUMP}"

Breaks spectacularly on a setup that uses DUMP_COMPRESSOR to compress
the metadump files, because the metadump files get the compression
program added to the name (e.g. "${POPULATE_METADUMP}.xz").  The check
is wrong, and since the naming policy is an implementation detail of
_xfs_mdrestore, let's get rid of the -e test.

However, we still need a way to fail the test if the metadump cannot be
restored.  _xfs_mdrestore returns nonzero on failure, so use that
instead.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index e634815eec..49c850f2d5 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -156,10 +156,9 @@ __scratch_xfs_fuzz_unmount()
 # Restore metadata to scratch device prior to field-fuzzing.
 __scratch_xfs_fuzz_mdrestore()
 {
-	test -e "${POPULATE_METADUMP}" || _fail "Need to set POPULATE_METADUMP"
-
 	__scratch_xfs_fuzz_unmount
-	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" compress
+	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" compress || \
+		_fail "${POPULATE_METADUMP}: Could not find metadump to restore?"
 }
 
 __fuzz_notify() {

