Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B6BC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 13:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE8CB61424
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 13:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhD3NlZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 09:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhD3NlY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Apr 2021 09:41:24 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893E0C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 06:40:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id e2so32292965plh.8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Apr 2021 06:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=3FH7lEVD06McUBArikSJLPssowre9O6P8fh2YlrsEdU=;
        b=ex19A3GnYVc4BVlaZbeo9ZF+UKbyJYUm9WjFuCpXGHJUCborkbQ4c1yhtAEcHJrHLW
         O7IuBKWtcxH5C7mL5zWumMVGz3gjhO/VprTgOPQ3rdFCV++YO4UpmusZmnF5pxxDbNdn
         LFtAZ20Aob8ILklaxmsF5x+HdyoLmpUyo+96HKvBEknmNq8IsGbYwEAQ8b2r5QcUbXIx
         kB4eYcYyOG2M/Pc5DlBL38/IO7mmDeCHVUm7AzXiG6Tkicm+CpOvSVN23t5aG9Bw4Mob
         7mnPuh6JEfhK34kHwMs+Mnb0y43yA01DZU7NzEGYWAqJ+4Kbs19cJFtlyCYP1F2p4wwO
         o2Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=3FH7lEVD06McUBArikSJLPssowre9O6P8fh2YlrsEdU=;
        b=Kz9TTCe1r+zyAewbHXNsuDT0Jp+NciiOqs3ynB/YIeZb1KOXwKm1j2Hscpm3LaCSEj
         KV4uD9zg09Jrmz/ie7pIrUth4jLn321TNHEEe7wWnEm1ruGCnvG0XFvwTtuk33uoF1dH
         N9LHkrW2wbmWbfBTwfCjbIih13z6adLR3wRCYu8eKYfOP3XHUD8YvHaPHl4ZCPH3AF98
         tB+fbO1tB4ozIpWAU9zRFhRiyIMl42y3LG0rZA+bU9wuEpD+Lo/Xb7Vra3FS4NN9opme
         lXNmtsTXPPXsC5LIW7CdQJ9AK9732RgtAMCqYhkowMcmuDA+/vEvNLQdVhWcZAAW0krs
         arQw==
X-Gm-Message-State: AOAM530yJualr8KnqDIGnWBTAYIaEgrdm7nO3Qe8w+9ChR8ioHP/Ap6F
        mu0lrp8b+sGAujUA9xkf3cidjLhAnHw=
X-Google-Smtp-Source: ABdhPJxFAQK6VXsMpbbnaXEjKpPvdY6G4I0u1ixGB8kdFU1WdZW30+msfm6XpELM2qSHjslOvLrmzA==
X-Received: by 2002:a17:90a:de17:: with SMTP id m23mr5640972pjv.16.1619790034626;
        Fri, 30 Apr 2021 06:40:34 -0700 (PDT)
Received: from garuda ([122.179.54.95])
        by smtp.gmail.com with ESMTPSA id y29sm2351579pfq.29.2021.04.30.06.40.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Apr 2021 06:40:34 -0700 (PDT)
References: <20210428065152.77280-1-chandanrlinux@gmail.com> <20210428065152.77280-2-chandanrlinux@gmail.com> <20210429011231.GF63242@dread.disaster.area>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
In-reply-to: <20210429011231.GF63242@dread.disaster.area>
Date:   Fri, 30 Apr 2021 19:10:31 +0530
Message-ID: <875z0399gw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29 Apr 2021 at 06:42, Dave Chinner wrote:
> On Wed, Apr 28, 2021 at 12:21:52PM +0530, Chandan Babu R wrote:
>> Executing xfs/538 after disabling injection of bmap_alloc_minlen_extent error
>> can cause several tasks to trigger hung task timeout. Most of the tasks are
>> blocked on getting a lock on an AG's AGF buffer. However, The task which has
>> the lock on the AG's AGF buffer has the following call trace,
>>
[..]
> Hmmm. I don't doubt that this fixes the symptom you are seeing, but
> the way it is being fixed doesn't seem right to me at all.
>
> We're rtying to populate the AGFL here, and the fact is that a
> multi-block allocation is simply an optimisation to minimise the
> number of extents we need to allocate to fill the AGFL. The extent
> that gets allocated gets broken up into single blocks to be inserted
> into the AGFL, so we don't actually need a continuguous extent to be
> allocated here.
>
> Hence, if the extent we find is busy when allocating for the AGFL,
> we should just skip it and choose another extent. args->minlen is
> set to zero for the allocation, so we can actually return any extent
> that has a length <= args->maxlen. We know this is an AGFL
> allocation because args->resv == XFS_AG_RESV_AGFL, so if we find a
> busy extent that would require a log force to be able to use before
> we can place it in the AGFL, we should just skip it entirely and
> select another extent to allocate from.
>
> Adding another two boolean conditionals to the already complex
> extent selection for this specific case makes the code much harder
> to follow and reason about. I'd much prefer that we just do
> something like:
>
> 	if (busy && args->resv == XFS_AG_RESV_AGFL) {
> 		/*
> 		 * Extent might have just been freed in this
> 		 * transaction so we can't use it. Move to the next
> 		 * best extent candidate and try that instead.
> 		 */
> 		<increment/decrement and continue the search loop>
> 	}
>
> IOWs, we should not be issuing a log force to flush busy extents if
> we can't use the largest candidate free extent for the AGFL - we
> should just keep searching until we find one we can use....

IIUC, the following patch implements the solution that has been suggested
above,

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aaa19101bb2a..25456dbff767 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1694,6 +1694,7 @@ xfs_alloc_ag_vextent_size(
 	 * are no smaller extents available.
 	 */
 	if (!i) {
+alloc_small_extent:
 		error = xfs_alloc_ag_vextent_small(args, cnt_cur,
 						   &fbno, &flen, &i);
 		if (error)
@@ -1707,6 +1708,8 @@ xfs_alloc_ag_vextent_size(
 		busy = xfs_alloc_compute_aligned(args, fbno, flen, &rbno,
 				&rlen, &busy_gen);
 	} else {
+		xfs_agblock_t	orig_fbno = NULLAGBLOCK;
+		xfs_extlen_t	orig_flen;
 		/*
 		 * Search for a non-busy extent that is large enough.
 		 */
@@ -1719,6 +1722,11 @@ xfs_alloc_ag_vextent_size(
 				goto error0;
 			}

+			if (orig_fbno == NULLAGBLOCK) {
+				orig_fbno = fbno;
+				orig_flen = flen;
+			}
+
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
 					&rbno, &rlen, &busy_gen);

@@ -1734,6 +1742,14 @@ xfs_alloc_ag_vextent_size(
 				 * Make it unbusy by forcing the log out and
 				 * retrying.
 				 */
+				if (args->resv == XFS_AG_RESV_AGFL) {
+					error = xfs_alloc_lookup_eq(cnt_cur,
+							orig_fbno, orig_flen, &i);
+					ASSERT(!error && i);
+
+					goto alloc_small_extent;
+				}
+
 				xfs_btree_del_cursor(cnt_cur,
 						     XFS_BTREE_NOERROR);
 				trace_xfs_alloc_size_busy(args);
@@ -1819,7 +1835,7 @@ xfs_alloc_ag_vextent_size(
 	 */
 	args->len = rlen;
 	if (rlen < args->minlen) {
-		if (busy) {
+		if (busy && args->resv != XFS_AG_RESV_AGFL) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_size_busy(args);
 			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);

i.e.  when we end up at the right most edge of the cntbt during allocation of
blocks for refilling AGFL, the above patch backtracks and continues search
towards the left edge of the cntbt instead of flushing the CIL. If the
leftmost edge is reached without finding any suitable free extent and the
blocks are being allocated for AGFL, the function returns back to the caller
instead of flushing the CIL and retrying once again.

With the above patch, a workload which consists of,
1. Filling up 90% of the free space of the filesystem.
2. Punch alternate blocks of files.

.. would cause failure when inserting records into either cntbt/bnobt due to
unavailability of AGFL blocks.

This happens because most of the free blocks resulting from punching out
alternate blocks would be residing in the CIL's extent busy list. xfs/538
creates 1G sized scratch filesystem and the "punch alternate blocks" workload
creates a little more than 8000 entries in the CIL extent busy list.

So, may be there are no other alternatives other than to flush the CIL. To
that end, I have tried to slightly simplify the patch that I had originally
sent (i.e. [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for
AGFL). The new patch removes one the boolean variables
(i.e. alloc_small_extent) and also skips redundant searching of extent records
when backtracking in preparation for searching smaller extents.

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7dc50a435cf4..ea01c2674247 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -274,7 +274,8 @@ xfs_alloc_compute_aligned(
 	xfs_extlen_t	foundlen,	/* length in found extent */
 	xfs_agblock_t	*resbno,	/* result block number */
 	xfs_extlen_t	*reslen,	/* result length */
-	unsigned	*busy_gen)
+	unsigned	*busy_gen,
+	bool		*busy_in_trans)
 {
 	xfs_agblock_t	bno = foundbno;
 	xfs_extlen_t	len = foundlen;
@@ -282,7 +283,7 @@ xfs_alloc_compute_aligned(
 	bool		busy;

 	/* Trim busy sections out of found extent */
-	busy = xfs_extent_busy_trim(args, &bno, &len, busy_gen);
+	busy = xfs_extent_busy_trim(args, &bno, &len, busy_gen, busy_in_trans);

 	/*
 	 * If we have a largish extent that happens to start before min_agbno,
@@ -852,7 +853,7 @@ xfs_alloc_cur_check(
 	}

 	busy = xfs_alloc_compute_aligned(args, bno, len, &bnoa, &lena,
-					 &busy_gen);
+					 &busy_gen, NULL);
 	acur->busy |= busy;
 	if (busy)
 		acur->busy_gen = busy_gen;
@@ -1248,7 +1249,7 @@ xfs_alloc_ag_vextent_exact(
 	 */
 	tbno = fbno;
 	tlen = flen;
-	xfs_extent_busy_trim(args, &tbno, &tlen, &busy_gen);
+	xfs_extent_busy_trim(args, &tbno, &tlen, &busy_gen, NULL);

 	/*
 	 * Give up if the start of the extent is busy, or the freespace isn't
@@ -1669,6 +1670,8 @@ xfs_alloc_ag_vextent_size(
 	xfs_extlen_t	rlen;		/* length of returned extent */
 	bool		busy;
 	unsigned	busy_gen;
+	bool		busy_in_trans;
+	bool		all_busy_in_trans;

 restart:
 	/*
@@ -1677,6 +1680,7 @@ xfs_alloc_ag_vextent_size(
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_CNT);
 	bno_cur = NULL;
+	all_busy_in_trans = true;
 	busy = false;

 	/*
@@ -1687,13 +1691,15 @@ xfs_alloc_ag_vextent_size(
 		goto error0;

 	/*
-	 * If none then we have to settle for a smaller extent. In the case that
-	 * there are no large extents, this will return the last entry in the
-	 * tree unless the tree is empty. In the case that there are only busy
-	 * large extents, this will return the largest small extent unless there
-	 * are no smaller extents available.
+	 * We have to settle for a smaller extent if there are no maxlen +
+	 * alignment - 1 sized extents or if all larger free extents are still
+	 * in current transaction's busy list. In either case, this will return
+	 * the last entry in the tree unless the tree is empty. In the case that
+	 * there are only busy large extents, this will return the largest small
+	 * extent unless there are no smaller extents available.
 	 */
 	if (!i) {
+alloc_small_extent:
 		error = xfs_alloc_ag_vextent_small(args, cnt_cur,
 						   &fbno, &flen, &i);
 		if (error)
@@ -1705,8 +1711,12 @@ xfs_alloc_ag_vextent_size(
 		}
 		ASSERT(i == 1);
 		busy = xfs_alloc_compute_aligned(args, fbno, flen, &rbno,
-				&rlen, &busy_gen);
+				&rlen, &busy_gen, &busy_in_trans);
+		if (busy && !busy_in_trans)
+			all_busy_in_trans = false;
 	} else {
+		xfs_agblock_t	orig_fbno = NULLAGBLOCK;
+		xfs_extlen_t	orig_flen;
 		/*
 		 * Search for a non-busy extent that is large enough.
 		 */
@@ -1719,27 +1729,52 @@ xfs_alloc_ag_vextent_size(
 				goto error0;
 			}

+			if (orig_fbno == NULLAGBLOCK) {
+				orig_fbno = fbno;
+				orig_flen = flen;
+			}
+
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
-					&rbno, &rlen, &busy_gen);
+					&rbno, &rlen, &busy_gen,
+					&busy_in_trans);

 			if (rlen >= args->maxlen)
 				break;

+			if (busy && !busy_in_trans)
+				all_busy_in_trans = false;
+
 			error = xfs_btree_increment(cnt_cur, 0, &i);
 			if (error)
 				goto error0;
 			if (i == 0) {
+				if (!all_busy_in_trans) {
+					/*
+					 * Our only valid extents must have been busy.
+					 * Make it unbusy by forcing the log out and
+					 * retrying.
+					 */
+					xfs_btree_del_cursor(cnt_cur,
+							XFS_BTREE_NOERROR);
+					trace_xfs_alloc_size_busy(args);
+					xfs_extent_busy_flush(args->mp,
+							args->pag, busy_gen);
+					goto restart;
+				}
+
 				/*
-				 * Our only valid extents must have been busy.
-				 * Make it unbusy by forcing the log out and
-				 * retrying.
+				 * All the large free extents are busy in the
+				 * current transaction's t->t_busy list.  Hence
+				 * forcing the log will will be futile and also
+				 * leads to the current task waiting
+				 * indefinitely. Hence try to allocate smaller
+				 * extents.
 				 */
-				xfs_btree_del_cursor(cnt_cur,
-						     XFS_BTREE_NOERROR);
-				trace_xfs_alloc_size_busy(args);
-				xfs_extent_busy_flush(args->mp,
-							args->pag, busy_gen);
-				goto restart;
+				error = xfs_alloc_lookup_eq(cnt_cur, orig_fbno,
+						orig_flen, &i);
+				ASSERT(!error && i);
+
+				goto alloc_small_extent;
 			}
 		}
 	}
@@ -1783,7 +1818,10 @@ xfs_alloc_ag_vextent_size(
 			if (flen < bestrlen)
 				break;
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
-					&rbno, &rlen, &busy_gen);
+					&rbno, &rlen, &busy_gen,
+					&busy_in_trans);
+			if (busy && !busy_in_trans)
+				all_busy_in_trans = false;
 			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
 			if (XFS_IS_CORRUPT(args->mp,
 					   rlen != 0 &&
@@ -1819,7 +1857,7 @@ xfs_alloc_ag_vextent_size(
 	 */
 	args->len = rlen;
 	if (rlen < args->minlen) {
-		if (busy) {
+		if (busy && !all_busy_in_trans) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_size_busy(args);
 			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index a4075685d9eb..16ba514f9e81 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -334,7 +334,8 @@ xfs_extent_busy_trim(
 	struct xfs_alloc_arg	*args,
 	xfs_agblock_t		*bno,
 	xfs_extlen_t		*len,
-	unsigned		*busy_gen)
+	unsigned		*busy_gen,
+	bool			*busy_in_trans)
 {
 	xfs_agblock_t		fbno;
 	xfs_extlen_t		flen;
@@ -362,6 +363,9 @@ xfs_extent_busy_trim(
 			continue;
 		}

+		if (busy_in_trans)
+			*busy_in_trans = busyp->flags & XFS_EXTENT_BUSY_IN_TRANS;
+
 		if (bbno <= fbno) {
 			/* start overlap */

diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 929f72d1c699..dcdc70821622 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -49,7 +49,7 @@ xfs_extent_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,

 bool
 xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
-		xfs_extlen_t *len, unsigned *busy_gen);
+		xfs_extlen_t *len, unsigned *busy_gen, bool *busy_in_trans);

 void
 xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,

Please let me know your views on this.

--
chandan
