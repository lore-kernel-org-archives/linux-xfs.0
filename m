Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C227C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 06:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED9EE2339F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 06:23:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEGZiwC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfHVGX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 02:23:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33368 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731098AbfHVGX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 02:23:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so2933301pgn.0;
        Wed, 21 Aug 2019 23:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=CjmFFn8T4mzBuFjitRp7RHPNL4LmUIeCq1YFn9vP/g8=;
        b=QEGZiwC7PSpT28dJZ3fuiwQkE1MeAaFFXllRO2uS5DfgLvh3/FvXeIY8ycRsnEi7BP
         AQNrazwXFFilJiBwLE4Ky/0/sroiOAnMVWPxSIFL0ut+R+jKuqF/SUYUeQ871N2+08Ey
         qDC9Ecyuabc15K33WD1LI3XDwk86AHsoxlUtP5hAG7oUcaZRP33ZvcqKx9BARjXCt7iU
         BDI8FIOuSJsfSKP8nqhTlAMTPhGgzqC7so1s+zxuPjXunz9u+1m6d9St+qOXQ7/IUscw
         rNPpNa6F/jsNs9hpU4sDnYD30cfplht66IfY2JCUy9BfkXctMDpD2zUfy2drbDKk7fnm
         zaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=CjmFFn8T4mzBuFjitRp7RHPNL4LmUIeCq1YFn9vP/g8=;
        b=DCGSeu9dU/GzKu22Mdih/TnRHBIicBoJKoH4mAZCUhlDwd6NIQUmDTVMLnollizZxb
         lsCV4cUrURU3Vn/5zE/g2Fx2jugP7YRZSLygTsoPubQDExZlRoeukhTVs2bN4frW846F
         nmaR7J0O7RI7z2hQMtfLmCB0okOdENWV8+xMNqmbgwUesM2b9KsOAht/DW+aNq6Bacqq
         3gVURcdJTf4mjy0a971H0ErjOYL8k3FZkn3dvPwW6lQ1YplL8tWYRRCQspUq3EGdprHQ
         nnzKP7fEnIWM/DGO2G+5xkUYIJugXPhnr0nXAox44AEykWF759OgUwf1ch5ubUvT3EPH
         VFaw==
X-Gm-Message-State: APjAAAXfxpqpbhsf1Czmwnn4eBot0DQ6g9tCmKu38HpShCY8Lu7fOwGR
        leM3RnRruygooDX+lzE3b8g=
X-Google-Smtp-Source: APXvYqxqwtKEpKPumsqvkHiy9cX5AXzad66+0qTPgdR4eANJvlZhZ/oekh/WwciHXrrpsQk1ODTj6g==
X-Received: by 2002:a17:90a:b115:: with SMTP id z21mr3747216pjq.79.1566455005334;
        Wed, 21 Aug 2019 23:23:25 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id y14sm54159373pfq.85.2019.08.21.23.23.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 23:23:24 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:23:20 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, austindh.kim@gmail.com
Subject: [PATCH] xfs: Use BUG_ON rather than BUG() to remove unreachable code
Message-ID: <20190822062320.GA35267@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Code after BUG is unreachable since system would be crashed
after the call to BUG is made.
So change BUG_ON instead of BUG() to remove unreachable code.
---
 fs/xfs/xfs_mount.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 322da69..a681808 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -213,13 +213,7 @@ xfs_initialize_perag(
 			goto out_hash_destroy;
 
 		spin_lock(&mp->m_perag_lock);
-		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
-			BUG();
-			spin_unlock(&mp->m_perag_lock);
-			radix_tree_preload_end();
-			error = -EEXIST;
-			goto out_hash_destroy;
-		}
+		BUG_ON(radix_tree_insert(&mp->m_perag_tree, index, pag));
 		spin_unlock(&mp->m_perag_lock);
 		radix_tree_preload_end();
 		/* first new pag is fully initialized */
-- 
2.6.2

