Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60F8C43457
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9549822260
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jp0Lyyf6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgJSGlf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:35 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EB9C061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:35 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id p21so4798540pju.0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nem5Zsp3TqF1iyC0/EMN7RtDNtSJXMIPs5v8QAhDvpg=;
        b=jp0Lyyf6MdtAiOyo8DeO4rnoPOMwvYRDjQPWe5+2mEGTqwrtBRDbRXOF1eeiWEp+D7
         yi4N557l3D1D+Uvk0H1paou7Rc7TAnY8nja2yoVUabu9rfICFIDWByACcZC0LRmZysE0
         Ma8QlyvQdlRnZB+EV4zjhCWTvIhV4/ryDt65rMydfSyszr+NO5Hlw9fRx7UmeCTjaOL7
         l9NsX3OmHfZO/aYmMfDUDjWVroNtwswyWBWuD3JDoum4Td/5jge/v/A9vRk8f/cYBDZN
         bqnvTGUo16VWwcEVVkxJ4Wsn7qvJKn3JTh4e/f3oIQCxqux2isTahzW9EiEhQMBhk4g/
         l4Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nem5Zsp3TqF1iyC0/EMN7RtDNtSJXMIPs5v8QAhDvpg=;
        b=eZTm0FZhioq8eQThb5ksHZhXvA0ENP5No1ydI9k3Z7fEPS63/zNrPluJDHQMC5aiJx
         XJbtMtAoyH0VhEMphldzM6Xi2IKazp7/YU3fcdf6X334znUzgb0vDk33vB6yqu/UPsW2
         P5KM1iWBhd5FOv53GVIPqZB39lCJBkrFpXABkyIEDgVUs2KE2jj5XvECRVgUD9f0/fiG
         ebsPzujEe8I8jZF52tAXTk4Ofcki8eNaqP/ufKPSFdPKvhQYE+79IuvSFnsY3mewaa7q
         Huuzp7pSkEVmD6iiBany+DaTvzu3KbpOGNKk/s1iqz9AaUq6rFTDwxA2Rb+ede+VQZy2
         LXdg==
X-Gm-Message-State: AOAM530Pr7wU0x7LW9rJKoz5PlC+eba13F50olL9/DoQ1/goZDzrBNf7
        MECu59P8kYXS0CB/b7wdbDizNnTdsVA=
X-Google-Smtp-Source: ABdhPJyrq5v+vwzrndgy65SOoUEYECr2bvHWwrcN1aGJ1zEpv9TbLCKAy7hifAPgCqP2Qoggmsqpeg==
X-Received: by 2002:a17:90a:f698:: with SMTP id cl24mr15733723pjb.59.1603089694370;
        Sun, 18 Oct 2020 23:41:34 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:33 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V7 08/14] xfs: Check for extent overflow when remapping an extent
Date:   Mon, 19 Oct 2020 12:10:42 +0530
Message-Id: <20201019064048.6591-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
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

