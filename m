Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4437CC6379D
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A01E22269
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LZHn3CP8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgKUIXr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIXr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:23:47 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DF5C0613CF;
        Sat, 21 Nov 2020 00:23:47 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f17so940600pge.6;
        Sat, 21 Nov 2020 00:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tuRANglPuvCThAaGoAF4a7CUchGXxnbMIAXQeoen4YY=;
        b=LZHn3CP84hnZZ/AGPFzjgUj3uiC8QafHA04VQdrJZ5ztVY9kWfORdt3dg6B0MjlS1g
         2eqlhtpD9XMdDxdglDp1DG73Jt7HpF8QbXDPP7ljfroRjYMTl6sd/74rK1YPhg4w9P9u
         rVFhcPoxgUCaqLW+ELp07OLbCqDnZMFvHLJ0TRcf5oNKhX2MbBW+rUoMEK7zzZBQA+oB
         x+FxFO5pazexxWlos4bvrBnVyL36FXJ/xpjJdYj/ikd/FVKzyTBqUFVJLLVmXtZdYLgf
         VoocWddkh7mNq/yn5AVdcRE8aLocRRleswMRxhADYY+ghwgd6qtJXGFGTkIKktYs8kjQ
         YGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tuRANglPuvCThAaGoAF4a7CUchGXxnbMIAXQeoen4YY=;
        b=n/J11whLnWSYPN2acRjo+ru0evVWBr+LRPVZQcMy7/wqCuCK5WNjyZ5qFmw69A/oCu
         aqH8gZt10lyDuEhu0WTvbIn/72GHrLiHBzC4rpUbwvhNy9TOkDc797UZzrJAn0WQ12IE
         a1ZeNfshRd57dJFg+d9Z5N9h2iI4s8NpKyg7GzdlKR1psvmJt/taRmrXRdyo54OJuS1M
         HT34HxX51ABKEnWmPH0/kmrVJDc36ew3J6UdHN1Ge8lgYZiQMGbOzwLlh5CATkJJj9tw
         h7OyeXFAr0S5CDDLOfcJvoMK8rnQa55xgExTJK837qKxyqV64bdKFxAkvM2Cx1G02QLj
         iCIA==
X-Gm-Message-State: AOAM530cl5HdyjhoU7j+n15C0PDm1lBXHveBN3viwd8M8/B6Porg2EZ3
        Go3Ilv2H4BwOLp3SjPH1xd1Ze9CN5fY=
X-Google-Smtp-Source: ABdhPJxJniW8psw65O2/w5HeUlqLv8jDh+5o6wVUqYFBT4yApSIrijy4XLafhKw+hBOrOB1cmUb7Qg==
X-Received: by 2002:a17:90a:7f81:: with SMTP id m1mr9641866pjl.169.1605947026557;
        Sat, 21 Nov 2020 00:23:46 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:23:45 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 01/11] common/xfs: Add a helper to get an inode fork's extent count
Date:   Sat, 21 Nov 2020 13:53:22 +0530
Message-Id: <20201121082332.89739-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the helper _scratch_get_iext_count() which returns an
inode fork's extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/xfs | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/common/xfs b/common/xfs
index 3f5c14ba..641d6195 100644
--- a/common/xfs
+++ b/common/xfs
@@ -903,6 +903,28 @@ _scratch_get_bmx_prefix() {
 	return 1
 }
 
+_scratch_get_iext_count()
+{
+	ino=$1
+	whichfork=$2
+
+	case $whichfork in
+		"attr")
+			field=core.naextents
+			;;
+		"data")
+			field=core.nextents
+			;;
+		*)
+			return 1
+	esac
+
+	nextents=$(_scratch_xfs_db  -c "inode $ino" -c "print $field")
+	nextents=${nextents##${field} = }
+
+	echo $nextents
+}
+
 #
 # Ensures that we don't pass any mount options incompatible with XFS v4
 #
-- 
2.29.2

