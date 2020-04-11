Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54566C2BBFD
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E0C02084D
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H35kJzH8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgDKJNL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 05:13:11 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50410 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgDKJNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Apr 2020 05:13:11 -0400
Received: by mail-pj1-f65.google.com with SMTP id b7so1683421pju.0
        for <linux-xfs@vger.kernel.org>; Sat, 11 Apr 2020 02:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b/HrqhlALNMNsgAa6ZsrHkoGMszeeOK/UwinqGMTQKU=;
        b=H35kJzH8EOXKtHluHYgXFd0hctq20+OnMRSqMmTFcrSL4gj5hMlD9dY+9mSuoLwm8n
         3GlfTdUoYwNUmrttb8j6NK2+KUmBZSoVU+DruJ5A2jeZhy0BMAF+lR6QLOZy6/5DMMKx
         1ghoQo7KcpnbsQNB5uOF5kE/uNDcPqiXRbPVvCVDYqJWCL72Mq/O+JMv/O/keHdIL9w/
         zmXbqBV3HluezwQvi9dcyKs1gGZXgJC/myZAQ2b7R/VlewVrrNJaK1CMErNPyHcIwGzY
         jNmkRWopNeVqHqkImSsaidQXy8pKjEeSqPjg2SQaOiuYfPiogaXTEvdmWSzHbMyj8My5
         ftSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b/HrqhlALNMNsgAa6ZsrHkoGMszeeOK/UwinqGMTQKU=;
        b=Vm1HqOSGqQ0/+EaUe0XJ8UkN/3f7JYSBjRyZPU/xTxfDLuwdNAmcnjWZMRq5MJOeO7
         nd2pppYv2TlQWEcuU06ARx4XCn9Y360z7vm63inrGdHV2CLn7SbQVou1iJOVhvODbKyC
         XoDp6S9AIikxSLqlCyGwmpHuhnaDIX1kE1JgiralxKcNynCIYRd0+aBmnl0v2y20gnEb
         pkG/Ys2tgLaMQarJyR64UWwJ6DHLPGI1SN3j3bQ6gEuRiQfpn7nvBCKZ65NYfkIVAbiU
         SKWVjYhiaY7JoAPNFwiqZjzEy5kqPSzSNdpVV4kam18OGCAj/8RJYGZtI4y6hLtWI0CK
         Kdtw==
X-Gm-Message-State: AGi0PuajYcKiLrT75T1+xE1eKjDeaEcJokQEpF3Fyz6iUQPu0KgRigGN
        KY/qjK94dnNc0QWsWQzhkMQv6Hk=
X-Google-Smtp-Source: APiQypJ4rLlFuSkM1SQbXpFtkpxfE771F3FyTDB1EUTRbwBkPBOBd1329cLUN9M/zeCpXlyyK4OKXQ==
X-Received: by 2002:a17:902:561:: with SMTP id 88mr8637784plf.78.1586596389470;
        Sat, 11 Apr 2020 02:13:09 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id n7sm3280364pgm.28.2020.04.11.02.13.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 02:13:09 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 3/6] xfs: reserve quota inode transaction space only when needed
Date:   Sat, 11 Apr 2020 17:12:55 +0800
Message-Id: <1586596378-10754-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
References: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We share an inode between gquota and pquota with the older
superblock that doesn't have separate pquotino, and for the
need_alloc == false case we don't need to call xfs_dir_ialloc()
function, so add the check if reserved free disk blocks is
needed.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_qm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6678baab37de..b684b0410a52 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -780,7 +780,8 @@ xfs_qm_qino_alloc(
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
-			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);
+			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,
+			0, 0, &tp);
 	if (error)
 		return error;
 
-- 
2.20.0

