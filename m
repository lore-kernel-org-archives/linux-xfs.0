Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23965C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D4CA60F9D
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhG1AKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232989AbhG1AKA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:10:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 090CB60F23;
        Wed, 28 Jul 2021 00:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627431000;
        bh=Wcmka2eSmM+Ej7XogJjxoBbCS/nbr11GK7b8/d/Fdmo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xjhn9r790tLjxOSRM3etlbnO1JR6nYPSUBf2sWJlEY3IN77sW42AY9g6uvPMy4x5u
         ROHMCvpMkQyOfkfs+GjFwS+/Qg4Fa1Xt+r8ysvlyPqFoFTjaEcRCZVkt+VIk2j64zs
         3WisDfmAEdaVI3LxmQ3SC7mSExYgHmOUXOhg8VRFYS6Aro4HyT7hbiDVGMprwpfTJi
         gyx5X5bK0eqgS33hI7cMCaUtCjBwf39b44mRe+/4+BTd01uwDJlcHVzdyeS1CczAa7
         RqZZ5pXu7TJeNQBJXpDYjod/W1fCEG1zXlVBsEIsBirqUq8phZ9+HL3+dR4j4D7xPi
         H8b6KXeu+mw9w==
Subject: [PATCH 4/4] check: back off the OOM score adjustment to -500
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:09:59 -0700
Message-ID: <162743099972.3427426.5759542449674461731.stgit@magnolia>
In-Reply-To: <162743097757.3427426.8734776553736535870.stgit@magnolia>
References: <162743097757.3427426.8734776553736535870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Dave Chinner complained that fstests really shouldn't be running at
-1000 oom score adjustment because that makes it more "important" than
certain system daemons (e.g. journald, udev).  That's true, so increase
it to -500.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/check b/check
index 5d71b74c..e493ca11 100755
--- a/check
+++ b/check
@@ -564,7 +564,7 @@ OOM_SCORE_ADJ="/proc/self/oom_score_adj"
 function _adjust_oom_score() {
 	test -w "${OOM_SCORE_ADJ}" && echo "$1" > "${OOM_SCORE_ADJ}"
 }
-_adjust_oom_score -1000
+_adjust_oom_score -500
 
 # ...and make the tests themselves somewhat more attractive to it, so that if
 # the system runs out of memory it'll be the test that gets killed and not the

