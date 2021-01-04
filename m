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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421D6C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AC2922473
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbhADKdL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbhADKdK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 05:33:10 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752C7C0617A5
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 02:32:12 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id q22so16205020pfk.12
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 02:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BEaJiLz4xuB6I2RHadz+mobqnNAUuDqF4rPwKTO9qO8=;
        b=EJ4T+wzzBXahqdl8i33TOFqc5s4ZrOF8OmnywRcnwz+SnX8pF5CJsJlivw/LojedWo
         RS2HT31c+v8q9iHJbxgDsB7awa3LB+0KZoSUKLicgAfrYTokSCrPXZxTcDS8QKj8pjK9
         kGY1ZId+mFMjmpnD2nHkKqGb/flxYHTmfmUaUEfDV7uOfj90t+ZPYiF9WVU5+liWmRkT
         DhCXqJg9D8MKb+hV/gCP92Y8AoYUJWrEVVTkTF5g/o7pLJ6TeAIsDOFTDqUL6nv4ufHp
         etqGUVI+VdRVMmnb1/DAW6Deuig/A160fh0Ip8+sjmeLY5eCufwEnWVG+a7xWNrwHUTI
         AfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BEaJiLz4xuB6I2RHadz+mobqnNAUuDqF4rPwKTO9qO8=;
        b=agdH0FbZ5JxXUGVCt2ATWMRb/BEdCjBCp/tJpdG7JX4tMywnkI7/EeG7rMUMGdD/jS
         rWWWUU6sJjpYAPIbYiPVs979GT9FbK5+zhiiBDBtFAZeIKpaHXy+AxuvDeZ8K/4ruoEX
         8pAz6zxndpTmt9EFuNnHeC15FFRJt97VV/hHYrMtd4ljzBvj3sasgVn6nYxsZWKpPlXn
         r3RFfbxaQ7KvqiWWy6a9dQlFmPMjAVAvw7RrE70d/OTMqVULasKdMpemHX7HCQ0dRe0U
         WCt0r6bQQZqUj8gfPLEeMfLllksy2b8d+4/9KEzyDlCCadBcEganUQiVOJHAqDH0bg1g
         xSAQ==
X-Gm-Message-State: AOAM530Ut3vUdGh86578ZO76ErZovBaTWdKZ6/G0XFClWxKuyyjv9vTz
        jFQIarwyO+03iZUEFUD9RlPXSvlp+CXTvw==
X-Google-Smtp-Source: ABdhPJwrxaT9FcgsvFLsmR+MyIdIYzuYJrPsrD++BKSSBIpwlb3CqPHhsNOmjg3sxysg/GyULqs3ow==
X-Received: by 2002:a62:78ca:0:b029:19d:ce86:fc22 with SMTP id t193-20020a6278ca0000b029019dce86fc22mr65031848pfc.39.1609756331825;
        Mon, 04 Jan 2021 02:32:11 -0800 (PST)
Received: from localhost.localdomain ([122.167.42.132])
        by smtp.gmail.com with ESMTPSA id q6sm51265782pfu.23.2021.01.04.02.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:32:11 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V12 13/14] xfs: Process allocated extent in a separate function
Date:   Mon,  4 Jan 2021 16:01:19 +0530
Message-Id: <20210104103120.41158-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104103120.41158-1-chandanrlinux@gmail.com>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves over the code in xfs_bmap_btalloc() which is
responsible for processing an allocated extent to a new function. Apart
from xfs_bmap_btalloc(), the new function will be invoked by another
function introduced in a future commit.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 74 ++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3479cb1b8178..a2ff4818b8df 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3510,6 +3510,48 @@ xfs_bmap_compute_alignments(
 	return stripe_align;
 }
 
+static void
+xfs_bmap_process_allocated_extent(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_fileoff_t		orig_offset,
+	xfs_extlen_t		orig_length)
+{
+	int			nullfb;
+
+	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
+
+	/*
+	 * check the allocation happened at the same or higher AG than
+	 * the first block that was allocated.
+	 */
+	ASSERT(nullfb ||
+		XFS_FSB_TO_AGNO(args->mp, ap->tp->t_firstblock) <=
+		XFS_FSB_TO_AGNO(args->mp, args->fsbno));
+
+	ap->blkno = args->fsbno;
+	if (nullfb)
+		ap->tp->t_firstblock = args->fsbno;
+	ap->length = args->len;
+	/*
+	 * If the extent size hint is active, we tried to round the
+	 * caller's allocation request offset down to extsz and the
+	 * length up to another extsz boundary.  If we found a free
+	 * extent we mapped it in starting at this new offset.  If the
+	 * newly mapped space isn't long enough to cover any of the
+	 * range of offsets that was originally requested, move the
+	 * mapping up so that we can fill as much of the caller's
+	 * original request as possible.  Free space is apparently
+	 * very fragmented so we're unlikely to be able to satisfy the
+	 * hints anyway.
+	 */
+	if (ap->length <= orig_length)
+		ap->offset = orig_offset;
+	else if (ap->offset + ap->length < orig_offset + orig_length)
+		ap->offset = orig_offset + orig_length - ap->length;
+	xfs_bmap_btalloc_accounting(ap, args);
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -3702,36 +3744,10 @@ xfs_bmap_btalloc(
 			return error;
 		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
 	}
+
 	if (args.fsbno != NULLFSBLOCK) {
-		/*
-		 * check the allocation happened at the same or higher AG than
-		 * the first block that was allocated.
-		 */
-		ASSERT(ap->tp->t_firstblock == NULLFSBLOCK ||
-		       XFS_FSB_TO_AGNO(mp, ap->tp->t_firstblock) <=
-		       XFS_FSB_TO_AGNO(mp, args.fsbno));
-
-		ap->blkno = args.fsbno;
-		if (ap->tp->t_firstblock == NULLFSBLOCK)
-			ap->tp->t_firstblock = args.fsbno;
-		ap->length = args.len;
-		/*
-		 * If the extent size hint is active, we tried to round the
-		 * caller's allocation request offset down to extsz and the
-		 * length up to another extsz boundary.  If we found a free
-		 * extent we mapped it in starting at this new offset.  If the
-		 * newly mapped space isn't long enough to cover any of the
-		 * range of offsets that was originally requested, move the
-		 * mapping up so that we can fill as much of the caller's
-		 * original request as possible.  Free space is apparently
-		 * very fragmented so we're unlikely to be able to satisfy the
-		 * hints anyway.
-		 */
-		if (ap->length <= orig_length)
-			ap->offset = orig_offset;
-		else if (ap->offset + ap->length < orig_offset + orig_length)
-			ap->offset = orig_offset + orig_length - ap->length;
-		xfs_bmap_btalloc_accounting(ap, &args);
+		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
+			orig_length);
 	} else {
 		ap->blkno = NULLFSBLOCK;
 		ap->length = 0;
-- 
2.29.2

