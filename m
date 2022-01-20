Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F02C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345161AbiATAWW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiATAWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA52FC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:22:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8187EB81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D86C004E1;
        Thu, 20 Jan 2022 00:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638139;
        bh=cZRFLNKVnYLBewQK3EPy7Rc21dUhqXiNJHTsaiDaGpE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VfzMrWrWVuj03M8zjs3UPkCxZr/zJIw1s2itxGCqzpYim67h49tJjlJNiYtT0rKT1
         fb+CZpLmj0dZ3NFH5jj43s1zs+UNxmd3YfXGYwexy4lF4IkLHGdBTV6iV7+EZPsGil
         8E6OCSEWxAgxL+VxDLmrO0TJCSxUwo3zoU/go0TB0fLYw7oWyzDgvhiWIIJoFM/Zs0
         NLFZv9fAzVTt/PYcO3QJ4V+mw2zf+4R/XVxqYQzK8tfTNDvXjl1Hvn4ebN/XgB88uY
         qivhR00X/xTp0sKjAmiAKlzj0FdNs61QB6LVLUuVeK1AE/p9Xn1Dwth19fAQE4Uel4
         RpiTFsV9CJcSA==
Subject: [PATCH 08/17] xfs_repair: explicitly cast resource usage counts in
 do_warn
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:18 -0800
Message-ID: <164263813890.863810.9751478113916572434.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Explicitly cast the ondisk dquot counter argument to do_warn when
complaining about incorrect quota counts.  This avoids build warnings on
ppc64le.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/quotacheck.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 758160d3..ba87081c 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -306,21 +306,24 @@ qc_check_dquot(
 	if (be64_to_cpu(ddq->d_bcount) != qrec->bcount) {
 		do_warn(_("%s id %u has bcount %llu, expected %"PRIu64"\n"),
 				qflags_typestr(dquots->type), id,
-				be64_to_cpu(ddq->d_bcount), qrec->bcount);
+				(unsigned long long)be64_to_cpu(ddq->d_bcount),
+				qrec->bcount);
 		chkd_flags = 0;
 	}
 
 	if (be64_to_cpu(ddq->d_rtbcount) != qrec->rtbcount) {
 		do_warn(_("%s id %u has rtbcount %llu, expected %"PRIu64"\n"),
 				qflags_typestr(dquots->type), id,
-				be64_to_cpu(ddq->d_rtbcount), qrec->rtbcount);
+				(unsigned long long)be64_to_cpu(ddq->d_rtbcount),
+				qrec->rtbcount);
 		chkd_flags = 0;
 	}
 
 	if (be64_to_cpu(ddq->d_icount) != qrec->icount) {
 		do_warn(_("%s id %u has icount %llu, expected %"PRIu64"\n"),
 				qflags_typestr(dquots->type), id,
-				be64_to_cpu(ddq->d_icount), qrec->icount);
+				(unsigned long long)be64_to_cpu(ddq->d_icount),
+				qrec->icount);
 		chkd_flags = 0;
 	}
 

