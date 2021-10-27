Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C326C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 08:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 494A6608FE
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 08:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238821AbhJ0IT1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238895AbhJ0ITZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Oct 2021 04:19:25 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BC2C061570;
        Wed, 27 Oct 2021 01:17:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id m21so2134336pgu.13;
        Wed, 27 Oct 2021 01:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tQOjbBTTRqwxaF+AU8DgUm9IinPwENM37U/QT2p6dLw=;
        b=QL464tjaPQUxDpm+AEGVUvzp46JJo9myEZgddM1JfnqV3ZhFw4yrIxP05fRf4I4T2z
         Nx+efGXZvYD/uHp1JktJ43D4SckKtjrLYmgfQJBoodM5COL6F9FLXzlxZzsAfM0+BriD
         1uHZM0rf5NOvnkqvP/cIyEWPktUSeu/nuQ1YI9zH2M7y739YBUnNRzXDVdCjd6JQWjXH
         6P+iJPdui//EIxjb41tMN4zwNw/guU9pXBuxcjLDxqnxjtkndsEpuM5u95v2S1ycWZiR
         8UdGcQ5Lb9gXXKL0XhWBoxSgGmXpQlAUAa779Af6V3MiLDJAWN8yuNfnOg5dwKVxpOrx
         bg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tQOjbBTTRqwxaF+AU8DgUm9IinPwENM37U/QT2p6dLw=;
        b=7dHinMKH+ysBNBDuyC22EKOxL0Hha7iFhUDuzXQFBxzGAJtZJy5Z2J+NF68KYwNkGR
         IwVShTWfn32fQK4ZaczZxQZGg/nXzXPZqkejiMht7t/NipPeeA6kPa+9bgOPEsESANu0
         VeJTimvvHN19dhuUcweE+cw+H1O6WTzwz2DKVGXBNBPp1rWyA9w3m/ii+TvtG7K/6Jhi
         WY+Y6GnIKUtnt3D+CiueTY6bB71GMB/o61RooWEaNu4NDvTxHmdHF5srWpoXcIEi1bhG
         6bBAkzOn3mK8/75LSibjNUzVFjp63+lNdQpzeAe9YjXpu1U25He0r95gpWyZUp/7dNC0
         XrCw==
X-Gm-Message-State: AOAM5320sBab2vid4Q1JVjBQhC/sPJN0Fgr04s2D+c0v/AeFbFLUJ1vA
        kdUEcfyeawRO53b8ML7dl80fdPB3QPY=
X-Google-Smtp-Source: ABdhPJxd7y1oFhbK65/wgJgXVKMKuEndmIAh2nMUBVTLP87b9kg6XYw21r9mjshU28mzBd4zZMl7Bg==
X-Received: by 2002:a65:530d:: with SMTP id m13mr22858991pgq.128.1635322619910;
        Wed, 27 Oct 2021 01:16:59 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u10sm11022534pfk.211.2021.10.27.01.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 01:16:59 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ran jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH xfs] xfs: remove duplicate include in xfs_super.c
Date:   Wed, 27 Oct 2021 08:16:52 +0000
Message-Id: <20211027081652.1946-1-ran.jianping@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: ran jianping <ran.jianping@zte.com.cn>

'xfs_btree.h ' included in 'fs/xfs/xfs_super.c'
 is duplicated.It is also included on the 40 line.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
---
 fs/xfs/xfs_super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f4c508428aad..e21459f9923a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -37,7 +37,6 @@
 #include "xfs_reflink.h"
 #include "xfs_pwork.h"
 #include "xfs_ag.h"
-#include "xfs_btree.h"
 #include "xfs_defer.h"
 
 #include <linux/magic.h>
-- 
2.25.1

