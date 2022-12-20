Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8289C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiLTABX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiLTABN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:01:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B960F1115B;
        Mon, 19 Dec 2022 16:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27E29B80F2B;
        Tue, 20 Dec 2022 00:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83C8C433D2;
        Tue, 20 Dec 2022 00:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494469;
        bh=s1JQfyn4mxTewWB2Hp9Jp98ubgWVp0W9RQ5OF2paesM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cWt3F6ZJC9Vfp4h2G5JvMiXFLFoh3pZ2dL5ZEwQ0FgFvFNCO1Q7iaQRdI53A0zsyh
         iYrUPE5CbCUdaT+HjEjjAqnkRpAKfAKl7nYgZEVSNcojxD2wTyUVNrXfqkqnfSPqWU
         xVt3h12WQf4RyTreHKYpLcGlmr/Io4TR1Bi8ArZBb9Fa55pZHIaFtjmGH0w8XJ5QQi
         8T/HHjvHXlGfxVHuzzQQVtcdOzI9DLDkBVQJKc11hBXscuDJzPpa0sr2iQpnqyktsW
         J18wPe0TGPi7d3UeB0PD/9fT/cAS3kST/b5rqV9Tb0mJypjZ7Ru7oAkmkwaFwlf2UF
         TlyBDlb9/DpKg==
Subject: [PATCH 1/8] check: generate section reports between tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com
Date:   Mon, 19 Dec 2022 16:01:09 -0800
Message-ID: <167149446946.332657.17186597494532662986.stgit@magnolia>
In-Reply-To: <167149446381.332657.9402608531757557463.stgit@magnolia>
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
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
 check |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/check b/check
index 1ff0f44af1..70a0b537b1 100755
--- a/check
+++ b/check
@@ -842,6 +842,16 @@ function run_section()
 		fi
 		seqres="$REPORT_DIR/$seqnum"
 
+		# Generate the entire section report with whatever test results
+		# we have so far.  Leave the $sect_time parameter empty so that
+		# it's a little more obvious that this test run is incomplete.
+		if $do_report; then
+			local sect_now=`_wallclock`
+			_make_section_report "$section" "${#try[*]}" \
+					     "${#bad[*]}" "${#notrun[*]}" \
+					     "" &> /dev/null
+		fi
+
 		mkdir -p $RESULT_DIR
 		rm -f ${RESULT_DIR}/require_scratch*
 		rm -f ${RESULT_DIR}/require_test*

