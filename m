Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C9BC3A5A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69FFE2077B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfH2Qvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 12:51:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37267 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbfH2Qvd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 12:51:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so4170157wrt.4;
        Thu, 29 Aug 2019 09:51:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1BnYpBfZLwpA0PUdACNai/emnPM3Y0NcYvtOEszcGUE=;
        b=EIeLKmLcL0KJYL9wF2ooxeC8hphqrPj9AFFs5bS1DdJoCZIBJs/rnI3r0Hm5qhDceB
         3bH6oQFBtZpbU6+MYkS3tbg4fwzipNwYmWE82LlPA5zVd1T11OulwVU4fqap70lHFObe
         aiddbBMNiwZcj8obVH+Aqg1VKC8ZoDUxR+4uplhh3gsw1+uUR43KGcVMJVvkgm3zUrOv
         4E7txLTPmo5UO5C0eo07oTvbSxeYfc+HVudv+k+yKzLeVU0KzXpny2NxMTjmhuRHZdMG
         W7n/XaXfcKcdaNmnb5xi+nGeG8b5l9a5CGVEFdpTMTe0/yx6Nfg6dNsM2IcQAN5ahLM5
         FONg==
X-Gm-Message-State: APjAAAUtHusYk2mh0ssSEEAuX6G9DK6M0ZAGJwPkcxaBa8HslKVHjoLb
        1AbY8TY5t0nDX0YWWNQHgWDC9E9YYyo=
X-Google-Smtp-Source: APXvYqw6h0QF/9Cp8h4AVqAPs4yZPsk7HvUFQPF0LVIItR+ycMCqidhPckPzdmSWxM7kIZu0fL5qKg==
X-Received: by 2002:adf:e708:: with SMTP id c8mr13068496wrm.25.1567097491287;
        Thu, 29 Aug 2019 09:51:31 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id o14sm8340770wrg.64.2019.08.29.09.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 09:51:30 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org
Subject: [PATCH v3 07/11] xfs: remove unlikely() from WARN_ON() condition
Date:   Thu, 29 Aug 2019 19:50:21 +0300
Message-Id: <20190829165025.15750-7-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190829165025.15750-1-efremov@linux.com>
References: <20190829165025.15750-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"unlikely(WARN_ON(x))" is excessive. WARN_ON() already uses unlikely()
internally.

Signed-off-by: Denis Efremov <efremov@linux.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org
---
 fs/xfs/xfs_buf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ca0849043f54..4389d87ff0f0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2096,7 +2096,7 @@ xfs_verify_magic(
 	int			idx;
 
 	idx = xfs_sb_version_hascrc(&mp->m_sb);
-	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic[idx])))
+	if (WARN_ON(!bp->b_ops || !bp->b_ops->magic[idx]))
 		return false;
 	return dmagic == bp->b_ops->magic[idx];
 }
@@ -2114,7 +2114,7 @@ xfs_verify_magic16(
 	int			idx;
 
 	idx = xfs_sb_version_hascrc(&mp->m_sb);
-	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic16[idx])))
+	if (WARN_ON(!bp->b_ops || !bp->b_ops->magic16[idx]))
 		return false;
 	return dmagic == bp->b_ops->magic16[idx];
 }
-- 
2.21.0

