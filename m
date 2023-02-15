Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDFEC6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjBOBpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjBOBpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:45:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD1D3402B;
        Tue, 14 Feb 2023 17:45:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2C7761838;
        Wed, 15 Feb 2023 01:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCCEC433D2;
        Wed, 15 Feb 2023 01:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425545;
        bh=JEHKTMcR0JjN3sUcGPkUrzWY3uyycwiiw7GJc93Tths=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bya+3Jl9jSIzsu6O2i1YYGTFtKkRYg6NpEmvtSC9gTCaUwuNhGt8MDjl+d+/SC/qB
         79de5/NohrOk0IQNg+yjeH3Q1zuuORstMnqSTReBkS2WTmLHCXegAnRLP8F9QtRQ+C
         ro/M+7dbtTfmO2AuzBZM9R3U3auFT51/uokOX8MOBcTszDvjagfqogTakvkMp3GwoW
         SJh/XO9ShvwKhtuUAtTJRU2GkGJtRifmV50lead57Co6uhIHTgeLsN2n1FIsUn5b/m
         JrLtCgxnWF1bZorIJuBVblAsreEf9wKV+ViHill45XrD/7x44fMEKmHOn/5+nPTaos
         /Q5w1/t0ih/7A==
Subject: [PATCH 01/14] check: generate section reports between tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:45:44 -0800
Message-ID: <167642554451.2118945.4503850138465303711.stgit@magnolia>
In-Reply-To: <167642553879.2118945.15448815976865210889.stgit@magnolia>
References: <167642553879.2118945.15448815976865210889.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Generate the section report between tests so that the summary report
always reflects the outcome of the most recent test.  Two usecases are
envisioned here -- if a cluster-based test runner anticipates that the
testrun could crash the VM, they can set REPORT_DIR to (say) an NFS
mount to preserve the intermediate results.  If the VM does indeed
crash, the scheduler can examine the state of the crashed VM and move
the tests to another VM.  The second usecase is a reporting agent that
runs in the VM to upload live results to a test dashboard.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/check b/check
index 0bf5b22e06..14b398fd73 100755
--- a/check
+++ b/check
@@ -844,6 +844,15 @@ function run_section()
 		fi
 		seqres="$REPORT_DIR/$seqnum"
 
+		# Generate the entire section report with whatever test results
+		# we have so far.  Leave the $sect_time parameter empty so that
+		# it's a little more obvious that this test run is incomplete.
+		if $do_report; then
+			_make_section_report "$section" "${#try[*]}" \
+					     "${#bad[*]}" "${#notrun[*]}" \
+					     "" &> /dev/null
+		fi
+
 		mkdir -p $RESULT_DIR
 		rm -f ${RESULT_DIR}/require_scratch*
 		rm -f ${RESULT_DIR}/require_test*

