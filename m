Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D23C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 145A760F9E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhG1AJu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhG1AJt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:09:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A5A160F23;
        Wed, 28 Jul 2021 00:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627430989;
        bh=sUl+vwkzYrngHgPfrD1QGpBmluw9ukUuKF2ryaErny0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KmYoPkyA3sPN1qA3WtWxkpQ3LtKMdydbTGKRbqA6T2FbSE9ox0qRtz4+CmeeHLbAm
         gYnUyjTBesKCm0MmsYQb9ikmXY1kNyA4ZB1+PNBQqwkGecRE9RxN8P/49WQUOeel+R
         8EGDrq+WupuLrZpbWdgkVKhktCNkDrSyrHnz3QAV3u2j2vGshrFK9fLxpawm+jLGLJ
         55ZzdZdmUGIoePlbgf87V2sQlW7omztDoSFGxVvMCv6+dz6CI1+OBdODaeU6AMTSiy
         2CtmuOJJzj4NDq9GadKlslkfqgqscMd86OH9/aX3tcRyQDeKFcBhz9qd/8YCkUdRCj
         Uo8UT4Fy3Uhcg==
Subject: [PATCH 2/4] check: don't leave the scratch filesystem mounted after
 _notrun
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:09:48 -0700
Message-ID: <162743098874.3427426.3383033227839715899.stgit@magnolia>
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

Unmount the scratch filesystem if a test decides to _notrun itself
because _try_wipe_scratch_devs will not be able to wipe the scratch
device prior to the next test run.  We don't want to let scratch state
from one test leak into subsequent tests if we can help it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/check b/check
index bb7e030c..5d71b74c 100755
--- a/check
+++ b/check
@@ -871,6 +871,11 @@ function run_section()
 			notrun="$notrun $seqnum"
 			n_notrun=`expr $n_notrun + 1`
 			tc_status="notrun"
+
+			# Unmount the scratch fs so that we can wipe the scratch
+			# dev state prior to the next test run.
+			_scratch_unmount 2> /dev/null
+			rm -f ${RESULT_DIR}/require_scratch*
 			continue;
 		fi
 

