Return-Path: <SRS0=bjGU=EK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2458EC388F7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 11:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF075223FD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 11:49:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7XrkFln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgKDLtr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Nov 2020 06:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729436AbgKDLtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Nov 2020 06:49:13 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECEAC0613D3
        for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2020 03:49:13 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z3so10709197pfz.6
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2020 03:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b+v8iOmZaqsj2fntC71M48/PE0PbE8HNgVyI1tEYuXk=;
        b=C7XrkFlnCT/AEZLZqh7H9FQVyb6B0fQytBwVBPjUdpe9k6EyGNMZ+McTa8RLIaKuzi
         2EfWHaMrWy4NUYGybMlZMLaJUdLDqMhdbyXnaa9NdGDUHG9nI7RblswZ93XDkaYUfZrR
         rb4kE8br+ij1btJr0Sgsacv+3HZ7qED9GImba/iJpCy063hd2vlQco5QVzvaTNPn1qzl
         PE9Oopt2UkYNoi7eL8n2vbRgi75p5Zfzz4W+rIUpykLfbxUJqBi589cZNkPq8CXtZsEi
         IjcFgJZXooTedm5Tw5ZhOUTvmcFe3uchJ//HKx69vbnhkNpIyrY3+CY17iLolbngWVTP
         8Y6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b+v8iOmZaqsj2fntC71M48/PE0PbE8HNgVyI1tEYuXk=;
        b=LSMOKwukMUcMO2900Qc9r+yFxQy5zpI1trQOYMsmIXIyDori31Vp0bwpDua7dRi6lu
         +6Ocwqi9uRn8V5L5rx70cKJ1hlG7NEF0cvnboG6gEbv9EV4sn0TYoicFHNPFVOa4Wgjc
         l3e8rqpml3iIb70Yr7bTgHPrKTk7l932PttSR/Z4GLtTF5IPO+QXJXE17xI3RcplkaSq
         4PNKEpRSQCgBU2vMJ4xCYOd/0hyVRAJL9DYdsdq1SgVFhKLxqvWroFrcVJtJIEqvnLkF
         ndxqnYJaNM96Fa7a33swu7oeUMBO5dyQH4BaqA+wUg63OqdQXlqq8OSxXB9b8DWQVCjf
         FT1Q==
X-Gm-Message-State: AOAM530SPpbivU8gWwaowzqJ4TNFaxzVby3eV5NW+AwMVW8AJ+0aAUOg
        /9ZFmu1dz1CUp4f9FXfXy6sj8B9dKXA=
X-Google-Smtp-Source: ABdhPJwakBW0zSykWiIybPwOkUq8bvgfujtuZ5Qrq2AQwOh2MbxY7fpdSHn/hRADW6Nu/KL2A71G7w==
X-Received: by 2002:a17:90b:1094:: with SMTP id gj20mr3964309pjb.202.1604490553067;
        Wed, 04 Nov 2020 03:49:13 -0800 (PST)
Received: from localhost.localdomain ([122.171.54.58])
        by smtp.gmail.com with ESMTPSA id o13sm2118819pjq.19.2020.11.04.03.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 03:49:12 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        allison.henderson@oracle.com
Subject: [PATCH 1/2] xfsprogs: Add error injection to reduce maximum inode fork extent count
Date:   Wed,  4 Nov 2020 17:18:58 +0530
Message-Id: <20201104114900.172147-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
xfs_io's inject command to reduce maximum possible inode fork extent
count to 10.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_errortag.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 352d27ce..9e3d5ad4 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -55,6 +55,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
 		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
+		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 53b305de..1c56fcce 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -56,7 +56,8 @@
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
-#define XFS_ERRTAG_MAX					36
+#define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
+#define XFS_ERRTAG_MAX					37
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -97,5 +98,6 @@
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
+#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.28.0

