Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C2218C329
	for <linux-xfs@vger.kernel.org>; Wed,  5 Jun 2024 06:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569632; cv=none; b=VgU+RjnESZNbUN/NXwVQfKIhXB8Xlm8svzjuqvWokapV3TfO+0XtbRXoM0IT6hxQO3YTvoEs8yv6E3iPRwk/FxzbC8X3IaLCuxkCIn8gvQLIz0sodw49j/djvHzFZmy2BgdhmECBvyfwFm97KjTj/pMF94XI6P9oLZmbwwr7MIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569632; c=relaxed/simple;
	bh=Fes/cWu25+X+bq7zHbC+O7FkQ30ouGgdHUXVmDYOoZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DD/BPDYggoPpQWycLX+lRMmFyR3zAofNBYZhRcjx24Td1KotVLSIlC1IASKeTGFubTnYFZb15aCana9KsJvrduFdbagAh/A0kvF6g1s7Vq3rLvu/n5HCqFAuSu8Ni4VtsT1V17jkUoP/FJpBiVQHXgVToFaQaBOtFp1tG7ji/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=UM2rE+5i; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="UM2rE+5i"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5b9f9e7176eso3178064eaf.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2024 23:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717569629; x=1718174429; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xRZ3cFfRg0nIGrJe7+4rFgfsTFSF+RLG7KELsYpO1Y0=;
        b=UM2rE+5iB2YM9ymmxNuwB2Igv2sww+kK4kuoBq/8x3yUDv8OE/0p9kwEwNrJ2GuTb3
         5yIcFMZZto1HH75hg011U35wjTRNzFni/kOULUtOvQSLjMeEPzmn/x2528xoY6viiR6F
         Tl9EcKTpY5bap5VArd4yHR7qEhEpUXl5e/wWU7X2axJecpW6PlcEYJMbqAXlBF3tbLsX
         Wg6eFnmUolwufkIhmJU0A+bq2cHKEUwcwMakzHeP/n+96Ce6TGTOZ609QU9rYihjSGnD
         6JoE4/jPkXUCzI4raiAaD8qvlhWa7/GkNx0T7bpFrLMTL1d/MyQLeDQUZe/eH841RHYw
         aWfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717569629; x=1718174429;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xRZ3cFfRg0nIGrJe7+4rFgfsTFSF+RLG7KELsYpO1Y0=;
        b=hFBjRJGfYMZ3CfTbPkrp3Xhvsm4g36mSUBLIkqBqp12xbi2tIpIf+m9LBPUl/H0ZAZ
         EyyZJU3uhEgfXdPSnwd4nVG0LTXE6G/YYw2AZ+egt+qs1cQJHPSPa3bAxQiwwTpd2PVO
         VVvrfGiU8yc0MEk7cLopjLuXE6hGuxp55MEUAvO7T4DFpWZFjOp2D5aWJWFqb2bK5NdB
         guzdXEkP/eRxefc3deH0ExToMOsTFxLR6SjWp9Tp1uJgML8Dh+yvKD3tp0PPbs1dX/iV
         ZjBKJbNtbnqXTW0VzRWggdsYZVv8re9Rkouo20MMrzY7XIzkPba6WxXCqRuEOMecVS76
         5YUw==
X-Forwarded-Encrypted: i=1; AJvYcCWHrX1d/dBLYUTZvAnB86X5T2CXMQSAglrHbOwAmkDOhA20xfeU0y7x1P39Vy+9zyOGrLfGJZv5+5YRTsAqJUloGcxv+6pocci1
X-Gm-Message-State: AOJu0YwbGLGVbz9j78R6bdigUmStAkDK3ztGHm3eOSw6dJu3gY2utcuc
	TGG7mm9u0YnHirz2eFJe3fC6Ln1ijqiYUdcgJElHeQ0s5wkbE6q29UQxxdvRC4VsGzQ7egAa1VD
	C
X-Google-Smtp-Source: AGHT+IGJEOCrhAX8k8AHnSIynN1ddiBeJCtwSK6BTLoghCx4/d/MCAZKJ6Wf1nwzgDBjCjYl8jMHFA==
X-Received: by 2002:a05:6358:d25:b0:199:53ec:148c with SMTP id e5c5f4694b2df-19c6c9f3fadmr195553055d.20.1717569628699;
        Tue, 04 Jun 2024 23:40:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6c35a88c6ffsm7851601a12.90.2024.06.04.23.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 23:40:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sEkJs-004u3v-1Q;
	Wed, 05 Jun 2024 16:40:24 +1000
Date: Wed, 5 Jun 2024 16:40:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	yangerkun@huawei.com
Subject: Re: [PATCH] xfs: Fix file creation failure
Message-ID: <ZmAIWOZmUKBNI8ZZ@dread.disaster.area>
References: <20240604071121.3981686-1-wozizhi@huawei.com>
 <Zl+cjKxrncOKbas7@dread.disaster.area>
 <ba3cb00b-1d05-4ac9-b14e-e73e65cc4017@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba3cb00b-1d05-4ac9-b14e-e73e65cc4017@huawei.com>

On Wed, Jun 05, 2024 at 10:51:31AM +0800, Zizhi Wo wrote:
> 在 2024/6/5 7:00, Dave Chinner 写道:
> > On Tue, Jun 04, 2024 at 03:11:21PM +0800, Zizhi Wo wrote:
> > > We have an xfs image that contains only 2 AGs, the first AG is full and
> > > the second AG is empty, then a concurrent file creation and little writing
> > > could unexpectedly return -ENOSPC error since there is a race window that
> > > the allocator could get the wrong agf->agf_longest.
.....
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index 6c55a6e88eba..86ba873d57a8 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -577,6 +577,13 @@ xfs_alloc_fixup_trees(
> > >   		nfbno2 = rbno + rlen;
> > >   		nflen2 = (fbno + flen) - nfbno2;
> > >   	}
> > > +
> > > +	/*
> > > +	 * Record the potential maximum free length in advance.
> > > +	 */
> > > +	if (nfbno1 != NULLAGBLOCK || nfbno2 != NULLAGBLOCK)
> > > +		cnt_cur->bc_ag.bc_free_longest = XFS_EXTLEN_MAX(nflen1, nflen2);
> > > +
> > 
> > Why do we store the length of a random extent being freed here?
> > nflen1/2 almost always have nothing to do with the longest free
> > space extent in the tree, they are just the new free space extents
> > we are insering into a random location in the free space tree.
> > 
> 
> First of all, there may be ambiguity in the name of the bc_free_longest
> field. I'm sorry for that. Its only role is to give the longest non-0 in
> a particular scenario.
> 
> Yes, nflen1/2 can't determine the subsequent operation, but they are
> used to update the longest record only if the numrec in cntbt is zero,
> the last has been deleted and a new record will be added soon (that is,
> there is still space left on the file system), and that is their only
> function. So at this time nflen1/2 are not random extent, they indicate
> the maximum value to be inserted later. If cntbt does not need to be
> updated longest or the numrec is not zero, then bc_free_longest will not
> be used to update the longest.

That's the comment you should have put in the code.

Comments need to explain -why- the code exists, not tell us -what-
the code does. We know the latter from reading the code, we cannot
know the former from reading the code...

> > >   	/*
> > >   	 * Delete the entry from the by-size btree.
> > >   	 */
> > > @@ -2044,6 +2051,13 @@ xfs_free_ag_extent(
> > >   	 * Now allocate and initialize a cursor for the by-size tree.
> > >   	 */
> > >   	cnt_cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> > > +	/*
> > > +	 * Record the potential maximum free length in advance.
> > > +	 */
> > > +	if (haveleft)
> > > +		cnt_cur->bc_ag.bc_free_longest = ltlen;
> > > +	if (haveright)
> > > +		cnt_cur->bc_ag.bc_free_longest = gtlen;
> > 
> > That doesn't look correct. At this point in the code, ltlen/gtlen
> > are the sizes of the physically adjacent freespace extents that we
> > are going to merge the newly freed extent with. i.e. the new
> > freespace extent is going to have one of 4 possible values:
> > 
> > 	no merge: len
> > 	left merge: ltlen + len
> > 	right merge: gtlen + len
> > 	both merge: ltlen + gtlen + len
> > 
> > So regardless of anything else, this code isn't setting the longest
> > freespace extent in teh AGF to the lenght of the longest freespace
> > extent in the filesystem.
> 
> > Which leads me to ask: how did you test this code? This bug should
> > have been triggering verifier, repair and scrub failures quite
> > quickly with fstests....
> > 
> 
> The logic I'm considering here is that the record is less than or equal
> to the maximum value that will be updated soon, as I wrote "potentially"
> in the comment. And consider the following two scenarios:
> 1) If it is no merge, then haveleft == 0 && haveright == 0, and
> bc_free_longest will not be assigned, and is no need to worry about the
> longest update at this time.
> 2) If it is in merge scenario, only updating the original values here,
> and the actual updates are put into the subsequent xfs_btree_insert().
> There is no need to worry about atomicity, both are carried out in the
> same transaction. All we have to do is the longest non-0. As long as the
> fast path judgment without locking passes, the longest must be updated
> to the correct value during the second lock judgment.

And therein lies the problem. We've learnt the had way not to do
partial state updates that might end up on disk even within
transactions. At some point in the future, we'll change the way the
code works, not realising that there's an inconsistent transient
state being logged, and some time after that we'll have occasional
reports of weird failures with values on disk or in the journal we
cannot explain.

> I tested this part of the code, passed xfstests, and local validation
> found no problems.

yeah, fstests won't expose the inconsistent state *right now*; the
problem is that we've just left a landmine for future developers to
step on.

It's also really difficult to follow - you've added non-obvious
coupling between the free space btree updates and the AGF updates
via a field held in a btree cursor. This essentially means that all
this stuff has to occur within the context of a single btree cursor,
and that btree cursor cannot be re-used for further operations
because this field is not reset by things like new lookups.

Then there is the question of what happens if we have duplicated the
cursor for a specific btree record operation, and the field is set
in the duplicated cursor. The core btree operations do this in
several places because they want to retain a cursor to the original
poistion, but the specific operation that needs to be performed will
change the cursor position (e.g. shifts, splits, merges, etc). Hence
there's no guarantee that a single cursor is used for all the
operations in a single btree modification, and hence storing
information in cursors that is supposed to persist until some other
btree modification method is run is asking for trouble.

Hence, IMO, coupling allocation btree coherency operations via the
btree cursor is something we should avoid at all costs. That's why I
keep saying the last record update for the by-count/AGF longest
needs to be moved outside the generic btree code itself. The
coherency and coupling needs to be directly controlled by the high
level alloc code, not by trying to punch special data holes through
the generic btree abstractions.

> > >   	/*
> > >   	 * Have both left and right contiguous neighbors.
> > >   	 * Merge all three into a single free block.
> > > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > > index 6ef5ddd89600..8e7d1e0f1a63 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > > @@ -161,7 +161,14 @@ xfs_allocbt_update_lastrec(
> > >   			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
> > >   			len = rrp->ar_blockcount;
> > >   		} else {
> > > -			len = 0;
> > > +			/*
> > > +			 * Update in advance to prevent file creation failure
> > > +			 * for concurrent processes even though there is no
> > > +			 * numrec currently.
> > > +			 * And there's no need to worry as the value that no
> > > +			 * less than bc_free_longest will be inserted later.
> > > +			 */
> > > +			len = cpu_to_be32(cur->bc_ag.bc_free_longest);
> > >   		}
> > 
> > So this is in the LASTREC_DELREC case when the last record is
> > removed from the btree. This is what causes the transient state
> > as we do this when deleting a record to trim it and then re-insert
> > the remainder back into the by-count btree.
> > 
> > Writing some random transient value into the AGF *and journalling
> > it* means we creating a transient on-disk format structure
> > corruption and potentially writing it to persistent storage (i.e.
> > the journal). The structure is, at least, not consistent in memory
> > because the free space tree is empty at this point in time, whilst
> > the agf->longest field says it has a free space available. This
> > could trip verifiers, be flagged as corruption by xfs_scrub/repair,
> > etc.
> > 
> 
> I'm sorry, but I didn't find the problem during my own screening. In my
> opinion, because the trigger scenario for the current problem is only to
> delete the last node and be updated shortly, and bc_free_longest is used
> only in the following two scenarios:
> 1) cntbt has only one extent and remains after being used, so nflen 1/2
> will be inserted later.
> 2) cntbt has only one extent and the released extent is adjacent to this
> record. This unique record will be deleted firstly, and then the two
> extents are merged and inserted.

Yes, I understand what you've done.

But I don't think it is the right way to fix the issue for the
reasons I've given.

I've attached a quick hack (not even compile tested!) to
demonstrate the way I've been suggesting this issue should be fixed
by the removal of the lastrec update code from the generic
btree implementation. It updates pag->pagf_longest and
agf->longest directly from the high level allocation code once the
free space btree manipulations have been completed. We do this in a
context where we control AGF, the perag and the btree cursors
directly, and there is no need to temporarily store anything in the
btree cursors at all.

Feel free to use this code as the basis of future patches to address
this issue.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: avoid races with btree lastrec updates

From: Dave Chinner <dchinner@redhat.com>

When we modify the last record in a generic btree, the
calls a function to indicate to the btree implementation that the
operation is modifying the right-most record in the tree. This is
only used by the by-size freespace btree, and it is used to update
the agf->longest field that tracks the longest contiguous free
extent in the AG.

This, however, is racy with respect to external sampling of the
agf->longest field. We may be doing multiple operations on the
by-size freespace tree to make an update - an extent length change
requires deleting the current extent, then inserting a new extent
with the new size. When the current extent is the only free space
extent in the AG (e.g. it is entirely empty), we end up with a
transient state where there is no free space extents in the btree.

By the time the modification completes, however, there is once again
a free space extent in the tree, and the agf->longest value gets set
to the correct size again. The issue is that external sampling of
agf->longest during allocation AG selection will see the extent as
having no space free, and so will skip it. This can lead to
transient ENOSPC errors when there is an entire AG of free space
available for use.

To fix this, remove the lastrec update triggers from the generic
btree code. Move the by-size last record update code to the end of
the by-size btree modifications, such that it is only changed once
during a free space extent allocation or freeing operation. This
removes the externally visible transient empty state, and so avoids
the transient, erroneous ENOSPC conditions that can currently occur.

XXX: the detection of the last record update being required could
probably be improved - just checking for "in the last block" works
just fine, and we are already going to be logging the AGF for the
free space counter updates, so it might just be that always doing
the update when we land in the last block isn't such a big deal
performance wise.

---
 fs/xfs/libxfs/xfs_alloc.c       | 94 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.c | 63 ---------------------------
 fs/xfs/libxfs/xfs_btree.c       | 51 ----------------------
 fs/xfs/libxfs/xfs_btree.h       |  6 ---
 4 files changed, 94 insertions(+), 120 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 35fbd6b19682..f256b7724cef 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -463,6 +463,76 @@ xfs_alloc_fix_len(
 	args->len = rlen;
 }
 
+/*
+ * Determine if the cursor points to the block that contains the right-most
+ * block of records in the by-count btree. This block contains the largest
+ * contiguous free extent in the AG, so if we modify ia record in this block we
+ * need to call xfs_alloc_fixup_longest() once the modifications are done to
+ * ensure the agf->agf_longest field is kept up to date with the longest free
+ * extent tracked by the by-count btree.
+ */
+static bool
+xfs_alloc_cursor_at_lastrec(
+	struct xfs_btree_cur	*cnt_cur)
+{
+	struct xfs_btree_block	*block;
+	union xfs_btree_ptr	ptr;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cnt_cur, 0, &bp);
+
+	xfs_btree_get_sibling(cnt_cur, block, &ptr, XFS_BB_RIGHTSIB);
+	if (!xfs_btree_ptr_is_null(cnt_cur, &ptr))
+		return false;
+	return true;
+}
+
+/*
+ * Update the longest contiguous free extent in the AG from the by-count cursor
+ * that is passed to us. This should be done at the end of any allocation or
+ * freeing operation that touches the longest extent in the btree.
+ *
+ * Needing to update the longest extent can be determined by calling
+ * xfs_alloc_cursor_at_lastrec() after the cursor is positioned for record
+ * modification but before the modification begins.
+ */
+static int
+xfs_alloc_fixup_longest(
+	struct xfs_btree_cur	*cnt_cur)
+{
+	struct xfs_perag	*pag = cnt_cur->bc_ag->pag;
+	struct xfs_agf		*agf;
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len;
+	int			error;
+	int			i;
+
+	/* lookup last rec and update AGF */
+	error = xfs_alloc_lookup_le(cnt_cur, 0, pag->pagf_longest, &i);
+	if (error)
+		return error;
+	if (i == 0) {
+		/* empty tree */
+		pag->pagf_longest = 0;
+	} else {
+		error = xfs_alloc_get_rec(cnt_cur, &bno, &len, &i);
+		if (error)
+			return error;
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cnt_cur);
+			return -EFSCORRUPTED;
+		}
+		pag->pagf_longest = nflen1;
+	}
+
+
+	agf = XFS_BUF_TO_AGF(cur->bc_ag.agbp);
+	agf->agf_longest = cpu_to_be32(pag->pagf_longest);
+	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
+
+	return 0;
+}
+
 /*
  * Update the two btrees, logically removing from freespace the extent
  * starting at rbno, rlen blocks.  The extent is contained within the
@@ -487,6 +557,7 @@ xfs_alloc_fixup_trees(
 	xfs_extlen_t	nflen1=0;	/* first new free length */
 	xfs_extlen_t	nflen2=0;	/* second new free length */
 	struct xfs_mount *mp;
+	bool		fixup_longest = false;
 
 	mp = cnt_cur->bc_mp;
 
@@ -575,9 +646,13 @@ xfs_alloc_fixup_trees(
 		nfbno2 = rbno + rlen;
 		nflen2 = (fbno + flen) - nfbno2;
 	}
+
 	/*
 	 * Delete the entry from the by-size btree.
 	 */
+	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
+		fixup_longest = true;
+
 	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -615,6 +690,7 @@ xfs_alloc_fixup_trees(
 			return -EFSCORRUPTED;
 		}
 	}
+
 	/*
 	 * Fix up the by-block btree entry(s).
 	 */
@@ -652,6 +728,10 @@ xfs_alloc_fixup_trees(
 			return -EFSCORRUPTED;
 		}
 	}
+
+	if (fixup_longest)
+		return xfs_alloc_fixup_longest(cnt_cur);
+
 	return 0;
 }
 
@@ -1954,6 +2034,7 @@ xfs_free_ag_extent(
 	int				i;
 	int				error;
 	struct xfs_perag		*pag = agbp->b_pag;
+	bool				fixup_longest = false;
 
 	bno_cur = cnt_cur = NULL;
 	mp = tp->t_mountp;
@@ -2217,8 +2298,13 @@ xfs_free_ag_extent(
 	}
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
 	bno_cur = NULL;
+
 	/*
 	 * In all cases we need to insert the new freespace in the by-size tree.
+	 *
+	 * If this new freespace is being inserted in the block that contains
+	 * the largest free space in the btree, make sure we also fix up the
+	 * agf->agf-longest tracker field.
 	 */
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
@@ -2227,6 +2313,8 @@ xfs_free_ag_extent(
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
+	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
+		fixup_longest = true;
 	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -2234,6 +2322,12 @@ xfs_free_ag_extent(
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
+	if (fixup_longest) {
+		error = xfs_alloc_fixup_longest(cnt_cur);
+		if (error)
+			goto error0;
+	}
+
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 	cnt_cur = NULL;
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 6ef5ddd89600..866d822dcfe7 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -115,67 +115,6 @@ xfs_allocbt_free_block(
 	return 0;
 }
 
-/*
- * Update the longest extent in the AGF
- */
-STATIC void
-xfs_allocbt_update_lastrec(
-	struct xfs_btree_cur		*cur,
-	const struct xfs_btree_block	*block,
-	const union xfs_btree_rec	*rec,
-	int				ptr,
-	int				reason)
-{
-	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
-	struct xfs_perag	*pag;
-	__be32			len;
-	int			numrecs;
-
-	ASSERT(!xfs_btree_is_bno(cur->bc_ops));
-
-	switch (reason) {
-	case LASTREC_UPDATE:
-		/*
-		 * If this is the last leaf block and it's the last record,
-		 * then update the size of the longest extent in the AG.
-		 */
-		if (ptr != xfs_btree_get_numrecs(block))
-			return;
-		len = rec->alloc.ar_blockcount;
-		break;
-	case LASTREC_INSREC:
-		if (be32_to_cpu(rec->alloc.ar_blockcount) <=
-		    be32_to_cpu(agf->agf_longest))
-			return;
-		len = rec->alloc.ar_blockcount;
-		break;
-	case LASTREC_DELREC:
-		numrecs = xfs_btree_get_numrecs(block);
-		if (ptr <= numrecs)
-			return;
-		ASSERT(ptr == numrecs + 1);
-
-		if (numrecs) {
-			xfs_alloc_rec_t *rrp;
-
-			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
-			len = rrp->ar_blockcount;
-		} else {
-			len = 0;
-		}
-
-		break;
-	default:
-		ASSERT(0);
-		return;
-	}
-
-	agf->agf_longest = len;
-	pag = cur->bc_ag.agbp->b_pag;
-	pag->pagf_longest = be32_to_cpu(len);
-	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
-}
-
 STATIC int
 xfs_allocbt_get_minrecs(
 	struct xfs_btree_cur	*cur,
@@ -493,7 +432,6 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
-	.update_lastrec		= xfs_allocbt_update_lastrec,
 	.get_minrecs		= xfs_allocbt_get_minrecs,
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
@@ -525,7 +463,6 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
-	.update_lastrec		= xfs_allocbt_update_lastrec,
 	.get_minrecs		= xfs_allocbt_get_minrecs,
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a119cbf71df1..c727dbcfebee 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1331,30 +1331,6 @@ xfs_btree_init_block_cur(
 			xfs_btree_owner(cur));
 }
 
-/*
- * Return true if ptr is the last record in the btree and
- * we need to track updates to this record.  The decision
- * will be further refined in the update_lastrec method.
- */
-STATIC int
-xfs_btree_is_lastrec(
-	struct xfs_btree_cur	*cur,
-	struct xfs_btree_block	*block,
-	int			level)
-{
-	union xfs_btree_ptr	ptr;
-
-	if (level > 0)
-		return 0;
-	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_LASTREC_UPDATE))
-		return 0;
-
-	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
-	if (!xfs_btree_ptr_is_null(cur, &ptr))
-		return 0;
-	return 1;
-}
-
 STATIC void
 xfs_btree_buf_to_ptr(
 	struct xfs_btree_cur	*cur,
@@ -2476,15 +2452,6 @@ xfs_btree_update(
 	xfs_btree_copy_recs(cur, rp, rec, 1);
 	xfs_btree_log_recs(cur, bp, ptr, ptr);
 
-	/*
-	 * If we are tracking the last record in the tree and
-	 * we are at the far right edge of the tree, update it.
-	 */
-	if (xfs_btree_is_lastrec(cur, block, 0)) {
-		cur->bc_ops->update_lastrec(cur, block, rec,
-					    ptr, LASTREC_UPDATE);
-	}
-
 	/* Pass new key value up to our parent. */
 	if (xfs_btree_needs_key_update(cur, ptr)) {
 		error = xfs_btree_update_keys(cur, 0);
@@ -3786,15 +3753,6 @@ xfs_btree_insrec(
 			goto error0;
 	}
 
-	/*
-	 * If we are tracking the last record in the tree and
-	 * we are at the far right edge of the tree, update it.
-	 */
-	if (xfs_btree_is_lastrec(cur, block, level)) {
-		cur->bc_ops->update_lastrec(cur, block, rec,
-					    ptr, LASTREC_INSREC);
-	}
-
 	/*
 	 * Return the new block number, if any.
 	 * If there is one, give back a record value and a cursor too.
@@ -4152,15 +4110,6 @@ xfs_btree_delrec(
 	xfs_btree_set_numrecs(block, --numrecs);
 	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
 
-	/*
-	 * If we are tracking the last record in the tree and
-	 * we are at the far right edge of the tree, update it.
-	 */
-	if (xfs_btree_is_lastrec(cur, block, level)) {
-		cur->bc_ops->update_lastrec(cur, block, NULL,
-					    ptr, LASTREC_DELREC);
-	}
-
 	/*
 	 * We're at the root level.  First, shrink the root block in-memory.
 	 * Try to get rid of the next level down.  If we can't then there's
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index f93374278aa1..99c1e4a02556 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -154,12 +154,6 @@ struct xfs_btree_ops {
 			       int *stat);
 	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp);
 
-	/* update last record information */
-	void	(*update_lastrec)(struct xfs_btree_cur *cur,
-				  const struct xfs_btree_block *block,
-				  const union xfs_btree_rec *rec,
-				  int ptr, int reason);
-
 	/* records in block/level */
 	int	(*get_minrecs)(struct xfs_btree_cur *cur, int level);
 	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
