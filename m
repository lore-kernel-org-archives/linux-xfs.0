Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6ACC88CB2
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjHXXpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239873AbjHXXpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:45:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3515119AE
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B648363216
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19889C433C7;
        Thu, 24 Aug 2023 23:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692920741;
        bh=xpZB8nS06qwCFIv1KqBF1XSy14wOgaAWMDH+ZadWZrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JDiwjUH1/6pJl9HI8CacpIVRgsuLsdwlx9cK6Z1rL7cFOCGkueL788IZs0YoIIChp
         l9CLCuRymHXOEvHU2XqgZDPAG8rrZs5l+bU4TzyNfeyJEYRhOhfLrBlznDdPl6VAEL
         B3eKDObnRGKSdwbE6o9W2JEGjqscj9b4UnYpRgkJrAg3b377DVHZupqQ3GvUmsHg5g
         itLg8SGDgMCoGNJJlQkUXEDOmXwotqLF+Zg2dbX/LEbUkqtFypE5/+jcIZkADOUh/N
         YT2b1tFHsH9n9CArSfxUOgr6UerAZsNzYT9YcuncW5NXTD+zNxgB1P4oIpY/DkDLmF
         0/p7zETwSbwig==
Date:   Thu, 24 Aug 2023 16:45:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com
Cc:     peterz@infradead.org, ritesh.list@gmail.com, sandeen@sandeen.net,
        tglx@linutronix.de, linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH 4/3] generic/650: race mount and unmount with cpu hotplug too
Message-ID: <20230824234540.GD17912@frogsfrogsfrogs>
References: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Ritesh Harjani reported that mount and unmount can race with the xfs cpu
hotplug notifier hooks and crash the kernel.  Extend this test to
include that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/650 |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tests/generic/650 b/tests/generic/650
index 05c939b84f..773f93c7cb 100755
--- a/tests/generic/650
+++ b/tests/generic/650
@@ -67,11 +67,18 @@ fsstress_args=(-w -d $stress_dir)
 nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))
 test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
 fsstress_args+=(-p $nr_cpus)
-test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
+if [ -n "$SOAK_DURATION" ]; then
+	test "$SOAK_DURATION" -lt 10 && SOAK_DURATION=10
+	fsstress_args+=(--duration="$((SOAK_DURATION / 10))")
+fi
 
-nr_ops=$((25000 * TIME_FACTOR))
+nr_ops=$((2500 * TIME_FACTOR))
 fsstress_args+=(-n $nr_ops)
-$FSSTRESS_PROG $FSSTRESS_AVOID -w "${fsstress_args[@]}" >> $seqres.full
+for ((i = 0; i < 10; i++)); do
+	$FSSTRESS_PROG $FSSTRESS_AVOID -w "${fsstress_args[@]}" >> $seqres.full
+	_test_cycle_mount
+done
+
 rm -f $sentinel_file
 
 # success, all done
