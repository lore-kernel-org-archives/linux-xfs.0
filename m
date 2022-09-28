Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5A5C54EE9
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 04:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiI1EYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 00:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiI1EYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 00:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99D81F0CC9;
        Tue, 27 Sep 2022 21:24:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7509561CFF;
        Wed, 28 Sep 2022 04:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8576C433C1;
        Wed, 28 Sep 2022 04:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664339042;
        bh=z1BRi0w24pOjEjjn9U9SFzIwOxauLH057YDb3rjxxEI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dn42Uh+0KPJy0rJgrl9jsP/HE2LkBwbcX44zhcJW4TaEqSLONyhJA/rB3otP9U2hN
         5To3RlDnHjJ7R4oo1qlU9Q+ModVLfFWrOByOOgmYQPERi6aJZPQFgHAszXp1NloFqZ
         phlPnAH710SqoayIhPNlNOLLJtd3PaH2PpXXzO4qfkL9lh1hJeKyjLNfaIJWY12Lc9
         JkcJagphX020ICRaZs7q5TJpcnXyxlOntJVcbKzeKO8n9XaOcIFoQATY1eZc0PIlzl
         oWVu++oVnACVYog6YVCNTllWpoLzExTkeAdIpwAUd6ugxV3fo/VFrMR6G2CBGalBqC
         U2m0PfWz6Lc4w==
Subject: [PATCH 2/3] xfs/114: fix missing reflink requires
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Sep 2022 21:24:02 -0700
Message-ID: <166433904232.2008389.13820157130628464952.stgit@magnolia>
In-Reply-To: <166433903099.2008389.13181182359220271890.stgit@magnolia>
References: <166433903099.2008389.13181182359220271890.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test both requires cp --reflink and the scratch filesystem to
support reflink.  Add the missing _requires calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/114 |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/114 b/tests/xfs/114
index 3aec814a5d..858dc3998e 100755
--- a/tests/xfs/114
+++ b/tests/xfs/114
@@ -18,6 +18,8 @@ _begin_fstest auto quick clone rmap collapse insert
 # real QA test starts here
 _supported_fs xfs
 _require_test_program "punch-alternating"
+_require_cp_reflink
+_require_scratch_reflink
 _require_xfs_scratch_rmapbt
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fcollapse"

