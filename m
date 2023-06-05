Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E133C7EE37
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 01:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjFEBcY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 21:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjFEBcX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 21:32:23 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB51AA1;
        Sun,  4 Jun 2023 18:32:21 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-3f6c0d651adso47769781cf.2;
        Sun, 04 Jun 2023 18:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685928740; x=1688520740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xLqGuzdsqiQuDLfBM9llr1W2m1fUQAqO6zoxsqQVjPk=;
        b=Q4H/X4xlT6SHFDj3Wuj5VJQwWP9wKb6cXdz6OdjgLohmqRtC+5pnJur5Rk2I3XBpFn
         UJpS2KfKsCMT5SI6bInk+oxk9tp0uyHMnC5cYVmk5xwEZ2H1wQ5pBB3Ly5yWzdlYCxIL
         Q5QG1z48DNborHcuFqcWNyBWwpCoM04ea06SuhKi9peRbwLhxeMC6Xw9G/XTtbTVgweZ
         iQRTQCG2dDMnV78rKsz8XsNNlyuBLhnXlH2uoeaij92NkuyNuz3kaHg3iPiyk7mNqtXe
         6cPr2imrrWUGY5q/t5KygUSZuvSKOd4TAgeQABaFGgTNZyqHDWuJubh1eD56uT9GRs/3
         v7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685928740; x=1688520740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xLqGuzdsqiQuDLfBM9llr1W2m1fUQAqO6zoxsqQVjPk=;
        b=cyr7q4mRZ4QllPjUNUnS4lt22x9wUACJTmebXEeHHLJqZ4WWVc1Bj4FuX/+8yxKEW/
         KSOB/dT2X/0PxVX/upG2QQEI0E+kwsy6pe8YNyyT50nbXXTf8Zkv/hsu6HbfJ3pRN9MG
         6LbqlJoCCxTaqC0I5o06D4rNvUIZRNm29ONa000dbwgQV+7GsDVnFxMvePQL5YG6AOoK
         x6VnVgyEkiQN83u9dG6IpHFVbu+pQSw1uGUkTQSzSU3INR8f/U6suYmern+FgL2bo3+9
         5OHSQsMVovfle5xNfCTZdOy5YRJigkTCo4HN0uT8hZTGuf14tH+yFAczShoFRHNLj1vG
         a/PA==
X-Gm-Message-State: AC+VfDyz958DnCS51TWD3FqbhSAnQmJNVqQHE201F7KjPuo7F7a2u710
        wxmOVnZz1nUBfJ6mg/YOySWJef47fhE=
X-Google-Smtp-Source: ACHHUZ7DEMjY6VySSmFewLWF+bj3KV25D7is32iTlbnla/Lgcor3Gov+GojsRNq43vbqzP99sxzOjA==
X-Received: by 2002:a05:6214:2347:b0:625:775e:8802 with SMTP id hu7-20020a056214234700b00625775e8802mr6829036qvb.18.1685928740627;
        Sun, 04 Jun 2023 18:32:20 -0700 (PDT)
Received: from dw-tp.ihost.com ([49.207.220.159])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c14d00b001aaec7a2a62sm5209287plj.188.2023.06.04.18.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 18:32:20 -0700 (PDT)
From:   "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCHv6 4/5] iomap: Allocate iop in ->write_begin() early
Date:   Mon,  5 Jun 2023 07:01:51 +0530
Message-Id: <c7fafb34b369c1978678f397a4645112e84a946b.1685900733.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685900733.git.ritesh.list@gmail.com>
References: <cover.1685900733.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We dont need to allocate an iop in ->write_begin() for writes where the
position and length completely overlap with the given folio.
Therefore, such cases are skipped.

Currently when the folio is uptodate, we only allocate iop at writeback
time (in iomap_writepage_map()). This is ok until now, but when we are
going to add support for per-block dirty state bitmap in iop, this
could cause some performance degradation. The reason is that if we don't
allocate iop during ->write_begin(), then we will never mark the
necessary dirty bits in ->write_end() call. And we will have to mark all
the bits as dirty at the writeback time, that could cause the same write
amplification and performance problems as it is now.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 fs/iomap/buffered-io.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e264ff0fa36e..a70242cb32b1 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -574,15 +574,24 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 	size_t from = offset_in_folio(folio, pos), to = from + len;
 	size_t poff, plen;
 
-	if (folio_test_uptodate(folio))
+	/*
+	 * If the write completely overlaps the current folio, then
+	 * entire folio will be dirtied so there is no need for
+	 * per-block state tracking structures to be attached to this folio.
+	 */
+	if (pos <= folio_pos(folio) &&
+	    pos + len >= folio_pos(folio) + folio_size(folio))
 		return 0;
-	folio_clear_error(folio);
 
 	iop = iomap_iop_alloc(iter->inode, folio, iter->flags);
 
 	if ((iter->flags & IOMAP_NOWAIT) && !iop && nr_blocks > 1)
 		return -EAGAIN;
 
+	if (folio_test_uptodate(folio))
+		return 0;
+	folio_clear_error(folio);
+
 	do {
 		iomap_adjust_read_range(iter->inode, folio, &block_start,
 				block_end - block_start, &poff, &plen);
-- 
2.40.1

