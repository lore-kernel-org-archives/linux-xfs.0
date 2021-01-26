Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EFFC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 06:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6954206F7
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 06:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbhAZGga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 01:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbhAZGfm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:35:42 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34E7C061793
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:15 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id p15so1440078pjv.3
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZXvtq1IJJ8A9t02QtWduGxtYXovGQz5DbuSLAdCy3M=;
        b=ZWV1jpZRH33G0buvf00NJj6GoV5eYNr4TSJsFXv8sYHZVa2nZZQPbdF55lSwvMLSSO
         OPCQEPzAXrrnnyWFXBZtWsmt6EuayDQm6wcugHgnA0qlP/PeBMtR1dZ9A0AUizRkcC9c
         2f9xof+2PRX4tZk+mcfyqS3AcqxK3+U4E//Qo1JtlbXFA/AAk2oDAmTQy/HEYLM9phhA
         vyfCvOHDCQIA+08pkT3j3Q00ySIOPm3EIpDyRANv/RuVPBWP0/NvDBQYiV30LnBOpq1G
         uD+0NxBZeSKOXJ7Zbws1xMoXiNNrXKHfJddlNVt4kI3rXoEJb+cXT66jC1SiKHJB5UmB
         Npeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZXvtq1IJJ8A9t02QtWduGxtYXovGQz5DbuSLAdCy3M=;
        b=Jy39b0aODZq6NoA0gBRm+NIu8uHHBkHLL8BNoLdqAFzNK+2BvTbVA2BGl1lDN/Vhab
         aRjjCcd1I8FkfrBfdn8eOnr5iiK+Mme9VFEBWzU8/dw4qOmKoVrvoQy0Ii5fkXZwqcaL
         Ibn7CmMDoHHZp3iNFOV78GNkie9RoJZ12hWpF3a3cIwROmIyd9vjEXMOeuRIMVJX31hp
         3DrYKkFww97dhx3hdXxL5e+0pULudY0pokNf8r5X1DxyrhLIRs7llBHABm0ueLAfaVyC
         nDQOvON66hyTcl8pLWpxkon5iuOyMW9xxX8Cy1bAGtXTy9ygU1ttETrnFsxTDOZR3728
         mu+w==
X-Gm-Message-State: AOAM531WrW/Ec9ZAZ+uOSWMr8P7SrFDiaPortkCEsGg+Qn4HeK0SD4NM
        xTfYhSmIHA9OSsMnIAFuphvCjTmqu6c=
X-Google-Smtp-Source: ABdhPJzTez3fuOQehivIR1PXW6vuFXAkYsl8xumUVL8z8U+7Cid1X4ei/8cOOgcnnkUQbVqN2Pofdg==
X-Received: by 2002:a17:90a:7888:: with SMTP id x8mr4560366pjk.69.1611642795400;
        Mon, 25 Jan 2021 22:33:15 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:15 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 10/16] xfs: Check for extent overflow when remapping an extent
Date:   Tue, 26 Jan 2021 12:02:26 +0530
Message-Id: <20210126063232.3648053-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
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
index ca0ac1426d74..e1c98dbf79e4 100644
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
2.29.2

