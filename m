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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E061C433E6
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A3B165220
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhCHPv5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhCHPvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:25 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7B5C06174A;
        Mon,  8 Mar 2021 07:51:25 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id e6so6659654pgk.5;
        Mon, 08 Mar 2021 07:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a60rAA10+0aRj/BaRwZZKR5m5VDRjd9v9w0MF3LiagM=;
        b=k606r/2QLpUbO4nlydC3IQyLzq5LFE6jASFnA/aGQo64GqfXBZLwtERibos6NeTl7a
         zpuZy9B1duGOBMHjEuYmyMmiF4wrMd82cU7PHz2aZlEeDr+9a7Id5JHVUdvfJ3z44ZLn
         E3ueqWLzk+G8xoPhC/Pifbd2VV6jXA9r63X3WL+/YpzmHW7/AY+laC/3QgWiQFFa/0D6
         GTFGk29GbdTY+WYIF6B8gIqs8UQ0tut0Ms8aciTMz97gi4IGcokG7JOeIY7zzmpoJy1b
         gb71XUy6I3Cv3RxN7d09F4UVh4OCrCdi8VBwtO2wVTU41hLXQsaAfTAJLk2z4dWWOVMi
         p77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a60rAA10+0aRj/BaRwZZKR5m5VDRjd9v9w0MF3LiagM=;
        b=HzCmg9KmO/txI9cEH49dQkRhnDPLIAX6YGSlAkt6gFzqkygKyIUx6xtYqndUXHcrUS
         LayxtSfuxvZ0XCdEgjT5ovqeoBOsyPGRu/2RjpQmCwzf89oZsZIsf+U9tF/vNlcVkcSP
         D+/BHIxEFvmS2x3/cR8B7+UzUEb1ChORjRGRBi1l4n0Q8k70Y6OPonWhwqK0THcjmABJ
         SUSscOSYw+cNxD11JBPKvsv4Wd9Lu8kz+zmvk7fGE/wtXrrma0F9U6HtKtioovQgfNS/
         /+xQMxEtmF1SOsIHoCyT7g3QffICEoOFgdcRLJPHuRDqo/NP8FbXFpm4y8qypIURVb5z
         h01A==
X-Gm-Message-State: AOAM530afpC+N2LLADYFkRb5UJULd4ieaeAKQov58MzmZXu9p/oPs16W
        WyaXwDHOG9zJaUCdsX+wki21sG0N2pw=
X-Google-Smtp-Source: ABdhPJwOZi/49KfYEBCq6rlDsIXyDGzoJ0DFPkR1xiWYp8Dkc1x3kOM4T7onZFQZ7gYFsKy9XC37sw==
X-Received: by 2002:a62:8103:0:b029:1ef:26e4:494f with SMTP id t3-20020a6281030000b02901ef26e4494fmr19171525pfd.41.1615218684816;
        Mon, 08 Mar 2021 07:51:24 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:24 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 01/13] _check_xfs_filesystem: sync fs before running scrub
Date:   Mon,  8 Mar 2021 21:20:59 +0530
Message-Id: <20210308155111.53874-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
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
 common/xfs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/xfs b/common/xfs
index 2156749d..7ec89492 100644
--- a/common/xfs
+++ b/common/xfs
@@ -467,6 +467,7 @@ _check_xfs_filesystem()
 	# Run online scrub if we can.
 	mntpt="$(_is_dev_mounted $device)"
 	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
+		$XFS_IO_PROG -c syncfs $mntpt >> $seqres.full 2>&1
 		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $mntpt > $tmp.scrub 2>&1
 		if [ $? -ne 0 ]; then
 			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
-- 
2.29.2

