Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD2EC5519F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B572206A5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGrPH6WL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732494AbgKQNpK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733022AbgKQNpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:45:10 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC70C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:09 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id s2so10237585plr.9
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nt70IvY/vtgLa/y5uH7G+5m8dg0wvGwo7q/BlwAPtZA=;
        b=dGrPH6WLDmIGJRgWhbPVHsaYbZXjZO43nMs8sfffQ4rSZsV3Jh+dqkMIOnYR80LYmz
         A8H14y90Sr1alGAurQCbXvL1RaSLBI5rNpywSTyt3GY5GzYQpqs2aLUxaseNK+yQYQDU
         qoXXJ7WvfGk1XCiIvSWdtngefNzWsw3Kl8wkcM/Kyhy8yfPYbEDkKwHQo+s5UVZueSRg
         qSGCH+jKHXGOGuu++HcFK8k1AXNP/jCHWEX3v89LPTdK50hOvpUY7ZB3RqvAXR51rNuX
         2Mg6KW2rqYalhN+4+vYmNWcXS+5+6t5/+YdVYQMbTHLRNe/q21+VWvNc7NsnfFDXaHyj
         CB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nt70IvY/vtgLa/y5uH7G+5m8dg0wvGwo7q/BlwAPtZA=;
        b=Nv9sV3jyKDiBnK3s7RjCDZ6HBaxiNDTz1732Wjbu8/iAO4q65UkW6umBjjtjL8Hxdr
         Y7EFTLvpqbM7xDqhV8bpsxJaBKIPMslSDwH05LDSva/q0m9KU7q/3Wbvl7d/rSGXiUTm
         bM541ooDTMOSdlenRR0ZP391c9YLnqxUe/7eZiN84Q2aeEN55euxX+vl9+w8wtPczv5+
         Hh4O1vW4MnsdXAZWWfFIh1uBrtEvGvwTcLGAbps4PbgsEl85nWsadzTlikV1fqSk+AdM
         mhqN7/ozuGwaIACTsbC6RkjkyZ1CVNxFuYn8cSVi/7Ed9wejMjWakIX0IvoKBLjK8PIN
         QNRw==
X-Gm-Message-State: AOAM532KXR4auU2fBvgSdDBu66a2ln0ST1bRZmSMmawtp3YS6b/Ozarc
        RAuXv/aS2rxxbL3clwMsZrZmkfYYBa4=
X-Google-Smtp-Source: ABdhPJyM3tmoaDPzBstRvPYSAjXsheL3Y6d96H1qI3q3JU58O9SCWN1HMxCWuFBNJnhhL0ePk1CLHw==
X-Received: by 2002:a17:902:9a4c:b029:d6:1f21:8021 with SMTP id x12-20020a1709029a4cb02900d61f218021mr17326871plv.58.1605620709200;
        Tue, 17 Nov 2020 05:45:09 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:45:08 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH V11 08/14] xfs: Check for extent overflow when remapping an extent
Date:   Tue, 17 Nov 2020 19:14:10 +0530
Message-Id: <20201117134416.207945-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
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

