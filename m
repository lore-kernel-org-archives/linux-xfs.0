Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BEDC3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 06:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 733072189D
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 06:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cx9/eKyZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfH1Gry (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 02:47:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40450 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfH1Gry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 02:47:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id h3so753917pls.7;
        Tue, 27 Aug 2019 23:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=bnr47kjwSYX7sFbyrZuRL9/chJw1MwjbhZytcoBlB5o=;
        b=Cx9/eKyZMzzteG75d/97TvQdpvxY/AUlPeUQmItGvpwgkinp3omAK5ctohoduuAUgf
         jXKKrh/NL2VTWn42aHIOX6MsZ8DNj048vQ+7qjLPrsx+kBlL4RNf6grEVohifDFAgIEb
         H/upWcS4Rj6nVpuiPt1L4g3XYsusYygNas5of2T60fZbfdpKTKPmsDi0rVnBXggDpC4d
         v5uMNv+AeoBc9jsq6RnC65wHU4ZUd5twIthsPjpbe7HLn+cyBi89+4aqgUeJaRJbGeKD
         WpZ3s72o1ch9NrNYxIxj9qktepdSk49MRQnGGjXUb+ubbj36Db1a+q8Vmd2fXOyNo7P1
         RdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=bnr47kjwSYX7sFbyrZuRL9/chJw1MwjbhZytcoBlB5o=;
        b=gEVpr2V70d+hnjHpDPma2o4MI8zcCJtj5q3ZW6RWS2CuIF4YEzhAr3k+NHiUjnVFg+
         bO+n9tu82XJGgKQ8PqkAKrBQ2kQiOLxl92j9aZKfnvKzHCQGXtUwHWH4AOi5YNk2iKFP
         TKv8VVzE9IMC9J07BXuMCslAcAbkAioT7P0KdS7HDV2QBU/r1PW+6QjjF/ewuOEvGYlF
         LKexqDblfBv3tlGbi5bxGK79BoZcQ8Rg+Yac+BojkD7pyIRNz8pjwNhshVwgq+i8+fof
         NhliIq3vA/czFQ8pI2vid6q1TiacqtwOgw9b6KI6trUQiZWxbQoK4UQDaK496zi8/z9Y
         v57g==
X-Gm-Message-State: APjAAAUrF6rnC6UcwUVFFrTfETVz9hDnvTxns6ulhuyO06UkN7d3KZzb
        O/1q0qRZeC1xOAZl0bcHopA=
X-Google-Smtp-Source: APXvYqwzylxpvp8rlW/hz8moz4sH8dXXtH+TZp8HF2VekHJ0Re5+eZzRrrarSINiZfPjbeimtCBYhg==
X-Received: by 2002:a17:902:7085:: with SMTP id z5mr2814826plk.102.1566974873772;
        Tue, 27 Aug 2019 23:47:53 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id 21sm1437347pfb.96.2019.08.27.23.47.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 23:47:53 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:47:49 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        austindh.kim@gmail.com
Subject: [PATCH] xfs: Use WARN_ON rather than BUG() for bailout
 mount-operation
Message-ID: <20190828064749.GA165571@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the CONFIG_BUG is enabled, BUG() is executed and then system is crashed.
However, the bailout for mount is no longer proceeding.

For this reason, using WARN_ON rather than BUG() could prevent this situation.
---
 fs/xfs/xfs_mount.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 322da69..10fe000 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -213,8 +213,7 @@ xfs_initialize_perag(
 			goto out_hash_destroy;
 
 		spin_lock(&mp->m_perag_lock);
-		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
-			BUG();
+		if (WARN_ON(radix_tree_insert(&mp->m_perag_tree, index, pag))){
 			spin_unlock(&mp->m_perag_lock);
 			radix_tree_preload_end();
 			error = -EEXIST;
-- 
2.6.2

