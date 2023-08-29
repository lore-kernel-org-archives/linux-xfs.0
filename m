Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F27C83F12
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbjH2XIy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241248AbjH2XIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E441BF;
        Tue, 29 Aug 2023 16:08:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9535A61E8C;
        Tue, 29 Aug 2023 23:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35E8C433C8;
        Tue, 29 Aug 2023 23:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350484;
        bh=/4T9YObsLiKg5fpTwa/xl1I2l29zQhyXdxNxnNsOJQM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HKHjF6R6BetpKnAyPKM9AA34ZQuOEabM9Yk0hulIYmI/nxrfo4f7qWmLLz6DTtCMf
         PTNtAy6yjYKb28i2iqvK8wZcuIZtWD89KbWK3jCkv/eZQART50QtcjY5nJUQlHaOit
         dve/eTXPYYrQQe2kxWtsnDqD0E3hrj4i/P+dfiBffDGGDJESQluOZq8N2GqL6f2qmx
         Mix4erIvHdh8cpUdA8YL1JKOnjCu9opEkznOrDqNM5vnmhjz0dYHmd2luocThQBwv8
         1tI9et5eVuaFGjDgZHvhqNxAo9uBRczZqvZ+NBZ0IOZx5Zkr47+QHr+TBKUuEasV9e
         nltLm2xuPYkiQ==
Subject: [PATCH 2/2] generic/650: race mount and unmount with cpu hotplug too
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com, ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:08:03 -0700
Message-ID: <169335048358.3523635.7191015334485086811.stgit@frogsfrogsfrogs>
In-Reply-To: <169335047228.3523635.3342369338633870707.stgit@frogsfrogsfrogs>
References: <169335047228.3523635.3342369338633870707.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

