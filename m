Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1D1C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 11:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiEYLRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 07:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiEYLRi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 07:17:38 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8326F8CCC5;
        Wed, 25 May 2022 04:17:37 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 67-20020a1c1946000000b00397382b44f4so3141416wmz.2;
        Wed, 25 May 2022 04:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LuV2WNWBzFzDFM9UzO8H2iJ9QFWj2tDa1lgS6fde0JU=;
        b=f7KxPQr4TkBQZfu/0UrPf81FTwY8ufQ8HzRDFb0sUZhCYJ3GHx4Bm6Fcr1QzDtTt17
         mxGQ7QGK60fyop8LCIEZzCR+APCME2I4uEQag17zo8N5mC7hd1NO4AH4+BxeyQ/lVz9m
         TpAPZLJi8UgiS2kG2gQ3OR/cwiDxXUCST7eXYnaEO/L5K83EuobvNjdi8L+j7b7zbIXA
         YIsYGnw0s8wRab9vYHk78DTwcgWi1Kq4ZQhE1s00qETQMANf0+ZCZiF58DLW+gi3TnoE
         HuyN3UIl8WY0G5kKjDnuLJHnmnKz66E+GlJOZH7JAV6+PAC9nyyuBFfw1oXQXMEUlv1P
         I7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LuV2WNWBzFzDFM9UzO8H2iJ9QFWj2tDa1lgS6fde0JU=;
        b=wGek6YPwEli08Y8S66rX0lkNdEY4fafI+aboBBEZ5fmqdInqpU0PNnrfG41BNL+8s1
         4UfIu+5BY2r24gthmscnwlcsLny54vidNVPqqogmt8CSqTvPKN988txbXCAEXHzpHEDH
         s4KF+xcJUxmFRq99A0H57eSS3fQMh6uzy5APFZku32S2Vxr2J3a0Xio+wJvKdtmFcT2A
         hlIy640pk5la+977tH2SSDjm6TbxUsnmvaHAG1BI2WtkcVJ/tcAMm7ucywQ31HIJTp8V
         Cn1iWlYuDTtFhfg04Z5lAuVaOBuar8R+00pxsMuRR3Bn5Qktpo87HqJScYbFg8qCs6th
         BX3g==
X-Gm-Message-State: AOAM533p0xSlzfDnkNQ7kRyjEBrCCavOWiHdFFf9uRmX9ogCUe27v83s
        R6cdxrz4jY+GyALxOJaF0pM=
X-Google-Smtp-Source: ABdhPJyLZd6EpS1uB3O4EjN+11yEkNK6du/ru/pBqVcHqv6YGlNxh3hvhtW2EwhAD3Q0czl5kvq1fA==
X-Received: by 2002:a05:600c:3ba4:b0:397:47b2:588d with SMTP id n36-20020a05600c3ba400b0039747b2588dmr7827185wms.64.1653477456137;
        Wed, 25 May 2022 04:17:36 -0700 (PDT)
Received: from localhost.localdomain ([5.29.19.200])
        by smtp.gmail.com with ESMTPSA id e12-20020a056000178c00b0020c5253d8besm2059904wrg.10.2022.05.25.04.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 04:17:35 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATH 5.10 2/4] xfs: show the proper user quota options
Date:   Wed, 25 May 2022 14:17:13 +0300
Message-Id: <20220525111715.2769700-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220525111715.2769700-1-amir73il@gmail.com>
References: <20220525111715.2769700-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

commit 237d7887ae723af7d978e8b9a385fdff416f357b upstream.

The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
seems wrong, Fix it and show proper options.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e3e229e52512..5ebd6cdc44a7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -199,10 +199,12 @@ xfs_fs_show_options(
 		seq_printf(m, ",swidth=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
-	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, ",usrquota");
-	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, ",uqnoenforce");
+	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_UQUOTA_ENFD)
+			seq_puts(m, ",usrquota");
+		else
+			seq_puts(m, ",uqnoenforce");
+	}
 
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_PQUOTA_ENFD)
-- 
2.25.1

