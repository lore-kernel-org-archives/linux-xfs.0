Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A23DC48BC2
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A300611BD
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFUXMd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 19:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhFUXMc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 19:12:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E490060FDB;
        Mon, 21 Jun 2021 23:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624317018;
        bh=HWumwsWH2lec5Xyzhl29LjTFHmaDX+4stZPGpmEThao=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IWsbltgxZBp8dtaG3cL4Rl7psP0pd0kjY3Inkriwqzf3nrhDLZ036xnsScsJGFz9n
         5SaMy9mwfkPsAIRKG+4OLapElt385c0gvORLv4C1K982TSQPU6Er+4p/0agGBIa11p
         6rgt1zHu2afjU+0VTfjoB+Rs/skYnX0aUmcnq/RJzwWIISNd24fstEpyHH33UZDvup
         6xqVl7mi17q3GQ93ED2WodHJfjjUks2YuUxTGa61VYzuXzNBpRaFRiolBuVMjhIj3v
         L4gsdegsHUVwuyXQo3M6RgpIyupVF48YnHLV2CRmOunU6ErBqiDYbUf6aexZ33uMEr
         XDASnfVz/1nYg==
Subject: [PATCH 02/13] misc: move exit status into trap handler
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Date:   Mon, 21 Jun 2021 16:10:17 -0700
Message-ID: <162431701767.4090790.11477157994058494766.stgit@locust>
In-Reply-To: <162431700639.4090790.11684371602638166127.stgit@locust>
References: <162431700639.4090790.11684371602638166127.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the "exit $status" clause of the _cleanup function into the
argument to the "trap" command so that we can standardize the
registration of the atexit cleanup code in the next few patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/068 |    3 +--
 tests/xfs/004     |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/tests/generic/068 b/tests/generic/068
index 932a8560..573fbd45 100755
--- a/tests/generic/068
+++ b/tests/generic/068
@@ -22,10 +22,9 @@ _cleanup()
     cd /
 
     trap 0 1 2 3 15
-    exit $status
 }
 
-trap "_cleanup" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/004 b/tests/xfs/004
index d3fb9c95..4d92a08e 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -18,9 +18,8 @@ _cleanup()
 {
 	_scratch_unmount
 	rm -f $tmp.*
-	exit $status
 }
-trap "_cleanup" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _populate_scratch()
 {

