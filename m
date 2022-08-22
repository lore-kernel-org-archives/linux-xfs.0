Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFB4C32772
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 16:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbiHVQ2X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237014AbiHVQ2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 12:28:15 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9E92A2;
        Mon, 22 Aug 2022 09:28:13 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k18-20020a05600c0b5200b003a5dab49d0bso6309559wmr.3;
        Mon, 22 Aug 2022 09:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=59bI0yR2jhIr7DA55+u7TB6jQiSVDZFeMCHEmKcrfqs=;
        b=AHjq2nTcmkrdEHKSt1IjuUkA4AkTGYH/M53d9Cjo6tX8x12+YMTcfni1wU7w6VKxMJ
         TGRLnYjDNze0BI/XPAR3s13GK+74QEHNUuzQH11WqHmQ7yJGfMEM/gWYEVrXZQH6dMPZ
         F4eJelGT5N5LkuXvTmp/rDeE84xOCCal+6RwHAdoYbenw8XxnlLfzowi6xU0+sNx/C7r
         wMi04hlkvSHM/FV5JLi/9xy8B2VZ+f8XdDZ+eybSxCxiSyvRA2+Td/NMQwaK3Tetv0Qt
         gBI5IgPmIHHbvKg5Jwmi+JsyRL7sdzQDKGCSeJM2NVRkVq63dZj2Pg/bZ0b/GE8dNmUa
         GrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=59bI0yR2jhIr7DA55+u7TB6jQiSVDZFeMCHEmKcrfqs=;
        b=Fh/C3ON5rn+WqCbQuK6t7yI4y7aE2lksk6IUZxY21mznCmDat71uSSoilMtL6kF+jE
         yXQbtLnXA/E9tkGtzilURX5wGuBp+U1WXFWTT75dWyXYXJUnPEjRxvcjskgVL7v2A5HJ
         kL5FFCAVIlg/S7T+J6eVTzCUY+g54eY2Dcj78bWcwt7n2t76UF/lzsjPMQ5mlDHf4PxN
         P0NFnApiBzWd4B1pWd8YhG75QAxN58sni41CI28GkfAXyHvIcYVztCaFg2nLJWS/LWXm
         ile1rPxZqRD21KUNU+CLZd7r0JZlcNzzChHH8dEq1alBZwOz8LEEWPf5ci+gciu1QQS9
         pKOQ==
X-Gm-Message-State: ACgBeo0Or5cdZQRpZ9pfW7CYvpIiScBW/Uj66Kt8mPkUh7IT6yQdV+ae
        m+y5Hjp/zHFv2cQoBwoFGps=
X-Google-Smtp-Source: AA6agR7HtIgZumh2Bal7Job0hNfZhRdT5pqSBvP0JFX+cnUYafm10CcVXENgjOP5fkfdlL06Ps9PEA==
X-Received: by 2002:a1c:a187:0:b0:3a5:e055:715b with SMTP id k129-20020a1ca187000000b003a5e055715bmr12975931wme.171.1661185692443;
        Mon, 22 Aug 2022 09:28:12 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d44cd000000b00222ed7ea203sm11749229wrr.100.2022.08.22.09.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 09:28:12 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 5.10 CANDIDATE 2/6] xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
Date:   Mon, 22 Aug 2022 19:27:58 +0300
Message-Id: <20220822162802.1661512-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822162802.1661512-1-amir73il@gmail.com>
References: <20220822162802.1661512-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 29d650f7e3ab55283b89c9f5883d0c256ce478b5 upstream.

Syzbot tripped over the following complaint from the kernel:

WARNING: CPU: 2 PID: 15402 at mm/util.c:597 kvmalloc_node+0x11e/0x125 mm/util.c:597

While trying to run XFS_IOC_GETBMAP against the following structure:

struct getbmap fubar = {
	.bmv_count	= 0x22dae649,
};

Obviously, this is a crazy huge value since the next thing that the
ioctl would do is allocate 37GB of memory.  This is enough to make
kvmalloc mad, but isn't large enough to trip the validation functions.
In other words, I'm fussing with checks that were **already sufficient**
because that's easier than dealing with 644 internal bug reports.  Yes,
that's right, six hundred and forty-four.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d973350d5946..103fa8381e7d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1689,7 +1689,7 @@ xfs_ioc_getbmap(
 
 	if (bmx.bmv_count < 2)
 		return -EINVAL;
-	if (bmx.bmv_count > ULONG_MAX / recsize)
+	if (bmx.bmv_count >= INT_MAX / recsize)
 		return -ENOMEM;
 
 	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);
-- 
2.25.1

