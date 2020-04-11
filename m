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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BECC2BB85
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB2F52078E
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KhElO5ki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgDKJNI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 05:13:08 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38766 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgDKJNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Apr 2020 05:13:08 -0400
Received: by mail-pl1-f196.google.com with SMTP id w3so1481102plz.5
        for <linux-xfs@vger.kernel.org>; Sat, 11 Apr 2020 02:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YbVuazt/pfKinOclf8G2/AcnAHD/29gN8FR5Y/+Jwcw=;
        b=KhElO5kizlJksVg3m6j2m85dmrEdGBKEUTPlQU2t3/w4l095ZUamofXZsiGWr3Fn11
         kmpvjzsYp59Ipe66G3mdtMIEDZ7fHD4ATHOIdI0P9M6u9jSyQCHq/55urGRJbSVrL61D
         3DtHLMrkCoGWZ+OgW895RfmVhFhkyVlgnZbA+OX1oF8eTqcNUGZNEBNb+Jo6MHsYfEY6
         lRx7LUWSGnFOMB1Zw1a1rOJS9BlvU4NU2ATjUBiFrbjUcfyg9lSBjvw1xYhcl60F7v+V
         Ea1lN0v7drzWqlpQOa2rmEG7rhL3SkeOB7xSF6f5bfkR+Ssls5gIHR/GbIl/JWEq4/Tc
         wB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YbVuazt/pfKinOclf8G2/AcnAHD/29gN8FR5Y/+Jwcw=;
        b=eKUBIqrWEeILkS65W8GmqySZ5zsyEq/9d2vn26CVDCm55CmyTAzycCcLfcI6txnobx
         zURYkT1KbOsZkYj+GjersHQw7mETH8nj0TOlcgpOcEqnwlRakwwmdKO/FaRLzffg2wKi
         g8Yo3/S9hWvFrW2KgDxMBWm3psHKgE9WxLqXPttnRGivfGuz7u4KRciGJJuKkYIYdLW6
         P4LVTCrS97bKmR4twV1mAvAWaOEk3RsB145aGBhh2gkwAO4Plc/ytjrqgo7f4APBRhzU
         U6c4DHE+ShX0ft7TIKyiTuShpFecZHMGy8B2kSHfIv6rCR0C9nHM5fb8Ky/ZsAoLq436
         5muw==
X-Gm-Message-State: AGi0PuY/4AZ3xCA2AtxT1c2wcpXJq9FgbrRdcJF2VK8QN6CA9tX4AULp
        pvv78x5lu0I6lgEBCqqQDfIQRsk=
X-Google-Smtp-Source: APiQypI3rzKr1UDv3tunctWDAJs5rqFCpaiy8jCV5Gxk0LfQNZVYk1HwyZZcWOOsd7iYa7AyOiq94A==
X-Received: by 2002:a17:902:690b:: with SMTP id j11mr8684168plk.236.1586596387875;
        Sat, 11 Apr 2020 02:13:07 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id n7sm3280364pgm.28.2020.04.11.02.13.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 02:13:07 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 1/6] xfs: trace quota allocations for all quota types
Date:   Sat, 11 Apr 2020 17:12:53 +0800
Message-Id: <1586596378-10754-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
References: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The trace event xfs_dquot_dqalloc does not depend on the
value uq, so remove the condition, and trace quota allocations
for all quota types.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/xfs/xfs_qm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c225691fad15..6678baab37de 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1730,8 +1730,7 @@ xfs_qm_vop_dqalloc(
 			pq = xfs_qm_dqhold(ip->i_pdquot);
 		}
 	}
-	if (uq)
-		trace_xfs_dquot_dqalloc(ip);
+	trace_xfs_dquot_dqalloc(ip);
 
 	xfs_iunlock(ip, lockflags);
 	if (O_udqpp)
-- 
2.20.0

