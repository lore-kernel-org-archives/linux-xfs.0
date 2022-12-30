Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF22C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbiLaAo1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbiLaAo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:44:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD7A1DDE5;
        Fri, 30 Dec 2022 16:44:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B09E8B81E6C;
        Sat, 31 Dec 2022 00:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2BFC433D2;
        Sat, 31 Dec 2022 00:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447463;
        bh=ui3KL/Lisnrr9lErSTK+rHBwJ7KmXJI3hC3hvAQcqyc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sLJKzlBG9kL+xJCvGd4P4rj6t4njRFu81rkCY5oEIPGnMGhbPyAlIje2Mw1MJ0mXV
         GGChYpfMF5uiQHPuvoaiz4n8XmQcTviuUlA7Nv+uN4wrQL1EQgX5PwyL4ut/haAb0j
         yDAg+Qjb+T3VaWohJp46Z1U30Up0Mt6XmbKpHgLh30Ugc0695BC7BGGiBTFQPsQ/Ge
         2wxAEs8eI61Jz4oxd0/u1XH+3E+f8Mk1qZULp7J2FowIPT+snJW/z0DSYXJBVBeY88
         RbiDsNn1MC5hOKJJgQiX9sUlqO111///B1qrRVym8j9hgqbF7dMANc5IAAe52SJLVD
         Vwam/4qb+u9oQ==
Subject: [PATCH 01/24] fuzzy: disable per-field random fuzzing by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877920.730387.3533277209166689155.stgit@magnolia>
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

Don't run the random fuzzer by default so that we can try to stabilize
the output somewhat.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index d4177c3136..cd6e2a0e08 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -284,7 +284,8 @@ _scratch_xfs_list_fuzz_verbs() {
 		return;
 	fi
 	_scratch_xfs_db -x -c 'sb 0' -c 'fuzz' | grep '^Fuzz commands:' | \
-		sed -e 's/[,.]//g' -e 's/Fuzz commands: //g' -e 's/ /\n/g'
+		sed -e 's/[,.]//g' -e 's/Fuzz commands: //g' -e 's/ /\n/g' | \
+		grep -v '^random$'
 }
 
 # Fuzz some of the fields of some piece of metadata

