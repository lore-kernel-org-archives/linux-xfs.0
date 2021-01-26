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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35B5C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 06:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B026206F7
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 06:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732316AbhAZGhr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 01:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732174AbhAZGfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:35:46 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD9BC0617A7
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:23 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b8so9236271plh.12
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qL5piTAh1aSsUUaP1sY2S+E5lRi3K6MY3JGZu20fr+0=;
        b=qdHT8QLXTz7VAgb6N6I4mrEnakz5Zk7Wye1w9OwAsRhwqOjGwt5UCfJ6ms3R02ST4T
         vBBCgAm+EMUHesU+OAvd6Pe/S39ckTBKbXNd5wax2FCDLxTiyUDaBkVl/qAsQ3CIVfTY
         vp3oAXM2h+45T91bYsCYhCvehUPPWna33uF1nGhHT9UG0kDXGhm3P+FO7IddQOo/ByoI
         VfVbdeSacj99F+GstWC0fEihaGIngpUYmZvyJDkIpXDMbTV/EeZF1KEfht0xN5AF4wZ4
         wxSmvFxKZLODIreYNoJv8qK/h68wcdd9baB+PZmOTasUC8Y/ANV8NDk1WoZzpGGn0jGh
         3zAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qL5piTAh1aSsUUaP1sY2S+E5lRi3K6MY3JGZu20fr+0=;
        b=QxCOmrlKcSc1nRUtFklrTFLibXoGxrznWO0nDHN6D6QvehEMDrOnFLRSrpHMEyjeW9
         6VZQg1kJOId0lAiootBJQtAUIoPluwdQtYTvsSjpS8QWxMzvMUT5B3Uh0ZkMpW2hQLdf
         XjWQe5gtVBTZgDx9B+96dhu6zC49F5tXxKE2YIloSk72hK1+UTUuW7e0x4e2m0hXR5bI
         EfPoq9cT5xBo0WtCej7klVljq+/D7ts6FgPFtGPhXIfzPXPWs8mGhvNfcoqK9t3CcT1H
         nFxS9Ln13dpikbg4DDDPhB+M2d4+E4FM960xfRx/vNOXHFrtSwb5SxNZBKK9/CFpTD7S
         plXw==
X-Gm-Message-State: AOAM533tcttDkXo3P+4IqZsdgON/yu1+tZVcixp0C5kZPYGzgVHB2EwM
        IyhEXeLb7XREDXD0eW5jq/o2XvdsyyA=
X-Google-Smtp-Source: ABdhPJxqhu3+9gpdaBmHgUfCfAQvNZAYoURv3Ej9GAzFqzMEnPcfc8ihQtmVk+D5hT66j+r2dZysaQ==
X-Received: by 2002:a17:902:348:b029:df:fa69:1ef0 with SMTP id 66-20020a1709020348b02900dffa691ef0mr4395944pld.41.1611642802722;
        Mon, 25 Jan 2021 22:33:22 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:22 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 13/16] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Tue, 26 Jan 2021 12:02:29 +0530
Message-Id: <20210126063232.3648053-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The check for verifying if the allocated extent is from an AG whose
index is greater than or equal to that of tp->t_firstblock is already
done a couple of statements earlier in the same function. Hence this
commit removes the redundant assert statement.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8ebe5f13279c..0b15b1ff4bdd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3699,7 +3699,6 @@ xfs_bmap_btalloc(
 		ap->blkno = args.fsbno;
 		if (ap->tp->t_firstblock == NULLFSBLOCK)
 			ap->tp->t_firstblock = args.fsbno;
-		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
 		/*
 		 * If the extent size hint is active, we tried to round the
-- 
2.29.2

