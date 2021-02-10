Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99E6C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A069B64E53
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 02:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhBJC5X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:57:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhBJC5W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 21:57:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F41C64D79;
        Wed, 10 Feb 2021 02:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612925802;
        bh=XLgScXNNZg6BxJGZJhb/Hl+Xc6XS7HIqSnCPMJsZQwk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ESu3S3uVteNSqwG/7Mt41a/p2cejxL034wFGfRBuRO5QyjFK8CgsGQtYIdEY8FdMe
         MoEg0hemIuJMwydl3MCahVnDu2U0CTWLOj25Tpv40LmmM+5+n6SOMsx1K7vCzA7DV0
         giEhRRZJqnJ2lPkictLbcNX0KHV3V80bz1iR0+6epog1tGg6WBk6eNRLIYmkU8+Qie
         d6tFlY4n0O1eBdKBXa4S8aF2WBZeuLLCMj0sLSboV/vKltSHOkn/y0KRC6AE3Q3xXU
         qXVTWUaodxMHmSH/RkrPs4iQtMKUaiVXmWI9MY2XHa65j20JlLTawrCNJ2IIIukXBW
         yVSUdVhOCseZQ==
Subject: [PATCH 4/6] check: don't abort on non-existent excluded groups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Feb 2021 18:56:42 -0800
Message-ID: <161292580215.3504537.12419725496679954055.stgit@magnolia>
In-Reply-To: <161292577956.3504537.3260962158197387248.stgit@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't abort the whole test run if we asked to exclude groups that aren't
included in the candidate group list, since we actually /are/ satisfying
the user's request.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/check b/check
index e51cbede..6f8db858 100755
--- a/check
+++ b/check
@@ -243,7 +243,7 @@ _prepare_test_list()
 		list=$(get_group_list $xgroup)
 		if [ -z "$list" ]; then
 			echo "Group \"$xgroup\" is empty or not defined?"
-			exit 1
+			continue
 		fi
 
 		trim_test_list $list

