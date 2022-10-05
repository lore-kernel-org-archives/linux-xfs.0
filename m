Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5ECC43217
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Oct 2022 22:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJEWam (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJEWal (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 18:30:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A611DA79;
        Wed,  5 Oct 2022 15:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CDFC617E2;
        Wed,  5 Oct 2022 22:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04684C433D6;
        Wed,  5 Oct 2022 22:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665009039;
        bh=kulnfevjQJ7AaDhx8YHjmPALteikCaksoGTJMhyB/+U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=X9h+nE4s1BZp9tSVbdKmq0pYpqRyAxKdBKhJtdRkFSzQfmWFsvM6anfc/I0/CbDqi
         Q+GFnGy4N/uxQaAdBB2YUUPIM7Lf6+Ok6S1rQkyXM+QfRIhnWAiCI6A2sFEK1pWvBH
         nYv0AXcsIHo0foZ6tYg/0zzTuLaa6NepLjivjL2+wmX0zs2SuDvP8JlmU0NwJSRl4C
         W6jQilU7Rq1sxVdvCv/+HYCiocLl5zm64xiOEmZJqOE8awpygnmEScRf/99SoLMTdi
         KUn1BNTBreKiUWACpczN6WzsnnrTS353OSS8XqoZKR/CYhgaR3BMpnqzpGmjywlg6m
         DU7plJejd4Ogw==
Subject: [PATCH 1/6] generic/092: skip test if file allocation unit isn't
 aligned
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 05 Oct 2022 15:30:38 -0700
Message-ID: <166500903863.886939.16469306626224157289.stgit@magnolia>
In-Reply-To: <166500903290.886939.12532028548655386973.stgit@magnolia>
References: <166500903290.886939.12532028548655386973.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test exercises allocation behavior when truncating a preallocated
file down to 5M and then up to 7M.  If those two sizes aren't aligned
with the file allocation unit length, then the FIEMAP output will show
blocks beyond EOF.  That will cause trouble with the golden output, so
skip this test if that will be the case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Zorro Lang <zlang@redhat.com>
---
 tests/generic/092 |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/tests/generic/092 b/tests/generic/092
index 505e0ec84f..d7c93ca792 100755
--- a/tests/generic/092
+++ b/tests/generic/092
@@ -28,6 +28,12 @@ _require_test
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
 
+# If the truncation sizes (5M/7M) aren't aligned with the file allocation unit
+# length, then the FIEMAP output will show blocks beyond EOF.  That will cause
+# trouble with the golden output, so skip this test if that will be the case.
+_require_congruent_file_oplen $TEST_DIR $((5 * 1048576))
+_require_congruent_file_oplen $TEST_DIR $((7 * 1048576))
+
 # First test to make sure that truncating at i_size trims the preallocated bit
 # past i_size
 $XFS_IO_PROG -f -c "falloc -k 0 10M" -c "pwrite 0 5M" -c "truncate 5M"\

