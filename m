Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA15C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E5661108
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhIOXo0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232740AbhIOXoZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:44:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0950260F8F;
        Wed, 15 Sep 2021 23:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749385;
        bh=nzD09Q/tAZ4eU7/GUDYfiWz1uRucqWOZNgFTCrx3700=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sjg09MUZolXnCuheVwKi70hNvToBeJW3LKoLwedp4NeN8uKGkYc85miA70d+drGlv
         qXRk13cM6FCwAOjHlng3UNQFoSAQ8gd67ZErwE+qK9RZWgmHZ+J44ZS7x84qqOLeyy
         17GLZ86rPTTS+vsxgOe2PkkbC4/OagNoMskWsDGM+h3oFcUVAsesU641Yghav/Dq4Z
         kUZNij2k3HealWyRKusd5Je9tI67VwULwsHLprV8Xkn8gil16cjPCqqPE00SJNDWhl
         zXNL7J2YtKEkPyv4jUeoEhnpo5n8rIDUcvfVr8ajWb6IHGA2qz1FbfKMvTXqEGmvg8
         12YsA6SnBjphw==
Subject: [PATCH 5/9] generic/631: change this test to use the 'whiteout' group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:43:04 -0700
Message-ID: <163174938478.380880.9077916198891395416.stgit@magnolia>
In-Reply-To: <163174935747.380880.7635671692624086987.stgit@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test isn't really an overlay test; it's a regression test for a bug
that someone found in xfs handling of whiteout files.  Since the
'overlay' group has one member, let's move it to 'whiteout'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/631 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/631 b/tests/generic/631
index a1acdedb..aae181dd 100755
--- a/tests/generic/631
+++ b/tests/generic/631
@@ -22,7 +22,7 @@
 # in xfs_rename").
 
 . ./common/preamble
-_begin_fstest auto rw overlay rename
+_begin_fstest auto rw whiteout rename
 
 # Override the default cleanup function.
 _cleanup()

