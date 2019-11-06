Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B6BC5DF62
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 05:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B58214D8
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 05:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfD2pipO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfKFF7G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 00:59:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53132 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfKFF7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 00:59:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id c17so1923625wmk.2
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 21:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uJBqE9ud2mOJxV1QjmiEy4zPP8F9lt3/SOLmN4cGhLY=;
        b=bfD2pipOSwEY8yD4I3qp+g+xuxaKo7Pijx8314M8s6Kln0glYz9J+qO1OR7AK7zAEW
         gwWV86jH8cE7iDuo3ErYhRFQpd8lfZntzwtPe0EPxoFOeOomuLzA1ur/8NugF7gMx1xj
         VQhoDqGsMFQWc9oCBOwNFOEQsvP+kXIhJ4g64t3rWrUifcWVeOk6VfFbLQ/Ym9Kso8dA
         CcCVhm7zYs3cXk3BOeFLbFHj6m3qc0CVumsE/uQWAb5Nirpqnj0CnvTNDaLAICQYrziy
         3zySk/LgvKE7wxU1h29Sg9Qd21TiBPmUdwo5g1uJ+LgHWfQkYgeAPpIAsppcH1oxXSfB
         xl8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uJBqE9ud2mOJxV1QjmiEy4zPP8F9lt3/SOLmN4cGhLY=;
        b=ZtLVjOB8CBJ/43NYRj5mMA1aJ1nxpH5+rr6QB2qqh2CLprYGMHKB56QAW0GDdkKzpp
         Gz9cRjmRCSOhA6+kP0laU1px0Qq77Uj4P3HFfDK2kAMr/+Q+xSjrZ0e8TTHGVMBd9A1N
         GpuPkV7GCPJuMAI9gzInNaC/icb0CD3k62CAW9PUZNdaa/sMO7yZbZCTCemUqT8f7THS
         aWmHbt/yTOM3hWhbB9u8kgihU2RxRplzCVsiYPWuNwlMLT4adtatnU7XXCPQm+PsWVzS
         zn/g/tM1FlKOU1pvaN4BSkubJtSOut9LIYSWbELBxH/hr13si6NTxdLByE3JHV9NuOfj
         +6FA==
X-Gm-Message-State: APjAAAWL/XfO+x9ijrF48J8vlDeQRDSQgO2iE8YizHlWBiucyfo/P4Le
        PtFCxTvC88cb8Lh/bm2Y+zo=
X-Google-Smtp-Source: APXvYqzVqpmFJXplX5qhvWa2s/sjLp6AiwDN+uWDEc9sDmGHyvTvZQQt2bNyjnRMm17W+NYue0A5/A==
X-Received: by 2002:a1c:cc16:: with SMTP id h22mr811053wmb.51.1573019943000;
        Tue, 05 Nov 2019 21:59:03 -0800 (PST)
Received: from localhost.localdomain ([94.230.83.228])
        by smtp.gmail.com with ESMTPSA id u21sm1996560wmu.27.2019.11.05.21.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 21:59:02 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_io/lsattr: expose FS_XFLAG_HASATTR flag
Date:   Wed,  6 Nov 2019 07:58:55 +0200
Message-Id: <20191106055855.31517-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For efficient check if file has xattrs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 io/attr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io/attr.c b/io/attr.c
index b713d017..ba88ef16 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -37,6 +37,7 @@ static struct xflags {
 	{ FS_XFLAG_FILESTREAM,		"S", "filestream"	},
 	{ FS_XFLAG_DAX,			"x", "dax"		},
 	{ FS_XFLAG_COWEXTSIZE,		"C", "cowextsize"	},
+	{ FS_XFLAG_HASATTR,		"X", "has-xattr"	},
 	{ 0, NULL, NULL }
 };
 #define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSxC"
@@ -65,6 +66,7 @@ lsattr_help(void)
 " S -- enable filestreams allocator for this directory\n"
 " x -- Use direct access (DAX) for data in this file\n"
 " C -- for files with shared blocks, observe the inode CoW extent size value\n"
+" X -- file has extended attributes (cannot be changed using chattr)\n"
 "\n"
 " Options:\n"
 " -R -- recursively descend (useful when current file is a directory)\n"
-- 
2.17.1

