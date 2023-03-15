Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86465C7618A
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjCOAws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCOAwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014365C9D8;
        Tue, 14 Mar 2023 17:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AD7161A98;
        Wed, 15 Mar 2023 00:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8771C4339B;
        Wed, 15 Mar 2023 00:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841557;
        bh=kDPMutoppQB9uvDQRbQbLkzA8OMhjuIiQEV5sbIGGCo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m4I+mujFqvk9GAIZfitZBblXKvGxDf3iupZizaUOhYQE92i1dMvYvvHUPDzIgzd51
         pxu+Ix7x5wAZAwh7CtYKT5uvDpSSBfF1XcGMLCAWC+6lq58SJUZIRfxx25mdCwfVc2
         +6tFM/1u3pkTYuiHqXWU1J6g62fCFrqFkSvFZGwTCH6oS7t3J9QtCzRqF8MXolnXQ4
         50+AyX08wyymJOKDrlK4Kp2q/VfWRYz9+riMoiiZTGzkNcJa4OXfJ5zq3pbULwMoKv
         3kNDCXBpxfeY126bNQoXu8BhzxUR5uGsJlNyYDzPJbesuSTWvzN7O57qm6x6UkoJ+8
         vDVuvPzsioR3Q==
Subject: [PATCH 01/15] check: generate section reports between tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:52:36 -0700
Message-ID: <167884155648.2482843.4182317488319546153.stgit@magnolia>
In-Reply-To: <167884155064.2482843.4310780034948240980.stgit@magnolia>
References: <167884155064.2482843.4310780034948240980.stgit@magnolia>
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
Reviewed-by: Leah Rumancik <leah.rumancik@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
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

