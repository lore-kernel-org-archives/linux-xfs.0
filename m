Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BA5C4320E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 690926103D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243198AbhIAANR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243032AbhIAANR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34C4E6102A;
        Wed,  1 Sep 2021 00:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455141;
        bh=QE/gJ3M9Ol2NUk33IsGgkfJ48ydFIdhU3NlvX7jYFII=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=blC7b/GnAF4VBniikzxUc1SQSDlm0VdcAifjzvX3g615hUHjTKJ+LfK+334u5kMx3
         FQDXX8M5vkE39xbANzNNgOIP2kZreLbhetGbg1/B5SpAzmUaD/hiZ7BXyAzFJFokgz
         5A8f7cBq2JwBnP4VMS22pAQsumMCZN/pj7J+wN8yaojrlQM+BHrMebBuysBq/Iq1hi
         5MJDTNgu6Kd1bYKMoXnwJ0m6QEdc4yonx3mK9by25Pt8FKJzshx6ViXOdQlvWNTaya
         LpDGGgGtB7ItaBfqiBzacA3M8Q3Bw4Om0XeXeD5c8r9IcSCHDXDpHLLUFhgCEbnced
         /RWm3CFh4rpRg==
Subject: [PATCH 3/4] xfs/108: sync filesystem before querying quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:20 -0700
Message-ID: <163045514094.771394.18013113541883760708.stgit@magnolia>
In-Reply-To: <163045512451.771394.12554760323831932499.stgit@magnolia>
References: <163045512451.771394.12554760323831932499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The new deferred inactivation code is lazy about deallocating deleted
files, which means that we need to be more proactive about syncing the
filesystem after deleting things.  When reporting quotas, XFS only
flushes the deferred work if we query quota id 0, so we need the
explicit sync to ensure the quota numbers are not affected by laziness.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/108 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/108 b/tests/xfs/108
index 8a102133..a3a4c8d4 100755
--- a/tests/xfs/108
+++ b/tests/xfs/108
@@ -47,6 +47,7 @@ test_accounting()
 	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
 		$here/src/lstat64 $file | head -3 | _filter_scratch
 	done
+	sync
 	$XFS_QUOTA_PROG -c "quota -hnb -$type $id" $QARGS | _filter_quota
 	$XFS_QUOTA_PROG -c "quota -hni -$type $id" $QARGS | _filter_quota
 	$XFS_QUOTA_PROG -c "quota -hnr -$type $id" $QARGS | _filter_quota

