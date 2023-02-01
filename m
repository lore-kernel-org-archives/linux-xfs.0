Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D585C636D7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 00:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjBAAvl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjBAAvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2023 19:51:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BC91633C;
        Tue, 31 Jan 2023 16:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1044B81FDA;
        Wed,  1 Feb 2023 00:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937CCC4339B;
        Wed,  1 Feb 2023 00:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675212695;
        bh=x3nDxc982I3cH0tw+htWU28F7OHoaqRn7pZttS1T3UI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lslKEBFRAhjGDa+4TxikPzOe0ZSdvUHVdc2bMjqP18fZHGLp1L9B8PnMShEsiDEU6
         5tcooBpvfiCTz7HfNkvkPdOwzdFb9BrbCU36k3ZDnwROI9Oj3W4d3tPqvM7I2TWmVd
         uJEl6a+aiG2eyWVoFuBScqmHPnDa3Ymbn9tlSSgBVlYvK/ZZrey35K2Y5wudX88Cgp
         7anZbEmevg4mvbJPR9Tsx2b9zaHzm8XYl7AGQgQjye7K7pjTuPoolAtPlyDDY0WnDP
         Cs6MThM3UlWKpiXen7BSpmOMFBQ2NN9U/4ASUf7v+kXauQWWhXO5xTs0DQ88J/UODL
         7zYld3lINm0AQ==
Subject: [PATCH 1/2] generic/038: set a maximum runtime on this test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Jan 2023 16:51:35 -0800
Message-ID: <167521269515.2382722.13790661033478617605.stgit@magnolia>
In-Reply-To: <167521268927.2382722.13701066927653225895.stgit@magnolia>
References: <167521268927.2382722.13701066927653225895.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test races multiple FITRIM calls against multiple programs creating
200k small files to ensure that there are no concurrency problems with
the allocator and the FITRIM code.  This is not necessarily quick, and
the test itself does not contain any upper bound on the runtime.  On my
system that simulates storage with DRAM this takes ~5 minutes to run; on
my cloud system with newly provided discard support, I killed the test
after 27 hours.

Constrain the runtime to about the customary 30s * TIME_FACTOR.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/038 |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/tests/generic/038 b/tests/generic/038
index 5c014ae389..e1176292fb 100755
--- a/tests/generic/038
+++ b/tests/generic/038
@@ -100,6 +100,8 @@ nr_files=$((50000 * LOAD_FACTOR))
 create_files()
 {
 	local prefix=$1
+	local now=$(date '+%s')
+	local end_time=$(( now + (TIME_FACTOR * 30) ))
 
 	for ((n = 0; n < 4; n++)); do
 		mkdir $SCRATCH_MNT/$n
@@ -113,6 +115,10 @@ create_files()
 				echo "Failed creating file $n/${prefix}_$i" >>$seqres.full
 				break
 			fi
+			if [ "$(date '+%s')" -ge $end_time ]; then
+				echo "runtime exceeded @ $i files" >> $seqres.full
+				break
+			fi
 		done
 		) &
 		create_pids[$n]=$!

