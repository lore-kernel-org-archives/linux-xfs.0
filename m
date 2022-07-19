Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFD7C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiGSVh4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240172AbiGSVhy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:37:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E13F61B2C;
        Tue, 19 Jul 2022 14:37:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE6F4B81D5C;
        Tue, 19 Jul 2022 21:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4966C341C6;
        Tue, 19 Jul 2022 21:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266670;
        bh=DhDzu3R5b7PV2zXBmAD4WAU+4bhreJW/EAR403IDRiY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z7ECV7x9Jsp4Aq+XcMO9H0C5jizVXkwYHassh2RqlkJcWhDO2uNGAbCXQa5evKBMr
         rbSaKtOsKlCUosdWda2GAdUIuT9fzMiy0KFgikeezsXoeYNmB65DdK2AsQeWfQf5Qg
         W9XDi/Tty90mcICPFmcrhwu0/1Ay5b5eMbFuNfe+Le4YneGbPQKGQIWI3y9plLN7sg
         l8NxhjC/QmE2lObKZQ6Wdec69ZVMSrxdehai+dTn+JthSL+WESz4xWpY1rabHgkIx6
         pgZFu/OOLkFmOrzaOv1oen4EwCBeMbcFyFwbcF3h5h9SC4GTgbn/N7yEiWU+cZi5Ds
         PvRt282I/avyA==
Subject: [PATCH 6/8] punch: skip fpunch tests when op length not congruent
 with file allocation unit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 19 Jul 2022 14:37:50 -0700
Message-ID: <165826667021.3249494.7465600803977165173.stgit@magnolia>
In-Reply-To: <165826663647.3249494.13640199673218669145.stgit@magnolia>
References: <165826663647.3249494.13640199673218669145.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Skip the generic fpunch tests on a file when the file's allocation unit
size is not congruent with the proposed testing operations.

This can be the case when we're testing reflink and fallocate on the XFS
realtime device.  For those configurations, the file allocation unit is
a realtime extent, which can be any integer multiple of the block size.
If the request length isn't an exact multiple of the allocation unit
size, reflink and fallocate will fail due to alignment issues, so
there's no point in running these tests.

Assuming this edgecase configuration of an edgecase feature is
vanishingly rare, let's just _notrun the tests instead of rewriting a
ton of tests to do their integrity checking by hand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/punch |    1 +
 1 file changed, 1 insertion(+)


diff --git a/common/punch b/common/punch
index 4d16b898..47a29c92 100644
--- a/common/punch
+++ b/common/punch
@@ -250,6 +250,7 @@ _test_generic_punch()
 	_8k="$((multiple * 8))k"
 	_12k="$((multiple * 12))k"
 	_20k="$((multiple * 20))k"
+	_require_congruent_file_oplen "$(dirname "$testfile")" $((multiple * 4096))
 
 	# initial test state must be defined, otherwise the first test can fail
 	# due ot stale file state left from previous tests.

