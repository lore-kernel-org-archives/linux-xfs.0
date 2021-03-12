Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C89C4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 13:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B660E64FFD
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 13:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCLNYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 08:24:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229968AbhCLNXr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 08:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615555426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k2tjixoAStTnogrhkVymAFfTewXN8ABravtMZnYtE9k=;
        b=XmnNKpMYTor39FcFrkUvsjh6v+eHwKaj5AW+1eubdQipzZ3S6TWazR5FSzpdKsQAPLrNyB
        rr7d9xxN42117EwplWcMLBZ5WqSQ6Vlf+CVZDYncOzNAgEJ/tPvMTUaZtc6i0OEcttzJTI
        JVf95BylrLEwKRglp1crRRMlFBevqvQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-syrtDCIdNF6_NMTq6JzxQA-1; Fri, 12 Mar 2021 08:23:45 -0500
X-MC-Unique: syrtDCIdNF6_NMTq6JzxQA-1
Received: by mail-pj1-f72.google.com with SMTP id h17so1811291pjz.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Mar 2021 05:23:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k2tjixoAStTnogrhkVymAFfTewXN8ABravtMZnYtE9k=;
        b=VC4zV44aI2mFaDBYCEflKExjpCsdMu0Acg1riRcCqUi3QZalwTdQI3CH9DwaD6gLeh
         hly6ASKJsjBGh2g3whNdIiBuys4wcBuhbfhcDHMkdtBmSh82PFrC70yAo9yYaF1jx9Ac
         sgsIRv/m65LI8MxsYb+WyvwJH6kMj0RuKNc3YxPzoju27i0XyWWdayIsFMAbPZpM3ln5
         YF5t6NPpcHTKuMIVli5XjR8T0hlboljHg7R8hrkqW6Z/kQCLfkzVBYIMez1J5EncGjYj
         LIVF6WU49B/iQipD3ALeoJXNjbnGoy1WFui/+jFXvENk8NBLsKyeFg2YhWJrZEsguZXk
         lJag==
X-Gm-Message-State: AOAM5317oPHZ54JlcvXWIeiQeHo9A9+mGTL8SRrz3jTzJpKGBC3vMPRx
        L1lhj7RJecr/EVcSShVPf/WOPWDjCXQamKyaRZzoxt8A0BPBnzuoqdPwIgZF/uvJQzMCZD0pjvb
        irKLqB+5qKa3Mh5EILUdtDyJ5KebT0nUCBNqlsqtD6A/X234zqZ1l1R7v8T2IJbDIdBO5zgtKag
        ==
X-Received: by 2002:a17:902:dacd:b029:e5:cf71:3901 with SMTP id q13-20020a170902dacdb02900e5cf713901mr12935164plx.23.1615555424059;
        Fri, 12 Mar 2021 05:23:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzL+Wyf9kV7inSJdydjTy5qZX4SVPvpUS8Q8UwCKX4K+H26LEK2pR6RSa3ASXATL8NAI3BmpQ==
X-Received: by 2002:a17:902:dacd:b029:e5:cf71:3901 with SMTP id q13-20020a170902dacdb02900e5cf713901mr12935144plx.23.1615555423799;
        Fri, 12 Mar 2021 05:23:43 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j17sm5428234pfn.70.2021.03.12.05.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 05:23:43 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v2 1/3] common/xfs: add a _require_xfs_shrink helper
Date:   Fri, 12 Mar 2021 21:22:58 +0800
Message-Id: <20210312132300.259226-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312132300.259226-1-hsiangkao@redhat.com>
References: <20210312132300.259226-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to detect whether the current kernel supports XFS shrinking.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
use -D1 rather than -D0 since xfs_growfs would report unchanged size
instead.

 common/xfs | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/common/xfs b/common/xfs
index 2156749d..326edacc 100644
--- a/common/xfs
+++ b/common/xfs
@@ -432,6 +432,16 @@ _supports_xfs_scrub()
 	return 0
 }
 
+_require_xfs_shrink()
+{
+	_scratch_mkfs_xfs >/dev/null 2>&1
+
+	_scratch_mount
+	$XFS_GROWFS_PROG -D1 "$SCRATCH_MNT" 2>&1 | grep -q 'Invalid argument' || { \
+		_scratch_unmount; _notrun "kernel does not support shrinking"; }
+	_scratch_unmount
+}
+
 # run xfs_check and friends on a FS.
 _check_xfs_filesystem()
 {
-- 
2.27.0

