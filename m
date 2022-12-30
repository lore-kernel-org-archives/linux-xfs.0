Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F0BC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiL3W4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbiL3W4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:56:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B9A6157;
        Fri, 30 Dec 2022 14:56:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D621061C12;
        Fri, 30 Dec 2022 22:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E52C433D2;
        Fri, 30 Dec 2022 22:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440976;
        bh=luVab/+ZYzX0rnW86r9k1EQ12iKVPWafSQ2RN0amBxs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oSpx1nhukICJH/JmkbT5sUZjLUVI6EGyBsb8eqfBH/nTyeB6bhEPs2cf9JNs4y6z9
         xScSbuQyItw3Hnt1Pu8GdnqLPnd7RzAeoTAJka5hCpBMZ2+Say2TSDKBElZvPOOIrn
         SN070OEXTsVfAFao4ysHCMIquFE8vR2E6CdDkx0n9j7dyJy3VptdKKgk7bHqlzzNkt
         NDpmR2x/6KtQ2Jmxj3O/yBLkNcro/oFs3IAaqnbAGvfR4d/Gsf+XomwYja4dpOPRWw
         m4K13iftqL3Z1jyblB6kSZyTN5b2a1/cOoVgiHhUKBukgBzVAN+vx86RRP5nKZ19k1
         M5aAPpgMUt/yg==
Subject: [PATCH 08/16] fuzzy: test the scrub stress subcommands before looping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:54 -0800
Message-ID: <167243837407.694541.14407835892445280870.stgit@magnolia>
In-Reply-To: <167243837296.694541.13203497631389630964.stgit@magnolia>
References: <167243837296.694541.13203497631389630964.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Before we commit to running fsstress and scrub commands in a loop for
some time, we should check that the provided commands actually work on
the scratch filesystem.  The _require_xfs_io_command predicate only
detects the presence of the scrub ioctl, not any particular subcommand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index 88ba5fef69..8d3e30e32b 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -405,6 +405,25 @@ _scratch_xfs_stress_scrub_cleanup() {
 	$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
 }
 
+# Make sure the provided scrub/repair commands actually work on the scratch
+# filesystem before we start running them in a loop.
+__stress_scrub_check_commands() {
+	local scrub_tgt="$1"
+	shift
+
+	for arg in "$@"; do
+		testio=`$XFS_IO_PROG -x -c "$arg" $scrub_tgt 2>&1`
+		echo $testio | grep -q "Unknown type" && \
+			_notrun "xfs_io scrub subcommand support is missing"
+		echo $testio | grep -q "Inappropriate ioctl" && \
+			_notrun "kernel scrub ioctl is missing"
+		echo $testio | grep -q "No such file or directory" && \
+			_notrun "kernel does not know about: $arg"
+		echo $testio | grep -q "Operation not supported" && \
+			_notrun "kernel does not support: $arg"
+	done
+}
+
 # Start scrub, freeze, and fsstress in background looping processes, and wait
 # for 30*TIME_FACTOR seconds to see if the filesystem goes down.  Callers
 # must call _scratch_xfs_stress_scrub_cleanup from their cleanup functions.
@@ -427,6 +446,8 @@ _scratch_xfs_stress_scrub() {
 		esac
 	done
 
+	__stress_scrub_check_commands "$scrub_tgt" "${one_scrub_args[@]}"
+
 	local start="$(date +%s)"
 	local end="$((start + (30 * TIME_FACTOR) ))"
 

