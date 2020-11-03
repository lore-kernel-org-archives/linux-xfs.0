Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288C7C56202
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1472223FD
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVs8M7Ay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgKCPHj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbgKCPHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:07:18 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3CDC0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 07:07:18 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id u4so2077765pgr.9
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nt70IvY/vtgLa/y5uH7G+5m8dg0wvGwo7q/BlwAPtZA=;
        b=mVs8M7Aya9EazheQN0WIhwHnOgIdiyMxurbRT6QQ32qA8RPrUDWuNuLh/MUFTXLj12
         G66xN5sVLLSRe5OHKyW73O1qRHrcKWT7zS4lHVy9q+/3XiGcPpdjn1ZkUS9mOExWWR8r
         w2nhEIIwudjBj4OxTXLZsr6ti+5qsT6xLiedBxZld28lPYW7Q37LiXMaWAcNpc6NgreC
         oeosIL/PwQH1KLJwQrIqwcSU3tjjzkcKJT/tHCX+Kn2JeVS0422cC2jXMxn6EpzbRIET
         SaJWSnY4mWZPAwdT8OJHK6yaWCnpGWH8nAJCV4QiUnzShYXqXeJt4Ck94YKnHGVU5JCY
         sqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nt70IvY/vtgLa/y5uH7G+5m8dg0wvGwo7q/BlwAPtZA=;
        b=ZIsaAgm2xVSlVnOsn+4yDKBtLFWa5KZSf+wXpVnSz+ZFP6EjeIXZWIxXQoqbWytqwm
         3Jwu/UPwRfvjVFkFN2cWQuv3HymYXucL4B82tznHRmQLBojzNi5mRzilzu/lzXIYbhkC
         YqaGU4fDu8egPR3TXWkValjREHzqchi6vwe7/xxLJ5aabbIKAGK4XytXW3e0s0LlCPDC
         PbGKNC4YC0MLUatbHrpac9nJ0DVMAiHfq6pnXBZ5QJyXrKDFS7KzF1/PCJyh8E7ylKWv
         b/rXOXB6UznAUpmB9qGfbotR9l8rtRlhpNXCcjV/qzI5Iz6Ie8kXE20SpxFlnskHrfn6
         g5SA==
X-Gm-Message-State: AOAM532Co7rFpZ5I7B5YkGgNfv750U2wj0su6pAFrlgkzUQjqEMvaZcT
        LTk3pG8jsT/fsHcyRm4HSCwM78WSvOxfdw==
X-Google-Smtp-Source: ABdhPJz6IxvpDF+TMVqkrnMBwwzWIhjfVk7QiuVL0FnyoOKo2oxCNcyz93Yo4t0D3ABh+ZWjajGcyQ==
X-Received: by 2002:a63:d54e:: with SMTP id v14mr17885607pgi.203.1604416038112;
        Tue, 03 Nov 2020 07:07:18 -0800 (PST)
Received: from localhost.localdomain ([122.179.48.228])
        by smtp.gmail.com with ESMTPSA id 15sm15936955pgs.52.2020.11.03.07.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:07:17 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V10 08/14] xfs: Check for extent overflow when remapping an extent
Date:   Tue,  3 Nov 2020 20:36:36 +0530
Message-Id: <20201103150642.2032284-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103150642.2032284-1-chandanrlinux@gmail.com>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remapping an extent involves unmapping the existing extent and mapping
in the new extent. When unmapping, an extent containing the entire unmap
range can be split into two extents,
i.e. | Old extent | hole | Old extent |
Hence extent count increases by 1.

Mapping in the new extent into the destination file can increase the
extent count by 1.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_reflink.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4f0198f636ad..856fe755a5e9 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1006,6 +1006,7 @@ xfs_reflink_remap_extent(
 	unsigned int		resblks;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
+	int			iext_delta = 0;
 	int			nimaps;
 	int			error;
 
@@ -1099,6 +1100,16 @@ xfs_reflink_remap_extent(
 			goto out_cancel;
 	}
 
+	if (smap_real)
+		++iext_delta;
+
+	if (dmap_written)
+		++iext_delta;
+
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
+	if (error)
+		goto out_cancel;
+
 	if (smap_real) {
 		/*
 		 * If the extent we're unmapping is backed by storage (written
-- 
2.28.0

