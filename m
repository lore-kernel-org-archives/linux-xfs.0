Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E185C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86F9060F9C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhG1AJz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhG1AJz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:09:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FA1560F23;
        Wed, 28 Jul 2021 00:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627430994;
        bh=Go/IC1+fJQ5/TmdLQ4XtoXYNyUqRVM/+6+aFxKErH6M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hLNlYmjibQyzxbQsIilPviu1UqPH+ro7/ESPzfrBDhW4JvlvgSFrCuynOoY1F9ukC
         9fWbjXAy3OYzcHlxTBojC179vBRnZiiO7EqsBmpK/EAKC/NsDftQ/dbqwxYombeWpV
         v6aHnFHk8OCI3+Mo+MNb3G0OXDRnl0gOqmmcKjXUcVc8kk85ZDMFrBIwU5uTfbzIkU
         A3szUFC1k5f+rPcLIEFgehlS4XNDzaZ44TQAQME7TTrIuzxKivazWs0fuN6R2B4anP
         FA3EmXi/HheoUBFJGHtZmglEelIhr73vwc2gIpOZQoZFosVXhNIdSSecp9Lets6U/C
         QqOc4aKcUQ4/Q==
Subject: [PATCH 3/4] generic/570: fix regression when SCRATCH_DEV is still
 formatted
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:09:54 -0700
Message-ID: <162743099423.3427426.15112820532966726474.stgit@magnolia>
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

Newer versions of mkswap (or at least the one in util-linux 2.34)
complain to stderr when they're formatting over a device that seems to
contain existing data:

    mkswap: /dev/sdf: warning: wiping old btrfs signature.

This is harmless (since the swap image does get written!) but the extra
golden output is flagged as a regression.  Update the mkswap usage in
this test to dump the stderr output to $seqres.full, and complain if the
exit code is nonzero.

This fixes a regression that the author noticed when testing btrfs and
generic/507 and generic/570 run sequentially.  generic/507 calls
_require_scratch_shutdown to see if the shutdown call is supported.
btrfs does not support that, so the test is _notrun.  This leaves the
scratch filesystem mounted, causing the _try_wipe_scratch_devs between
tests to fail.  When g/570 starts up, the scratch device still contains
leftovers from the failed attempt to run g/507, which is why the mkswap
command outputs the above warning.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/570 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/570 b/tests/generic/570
index 7d03acfe..02c1d333 100755
--- a/tests/generic/570
+++ b/tests/generic/570
@@ -27,7 +27,7 @@ _require_scratch_nocheck
 _require_block_device $SCRATCH_DEV
 test -e /dev/snapshot && _notrun "userspace hibernation to swap is enabled"
 
-$MKSWAP_PROG "$SCRATCH_DEV" >> $seqres.full
+$MKSWAP_PROG -f "$SCRATCH_DEV" &>> $seqres.full || echo "mkswap failed?"
 
 # Can you modify the swap dev via previously open file descriptors?
 for verb in 1 2 3 4; do

