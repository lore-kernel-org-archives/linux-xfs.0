Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C98C83F18
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbjH2XIz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241244AbjH2XIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B70139;
        Tue, 29 Aug 2023 16:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05CC361014;
        Tue, 29 Aug 2023 23:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A19C433C8;
        Tue, 29 Aug 2023 23:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350478;
        bh=jc6SMmYwyGu6u4+Mt6bwJp39iODd4I70Act5Kw1bpGI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZHV33UnbH5iO+LRfRwmBVDeQESdUdeR7gyr3gCabzsajoSFNmwpz8nP+OIqIYvaBA
         FYubun6It17XTkxh+H6JBJvXYfa80zunnghiuWdkGp3oHwhVR9pi9o5iten/Plc+aq
         UGrGXpQuX9kDGY7R/OQPrYVnz+PdLFdWETi6+Yjcy0heG7G4vctRiN8njZNALnRo7u
         rYuf0Qkh9TtWEzOUUUVExZACP0+DJ6rvFa8Qv6S/ho3iZUwdiFbIU2N0KW8XM2hXC+
         PmfE0oUHp3qeWLpOAovOajibNvAnwtLVxKWeFmMOMuAQvFlqNml0dPW87BDwRrDdci
         wopl34fy1BaXw==
Subject: [PATCH 1/2] generic/650: add SOAK_DURATION controls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com, ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:07:58 -0700
Message-ID: <169335047798.3523635.5351250494233254529.stgit@frogsfrogsfrogs>
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

Make this test controllable via SOAK_DURATION, for anyone who wants to
perform a long soak test of filesystem vs. cpu hotplug.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/650 |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/tests/generic/650 b/tests/generic/650
index 05a48ef0fd..05c939b84f 100755
--- a/tests/generic/650
+++ b/tests/generic/650
@@ -8,7 +8,7 @@
 # hotplugging to shake out bugs in the write path.
 #
 . ./common/preamble
-_begin_fstest auto rw stress
+_begin_fstest auto rw stress soak
 
 # Override the default cleanup function.
 _cleanup()
@@ -60,13 +60,18 @@ sentinel_file=$tmp.hotplug
 touch $sentinel_file
 exercise_cpu_hotplug &
 
+fsstress_args=(-w -d $stress_dir)
+
 # Cap the number of fsstress threads at one per hotpluggable CPU if we exceed
 # 1024 IO threads, per maintainer request.
 nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))
 test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
+fsstress_args+=(-p $nr_cpus)
+test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
 
 nr_ops=$((25000 * TIME_FACTOR))
-$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $stress_dir -n $nr_ops -p $nr_cpus >> $seqres.full
+fsstress_args+=(-n $nr_ops)
+$FSSTRESS_PROG $FSSTRESS_AVOID -w "${fsstress_args[@]}" >> $seqres.full
 rm -f $sentinel_file
 
 # success, all done

