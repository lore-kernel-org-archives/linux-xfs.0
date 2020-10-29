Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1E5C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D134420791
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NlWp9RNB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgJ2KOt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJ2KOt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:14:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B41C0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:49 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 15so1923337pgd.12
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nt70IvY/vtgLa/y5uH7G+5m8dg0wvGwo7q/BlwAPtZA=;
        b=NlWp9RNBCdBvJ4ZXACKUVi2B33IUO5tyY1EDpPtwqh8YhJ+ZNyVNJBw8GpYvgu/Jul
         WKX9Ta6+0KAV49Ipmb1ULTovJknBJvl1yIpGCYSHxBLfkASOo9xU1nYsSbBJK/SGfpMu
         OpEIn7HpsZNazVh/u4VxZkhNpfp+6aWK3CmbAJ6IQi+tzM8QdQ8s+FPiXu8EErA+0U4F
         69MkndXgrnk/AkWf65FiUij6ZfWGJFQXPzXqx0HndG23hQKexOIqK1C3aaw39D2cPblr
         8xEBvq0k9CwwDIM7QdUR/cHhB/TjjCcthU05co9dwWMTH+kNdmbokZ4Zn6mEEh18UReH
         m+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nt70IvY/vtgLa/y5uH7G+5m8dg0wvGwo7q/BlwAPtZA=;
        b=QzGIKw/gVYyk7y2c0dKq45Pu5XdFGN3C8C9b+NF80Z/G20LRU5IAUYO+bEbSg9g+0J
         4aLN4Joyvaw35o999GNf1ripZpVDLXSAm+/8qVJhKVLbAlVu7c5LRa7gxTCR/MwPuiNO
         zge+JJ4ro1jO0i2o4LxvHUohHaUKhiY6BtnoLc5DymEbfJ8qxoKZa/EoJdcu4KRTiNJa
         cwwZh3osksCMq4l8PZH+S9vfIkBRXQuF718YCdKp4lTJaqLhaQhqHLFQy7LvRNEswK3e
         LZg3+gm1ZHp996oPZBFfCrrjXlrpHW5aYvmbakkvW0tKKCKubVjpSSQgP4RPfDVbkJC4
         c2wQ==
X-Gm-Message-State: AOAM5326eu1QuZtZdTRo5tuoyoSJ+oqclxSuMArE49LzrjagrJBzlgxP
        McyKjQuSX8b2OC5psOglnTiC9jjM6/0=
X-Google-Smtp-Source: ABdhPJzy6ifTQVhAK9hCDzRwoqaKVXx/zNglrjP2it6nqclQRyCdM/xBeLfOn8rwNUlZwdmarQ3LnA==
X-Received: by 2002:a62:8c4e:0:b029:164:a1f3:249b with SMTP id m75-20020a628c4e0000b0290164a1f3249bmr3606157pfd.33.1603966488462;
        Thu, 29 Oct 2020 03:14:48 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:14:47 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V8 08/14] xfs: Check for extent overflow when remapping an extent
Date:   Thu, 29 Oct 2020 15:43:42 +0530
Message-Id: <20201029101348.4442-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029101348.4442-1-chandanrlinux@gmail.com>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
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

