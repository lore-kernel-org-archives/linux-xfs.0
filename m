Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCCEC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB69F613C3
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348964AbhDNBFf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348955AbhDNBFf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC137613B6;
        Wed, 14 Apr 2021 01:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362314;
        bh=pggsuEBAxeFkt/2YrIL9S1p8Wbe8lTZ2siA+EEQgwA4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JNusYFahHdZS65hV3xGjNOmazbw2W6cFkK7XiYrHSQZ+Mi1QYFhe6dFsVXSFvqPa5
         sz/1zVaJql8qEKihRR0h6uTeE1qLP/9e7EEVZE+nbz6dyPvQD9VNIQOft6C5D4ACoK
         nYWTnUs8uc8gO20vx2H4O7vi/Cu61kDI+SLAFf7cD6+WJsUDQfs6kv2lcNwxSF65DV
         LpW2lfIBET23e60a9ctWq4gxD9bkmyiCoI2mJMrR00utiYQITJM9w3G03IGtFOIEbI
         kMTiLRGgjIOry0cXlQhkPv6GyZDuWO+b9P7MiYBY679REUfpS+fsus63AYSuArhQa1
         vfkaUi9FlpKXA==
Subject: [PATCH 7/9] generic/620: fix order of require_scratch calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:05:14 -0700
Message-ID: <161836231396.2754991.1877515727730919792.stgit@magnolia>
In-Reply-To: <161836227000.2754991.9697150788054520169.stgit@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

_require_scratch_16T_support does not itself check that the scratch
device exists, which means that it depends on someone else to call
_require_scratch.  Document this dependency and fix this test so that we
can run:

./check --exact-order generic/374 generic/620

on an ext4 filesystem without g/620 tripping over the mess left by g/374
when it calls _notrun.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |    3 ++-
 tests/generic/620 |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/common/rc b/common/rc
index 23f86ce6..bb54df56 100644
--- a/common/rc
+++ b/common/rc
@@ -1608,7 +1608,8 @@ _require_scratch_size_nocheck()
 	[ $devsize -lt $1 ] && _notrun "scratch dev too small"
 }
 
-# require scratch fs which supports >16T of filesystem size.
+# Require scratch fs which supports >16T of filesystem size.
+# _require_scratch must be called before this function is called.
 _require_scratch_16T_support()
 {
 	case $FSTYP in
diff --git a/tests/generic/620 b/tests/generic/620
index d0e58ca4..60559441 100755
--- a/tests/generic/620
+++ b/tests/generic/620
@@ -41,8 +41,8 @@ rm -f $seqres.full
 
 # Modify as appropriate.
 _supported_fs generic
-_require_scratch_16T_support
 _require_scratch_size_nocheck $((4 * 1024 * 1024)) #kB
+_require_scratch_16T_support
 _require_dmhugedisk
 
 # 17TB dm huge-test-zer0 device

