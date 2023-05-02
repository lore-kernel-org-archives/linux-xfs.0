Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF43DC7EE21
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 20:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjEBUIV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 16:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjEBUIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 16:08:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F5B210D;
        Tue,  2 May 2023 13:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B25062888;
        Tue,  2 May 2023 20:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CECC4339E;
        Tue,  2 May 2023 20:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683058097;
        bh=5ABbv8yncK7msy6e4ZUOITGdL3qMVbaycFKsVkxfqsc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=THA6w3XdsSB08LPLednR0P5wJWn+SlfbE+VeERq41PWjSaHrS9ss5RiI9jcBa7SDc
         3/lUMC0adNhckSOXLiELuDX5v2M2mPyIi20vob5SaqVJ3DHeBToBgSiZSFK09prtjT
         zThPRbWgbYVuF7yAmP3keYX+5E55SJGmSbgHQvwdgOrCQXmS6QwSYJZl+0YFTJ8Jnl
         7Lq5W+7mU2rAggLqBqs5emEeqraCfhYJUQ3XyCwxzm2F4iJFvQG6i2w2hFtHjrHswX
         33KaJ0VeJBKeA1xUd0zDi3glt3cHE6Su2BbtR27am5YEjKkBZ0xDE33pLlDKK1c75T
         2r7H0VOtqqukg==
Subject: [PATCH 2/7] xfs/262: remove dangerous labels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 May 2023 13:08:17 -0700
Message-ID: <168305809743.331137.7433555907275247899.stgit@frogsfrogsfrogs>
In-Reply-To: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
References: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test starts with a consistent filesystem and should end that way
too.  In other words, it isn't dangerous, so drop that from the tags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/262 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/262 b/tests/xfs/262
index 78db5e3421..b28a6c88b7 100755
--- a/tests/xfs/262
+++ b/tests/xfs/262
@@ -9,7 +9,7 @@
 # executable and libraries!) to see what happens.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest fuzzers scrub online_repair
 
 _register_cleanup "_cleanup" BUS
 

