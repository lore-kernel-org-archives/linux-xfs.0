Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFBBC388F2
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FC6D222E8
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lcXF/C1u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgKBJvZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:24 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E20CC0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:24 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w4so99560pgg.13
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nt70IvY/vtgLa/y5uH7G+5m8dg0wvGwo7q/BlwAPtZA=;
        b=lcXF/C1uEaP3CYOkmyk4fwNEqYT5iHcQMCCMw7tFtnohkTOTsWNj9i7QG3f8cQlVR4
         UUCY/6zK7GMpGW0fCNvJDaVCrtY62FLL3/J4zs+sF7xwr4nibEmLV5DTgmJy9zYLRisQ
         4OQu9bVRpl6Ka596wF5hveD40caUrvIqdeYYBMUBMoxHBdTbSuXGUo17a9Eysiu1aBdf
         AhWJwjm+HGKpdEN0JkgAgkbsRQktUQusTKrg9u0Wn3bvbBVwzJsJgx0RfVr56l/aqmga
         Slmd/wntlhz1xUGfH31kEuhKE5CyNgHVHK6bvSrK/X2HsI6oxVseagSQrJh3abkQFSvc
         DQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nt70IvY/vtgLa/y5uH7G+5m8dg0wvGwo7q/BlwAPtZA=;
        b=isvEDt5bbmGM3Bom54414PFVp+h0BXkHFy/4CrI9EbR8aXS0pxtIkCOw8jE6AfCrMA
         snKx3Vmi40cKkXjpIz1WwjYGYmhRIDmsJ0Adwr1VyG7+akbtHZEM5nsVaxHMQL3GeTuh
         ZSEjxIwJlZzUb0IM+9/1zgKHeDjeG0NFAG3vvlyTcRpbu1RY7MhSdsvRT4mPO94Fgh9f
         eEdCMjI/aMQm1Z3Heclik3NsxauaLGb9i1qxlGuR3ZsuGXN+TeCNzmbjwqowPm/5ezD0
         yhYEzHCMSB2YMzlzO1gMX4AG97bXLXAYqw97+wOK9EfVJTUxlK3mrHdttlY/C3MmtjTI
         tnzg==
X-Gm-Message-State: AOAM532T3McWulbxRfXV7m64tb5svtPunZccbTUwVXkr6lChKOQd7wib
        dgiU4ZfQ2j2qUReNUXmPR7Cz9BLoyHM=
X-Google-Smtp-Source: ABdhPJzFOBxs3GR9klF+3FBvjDpNsoSOwOuSpWa1T7buADQSrv1Ym9ZMW0WYsPfb9RpFvquyS2fxZw==
X-Received: by 2002:a65:4305:: with SMTP id j5mr12514915pgq.249.1604310683685;
        Mon, 02 Nov 2020 01:51:23 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:23 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V9 08/14] xfs: Check for extent overflow when remapping an extent
Date:   Mon,  2 Nov 2020 15:20:42 +0530
Message-Id: <20201102095048.100956-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
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

