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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268EAC43332
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2141229C9
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbhAJQLN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbhAJQLN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:11:13 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BCBC0617BA
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:12 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n3so7224915pjm.1
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9RFX+Qd9FVdvqPrdV46k1ZuK7hEANDWZXK+xcuNSlAA=;
        b=UQ5fM50cL7GBVm0miqTcUCdZRLCU5b8imoLV2mKe0M7kS+v5B1Y5Og/VrsiPU539kF
         fFQyt/j2GBbPkuOc5205wnHXGwFBaWf8UXvJR3t7tQyebYpEKiwqL/COHN5HC4TO/bIl
         vaetpeLEShZzFlBJrdc9cMZq0kQHORbclN+DJ0TQvKPAIhWfifN7ljkaMWEIjK1vp0/m
         eq2QNFkDOpThGbKLqGwvUhabs69DoajPpr6RShZx4XqYovJR5FSSggLEAl7pQL4S5Cl5
         FauHhsfYiDgBK2RH8I99t1PmK+IwRR5pLtB01GuWeJ6Es9aAbXm/XrCMwVMDkv93v0LX
         vioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9RFX+Qd9FVdvqPrdV46k1ZuK7hEANDWZXK+xcuNSlAA=;
        b=WBxTgvEG1GdXRj6qi8Yz/m0NttwEs/htbxupHwrMaOvAE1DTkSr/yh83iqDOiGbOTh
         ZwXgWkTItzSzPOfPHL24kHKgsssWdOo5m1SL6dmmArvqk/HT7L7eIQjJ6JAQIMYC+u46
         GOHSJbhJgBehXtQj6/V8LBKD1koZsf9ZwmJHWACkhl2Nm6rUugDHW4wVAAlTU0C1/yga
         Z6zHdO9zzeNQf++XPCXcOhsOBehQpDSAObqEk19iiyoTDyWXngEKH7Iz6YvbquvpYLhg
         tC8JL9HY8Y1wWsMeTJ3eHYwX/yeSWsSi28JxjwjSi0IoQcaceYzFUoN1G7G2jWgFyqVE
         EfJA==
X-Gm-Message-State: AOAM531qnRXr68HHDLsa+1KyJLThe5qxiRh4OerGGU3qLOuu7nmTHvnP
        QTbMe3P8o89knq9rfiNLGAt4GKAIWCk=
X-Google-Smtp-Source: ABdhPJw8sLryQQky4XaGPjmTW3ZZAIqL3v/hYjIu2oMoZ05YAQ8GmQ9CKabqiAhVzrOFZKOZ/7YVFw==
X-Received: by 2002:a17:90a:638a:: with SMTP id f10mr13755514pjj.191.1610295011718;
        Sun, 10 Jan 2021 08:10:11 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:10:11 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 15/16] xfs: Process allocated extent in a separate function
Date:   Sun, 10 Jan 2021 21:37:19 +0530
Message-Id: <20210110160720.3922965-16-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
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
index 8955a0a938d5..bf53a0b1eff3 100644
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

