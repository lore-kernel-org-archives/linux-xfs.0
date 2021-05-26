Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E04C47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F1361429
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhEZBsU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 21:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhEZBsT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 21:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E3AE61090;
        Wed, 26 May 2021 01:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621993608;
        bh=Qa57kI1fGHkYAMkToh9ejc4GN8tRVM+CoTHt5jT/UKU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=knYh0rQ+izBryl/MUA3xBy/SrZKI0Nj4bQkNdT6SqQPp6s4p4ts53Y7+aPGxKTYbw
         0aLQJpwB46E0gqxGm4NKRwDxt42gg+BiA6oIOY4EtY0M3VcOBO8VU1FumTMKe6EjN8
         cH0V/tfy27M1gWOv1R5p/8AHh5lq6cftHtTBWGslpQqkGP1Q1fJQuEt8dTdlkt60WP
         WQb/MgRFTtLv/wSTpnzwFzyVOwF/CrusJu2egH5aUFN2kHAMvktJdjclUVUMfIRgf9
         aJprs6odkIRHQaUgsMNvgO2uDWgHRdu+3M2O/XH///FEw0vQLLJRQ1pWS65NdSLQEC
         yZd/yhhYou/WQ==
Subject: [PATCH 01/10] fstests: fix group check in new script
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 May 2021 18:46:48 -0700
Message-ID: <162199360825.3744214.12378871174987894190.stgit@locust>
In-Reply-To: <162199360248.3744214.17042613373014687643.stgit@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the tests/*/group files, group names are found in the Nth columns of
the file, where N > 1.  The grep expression to warn about unknown groups
is not correct (since it currently checks column 1), so fix this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 new |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)


diff --git a/new b/new
index bb427f0d..357983d9 100755
--- a/new
+++ b/new
@@ -243,10 +243,7 @@ else
     #
     for g in $*
     do
-	if grep "^$g[ 	]" $tdir/group >/dev/null
-	then
-	    :
-	else
+	if ! grep -q "[[:space:]]$g" "$tdir/group"; then
 	    echo "Warning: group \"$g\" not defined in $tdir/group"
 	fi
     done

