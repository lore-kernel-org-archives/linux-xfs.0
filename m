Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4437DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 09:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E641320758
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 09:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhA0J1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 04:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbhA0JZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 04:25:22 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76DAC061797
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 01:24:14 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id e19so809465pfh.6
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 01:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y/bDdpwyp0JJWA0eALmj8c/lGgHCPq0h8LS7iO8aTdg=;
        b=sanfl//3doixkEwzH93cdsBDZwBTmB51kH+f7NCmqW26nv44vYn5zvNuJuzhu+KXW7
         WwRY1HFQSk19XP4L4GGghfOjQopCSGu48A37bS6W2KMQ+5gEETbX127gWVBaF4A71jMr
         d3iUfIcmIS/UQNchnYnvJtTUTeThlsK6htxHfBQZ0ZnObHLiA0t91N5WNhbopiW3c8eZ
         uKRrIzzR7JS9j1+p/bmTTfEHG8+I0FZbKoNXonx//KVBA0j9KclBpYCMl4MZg4Wie/hn
         Q90M6zUVJZ5whC/BVITvMMM17YbvMhBRUffjP09wIcNRlXro6+wnzxSnCkNuEBbeFDDm
         +dTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y/bDdpwyp0JJWA0eALmj8c/lGgHCPq0h8LS7iO8aTdg=;
        b=Mqny7nmz07TXa70Nn4kujR/G9CnHv9yVssJ/WyfP8D46dyKwBYM7RJhghoS2nbLy/Z
         NHvZonScr4QfSe+2+D61uBjOcaxMAFtZHm5z6xRaHCvhQTz0QSgPneTgBY3u9qIk35BM
         IaItAE52moDO9F9bs0B9S1b5SDqSzHNapUPjajoTQ2oJYgtn+OLSQZtOc+RFkOTeKmNP
         1HnbcAtUeczflgkFzEALfr8VcLQ0jJumjO7RHhT+ZVXTJTzZpQqVhNLD2VFZKuS0M5/h
         UvvSAm4O8Gz3J+WAlINkjL4Dw41OVQjk0u86ng1T+e2oJ3HxSmie2u3Zajkj4t8uS6yq
         QWaw==
X-Gm-Message-State: AOAM533Xcuyr8xQVZEcSTaWpjofarXLiisSvjcMIVURGnqYEH7fPOoA2
        TCz0zLn5yZ3x9/g5QVKLTx2QDS/lp/Y=
X-Google-Smtp-Source: ABdhPJynZYDhWvFu6G3qKJHwgoVG9+9RurUOCqdxo07FRjPjFOYtnM3xjW3f/ooiJiqCZ39u8JFSWA==
X-Received: by 2002:aa7:8698:0:b029:1be:aef7:449d with SMTP id d24-20020aa786980000b02901beaef7449dmr9736292pfo.60.1611739454305;
        Wed, 27 Jan 2021 01:24:14 -0800 (PST)
Received: from localhost.localdomain ([122.171.171.5])
        by smtp.gmail.com with ESMTPSA id i62sm1700234pfc.150.2021.01.27.01.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 01:24:13 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, sandeen@sandeen.net,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH] xfsprogs: xfs_fsr: Verify bulkstat version information in qsort's cmp()
Date:   Wed, 27 Jan 2021 14:54:05 +0530
Message-Id: <20210127092405.2841857-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces a check to verify that correct bulkstat structures are
being processed by qsort's cmp() function.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fsr/xfs_fsr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index b885395e..de7e8190 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -582,8 +582,13 @@ fsrall_cleanup(int timeout)
 static int
 cmp(const void *s1, const void *s2)
 {
-	return( ((struct xfs_bulkstat *)s2)->bs_extents -
-	        ((struct xfs_bulkstat *)s1)->bs_extents);
+	const struct xfs_bulkstat	*bs1 = s1;
+	const struct xfs_bulkstat	*bs2 = s2;
+
+	ASSERT(bs1->bs_version == XFS_BULKSTAT_VERSION_V5
+		&& bs2->bs_version == XFS_BULKSTAT_VERSION_V5);
+
+	return (bs2->bs_extents - bs1->bs_extents);
 }
 
 /*
-- 
2.29.2

