Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27816C43381
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F01576529C
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhCIFB6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhCIFBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:01:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33109C06174A;
        Mon,  8 Mar 2021 21:01:43 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso2071025pjb.4;
        Mon, 08 Mar 2021 21:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0BjEaPOIKQtoDE+eA2oSNZHxmTPwgVx+fwQsgvNeC8=;
        b=jHDtDnXX8XKn7G6mwsao0jzknptpkoUpJ9Zx9FUn7LFXGOenTeDICRliKEZkTY0d7M
         5RR2Qw7mPmZOuvPiN2Xi9A4ZNKJMWxZ4odH9Ocu+0jBzHValWWu677i2dRrRZSnBJ7E8
         PMlgth5ZSKfnMjytKxpn8KYQkrFeYjDar8AwEOE77gQRpoIKnNGw6E87+LESv8UUHIjs
         X9BIGmR/0/4mhvcF306lT5KYF+rv6N9Z5QPuga3kYs6gMpI94+iigbAXmMcIWublDf7m
         BRVruQ4mpAE9kuQduHqm5YDGUT32iW5rDe4znHI5PB0CMHZJFiOjcPC0D+MPI7Q+iL/b
         xGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0BjEaPOIKQtoDE+eA2oSNZHxmTPwgVx+fwQsgvNeC8=;
        b=fFbQ/KswXkPVMu1/WDRBU6KIbk6KLZD2JaKMlFhD52DBN8HG1QdxeewWtr1tfaQ9aN
         YoGk04MdW2duHtkbt4tdOrzQtQmqmyQMrwjyG/ED9p6JmLC7R+biQi26rxJj4dDm7EdW
         GvyE/1Qxd+Y+DPePk3oa62G4VWKCfRWRs5JMfHlIoxnGD11mj7354iaPNEABGuZiUAUh
         0nKj0M6l3vvjlpRS6U+0+z3sM1vLljcarzjxaMeMFdGqTKA+VbdzJ8dmh+dm3pFBQKAR
         yopTxVduYnGU5h39Mx0KQYHZBdJd+wSJfPEsgXyhv19MeB1Zs+gybGueg6peog4ZIfrn
         0aRw==
X-Gm-Message-State: AOAM531cejmfliJ5DV8ufo3B78FYYp14uMHmNehYO9vSUqMiFzk2+S26
        5sSRyG81DIRQatgHu2UXzfZT2AtRZAM=
X-Google-Smtp-Source: ABdhPJzN9OindyTc/qAwsNoDZAV3nsH8eyISpExeK3+kRh0O2KSJecUr6mq7SxvhdZZPYvECBttLkw==
X-Received: by 2002:a17:902:ed95:b029:e2:d080:7e0e with SMTP id e21-20020a170902ed95b02900e2d0807e0emr24515771plj.85.1615266102518;
        Mon, 08 Mar 2021 21:01:42 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:01:42 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 01/13] _check_xfs_filesystem: sync fs before running scrub
Date:   Tue,  9 Mar 2021 10:31:12 +0530
Message-Id: <20210309050124.23797-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Tests can create a scenario in which a call to syncfs() issued at the end of
the execution of the test script would return an error code. xfs_scrub
internally calls syncfs() before starting the actual online consistency check
operation. Since this call to syncfs() fails, xfs_scrub ends up returning
without performing consistency checks on the test filesystem. This can mask a
possible on-disk data structure corruption.

To fix the above stated problem, this commit invokes syncfs() prior to
executing xfs_scrub.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/xfs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/common/xfs b/common/xfs
index 2156749d..41dd8676 100644
--- a/common/xfs
+++ b/common/xfs
@@ -467,6 +467,17 @@ _check_xfs_filesystem()
 	# Run online scrub if we can.
 	mntpt="$(_is_dev_mounted $device)"
 	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
+		# Tests can create a scenario in which a call to syncfs() issued
+		# at the end of the execution of the test script would return an
+		# error code. xfs_scrub internally calls syncfs() before
+		# starting the actual online consistency check operation. Since
+		# such a call to syncfs() fails, xfs_scrub ends up returning
+		# without performing consistency checks on the test
+		# filesystem. This can mask a possible on-disk data structure
+		# corruption. Hence consume such a possible syncfs() failure
+		# before executing a scrub operation.
+		$XFS_IO_PROG -c syncfs $mntpt >> $seqres.full 2>&1
+
 		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $mntpt > $tmp.scrub 2>&1
 		if [ $? -ne 0 ]; then
 			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
-- 
2.29.2

