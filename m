Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5A7C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 14:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiKCOyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 10:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiKCOyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 10:54:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA961A80A
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 07:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667487197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AkFTy9iUMfArVm8kdFvnJhhH/qW7zNxTkWuyMqZORJ8=;
        b=QsYPxeObkjghkIWcKEln4Sgl1NEIqBDyH1RfvlL3rbtLXRw39HiDumSjuIng5K/cQeGkNR
        rTSCdbeNYQ7edvOgv5o2YMNmgl61C03nigetSFbPclREGRSjiLs5dXatz2mam9p+WXuWOc
        CK43GwUC+NShM49nlxoH+yVkLyvltFo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10-0KwySjZWNFqKl_QpQv0MhA-1; Thu, 03 Nov 2022 10:53:14 -0400
X-MC-Unique: 0KwySjZWNFqKl_QpQv0MhA-1
Received: by mail-qv1-f70.google.com with SMTP id ln3-20020a0562145a8300b004b8c29a7d50so1438895qvb.15
        for <linux-xfs@vger.kernel.org>; Thu, 03 Nov 2022 07:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AkFTy9iUMfArVm8kdFvnJhhH/qW7zNxTkWuyMqZORJ8=;
        b=uq2zKgQItXRRKPCsIWnS66wYHlEHCMqz3MK/j8w2XGVgUqV8DHYY0apkgFiZFe/14H
         1K8cPwvznV8ZOnHWTI2xVJPwEYWkUrP13mEeg+Q/CfB+ak0nvKePQXQz0V9g4uI65fXK
         Q1C2uOOlK0KRNEO6OqdXCPokQewHeZ2sqebe7ilU+A/VrQKjpCE324evyeBzrPGsfdYh
         7R6+B++erjTv1G+n34e3t0T2JCloEbARjv83a1gmSZM3ksFbVYVP9h0Na1Iu6kDkkvOd
         Q0ial2yXVh16U5VcYSgvKfS0Ij6yWsIR317AjylGjCsQ7chwZNOoLLCxqiakiC/vE8fo
         o5wQ==
X-Gm-Message-State: ACrzQf0Y9YphstPkiU17OTDwosy0ggF+AfYXpdQNGGQdk5y7cMWSfs89
        5Bm4D5Cqj/8rlVtZ5HHJ8BA+CrYLpDcpkZN46vMsBUka34B5cobqhwN2kaU7dQlZXaQCoO9H47Q
        2rZDyR+kwAywwK/zR/G9Y
X-Received: by 2002:a05:620a:ced:b0:6fa:6c8f:8e49 with SMTP id c13-20020a05620a0ced00b006fa6c8f8e49mr5009871qkj.248.1667487192248;
        Thu, 03 Nov 2022 07:53:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6OypAw3T3R4DyBSCntKW4ztTWwryOlofkaUL1xaWUHQ5pFBRwnOmBiOjjaN+/2uLHBb2b8iA==
X-Received: by 2002:a05:620a:ced:b0:6fa:6c8f:8e49 with SMTP id c13-20020a05620a0ced00b006fa6c8f8e49mr5009849qkj.248.1667487191901;
        Thu, 03 Nov 2022 07:53:11 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id fb17-20020a05622a481100b0038d9555b580sm655878qtb.44.2022.11.03.07.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 07:53:11 -0700 (PDT)
Date:   Thu, 3 Nov 2022 10:53:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: redirty eof folio on truncate to avoid filemap flush
Message-ID: <Y2PV3KQ9K2l+65Eu@bfoster>
References: <20221028130411.977076-1-bfoster@redhat.com>
 <20221028131109.977581-1-bfoster@redhat.com>
 <Y1we59XylviZs+Ry@bfoster>
 <20221028213014.GD3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028213014.GD3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 29, 2022 at 08:30:14AM +1100, Dave Chinner wrote:
> On Fri, Oct 28, 2022 at 02:26:47PM -0400, Brian Foster wrote:
> > On Fri, Oct 28, 2022 at 09:11:09AM -0400, Brian Foster wrote:
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > Here's a quick prototype of "option 3" described in my previous mail.
> > > This has been spot tested and confirmed to prevent the original stale
> > > data exposure problem. More thorough regression testing is still
> > > required. Barring unforeseen issues with that, however, I think this is
> > > tentatively my new preferred option. The primary reason for that is it
> > > avoids looking at extent state and is more in line with what iomap based
> > > zeroing should be doing more generically.
> > > 
> > > Because of that, I think this provides a bit more opportunity for follow
> > > on fixes (there are other truncate/zeroing problems I've come across
> > > during this investigation that still need fixing), cleanup and
> > > consolidation of the zeroing code. For example, I think the trajectory
> > > of this could look something like:
> > > 
> > > - Genericize a bit more to handle all truncates.
> > > - Repurpose iomap_truncate_page() (currently only used by XFS) into a
> > >   unique implementation from zero range that does explicit zeroing
> > >   instead of relying on pagecache truncate.
> > > - Refactor XFS ranged zeroing to an abstraction that uses a combination
> > >   of iomap_zero_range() and the new iomap_truncate_page().
> > > 
> > 
> > After playing with this and thinking a bit more about the above, I think
> > I managed to come up with an iomap_truncate_page() prototype that DTRT
> > based on this. Only spot tested so far, needs to pass iomap_flags to the
> > other bmbt_to_iomap() calls to handle the cow fork, undoubtedly has
> > other bugs/warts, etc. etc. This is just a quick prototype to
> > demonstrate the idea, which is essentially to check dirty state along
> > with extent state while under lock and transfer that state back to iomap
> > so it can decide whether it can shortcut or forcibly perform the zero.
> > 
> > In a nutshell, IOMAP_TRUNC_PAGE asks the fs to check dirty state while
> > under lock and implies that the range is sub-block (single page).
> > IOMAP_F_TRUNC_PAGE on the imap informs iomap that the range was in fact
> > dirty, so perform the zero via buffered write regardless of extent
> > state.
> 
> I'd much prefer we fix this in the iomap infrastructure - failing to
> zero dirty data in memory over an unwritten extent isn't an XFS bug,
> so we shouldn't be working around it in XFS like we did previously.
> 

I agree, but that was the original goal from the start. It's easier said
than done to just have iomap accurately write/skip the appropriate
ranges..

> I don't think this should be call "IOMAP_TRUNC_PAGE", though,
> because that indicates the caller context, not what we are asking
> the internal iomap code to do. What we are really asking is for
> iomap_zero_iter() to do is zero the page cache if it exists in
> memory, otherwise ignore unwritten/hole pages.  Hence I think a name
> like IOMAP_ZERO_PAGECACHE is more appropriate,
> 

That was kind of the point for this prototype. The flag isn't just
asking iomap to perform some generic write behavior. It also indicates
this is a special snowflake mode with assumptions from the caller (i.e.,
unflushed, sub-block/partial range) that facilitate forced zeroing
internally.

I've since come to the conclusion that this approach is just premature.
It really only does the right thing in this very particular case,
otherwise there is potential for odd/unexpected behavior in sub-page
blocksize scenarios. It could be made to work more appropriately
eventually, but more thought and work is required and there's a jump in
complexity that isn't required to fix the immediate performance problem
and additional stale data exposure problems.

> > 
> > Brian
> > 
> > --- 8< ---
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 91ee0b308e13..14a9734b2838 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -899,7 +899,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >  	loff_t written = 0;
> >  
> >  	/* already zeroed?  we're done. */
> > -	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
> > +	if ((srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) &&
> > +	    !(srcmap->flags & IOMAP_F_TRUNC_PAGE))
> >  		return length;
> 
> Why even involve the filesystem in this? We can do this directly
> in iomap_zero_iter() with:
> 
> 	if ((srcmap->type == IOMAP_HOLE)
> 		return;
> 	if (srcmap->type == IOMAP_UNWRITTEN) {
> 		if (!(iter->flags & IOMAP_ZERO_PAGECACHE))
> 			return;
> 		if (!filemap_range_needs_writeback(inode->i_mapping,
> 			    iomap->offset, iomap->offset + iomap->length))
> 			return;
> 	}
> 

This reintroduces the same stale data exposure race fixed by the
original patch. folio writeback can complete and convert an extent
reported as unwritten such that zeroing will not occur when it should.
The writeback check either needs to be in the fs code where it can
prevent writeback completion from converting extents (under ilock), or
earlier in iomap such that we're guaranteed to see either writeback
state or the converted extent.

Given the above, I'm currently putting the prototype shown below through
some regression testing. It lifts the writeback check into iomap and
issues a flush and retry of the current iteration from iomap_zero_iter()
when necessary. In more focused testing thus far, this addresses the XFS
truncate performance problem by making the flush conditional, prevents
the original stale data exposure problem, and also addresses one or two
similar outstanding problems buried in write extending patterns and
whatnot.

Since this all exists in iomap, no fs changes are required to provide a
minimum guarantee of correctness (at the cost of additional, occasional
flushes). If there are scenarios where the performance cost is a
problem, an additional flag akin to the IOMAP_TRUNC_PAGE proposal can
still be added and conditionally set by the fs if/when it wants to make
that tradeoff. For example, XFS could pass some ->private state through
the iomap_truncate_page() variant that ->iomap_begin() could use to
trivially eliminate the flush in the truncate path, or implement a size
or range trimming heuristic to eliminate/mitigate it in others. If/when
iomap has enough information to do selective zeroing properly on its own
without fs intervention, the flush fallback can simply go away.

I have some patches around that demonstrate such things, but given the
current behavior of an unconditional flush and so far only seeing one
user report from an oddball pattern, I don't see much need for
additional hacks at the moment.

Thoughts? IMO, the iter retry and writeback check are both wonky and
this is something that should first go into ->iomap_begin(), and only
lift into iomap after a period of time. That's just my .02. I do plan to
clean up with a retry helper and add comments and whatnot if this
survives testing and/or any functional issues are worked out.

Brian

--- 8< ---

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 91ee0b308e13..649d94ad3808 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -894,17 +894,28 @@ EXPORT_SYMBOL_GPL(iomap_file_unshare);
 static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
+	struct inode *inode = iter->inode;
 	loff_t pos = iter->pos;
 	loff_t length = iomap_length(iter);
 	loff_t written = 0;
+	int status;
 
 	/* already zeroed?  we're done. */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
-		return length;
+	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) {
+		if (!(srcmap->flags & IOMAP_F_DIRTY_CACHE))
+			return length;
+
+		status = filemap_write_and_wait_range(inode->i_mapping, pos,
+						      pos + length - 1);
+		if (status)
+			return status;
+		/* XXX: hacked up iter retry */
+		iter->iomap.length = 0;
+		return 1;
+	}
 
 	do {
 		struct folio *folio;
-		int status;
 		size_t offset;
 		size_t bytes = min_t(u64, SIZE_MAX, length);
 
@@ -916,6 +927,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		if (bytes > folio_size(folio) - offset)
 			bytes = folio_size(folio) - offset;
 
+		trace_printk("%d: zero ino 0x%lx offset 0x%lx bytes 0x%lx\n",
+			__LINE__, folio->mapping->host->i_ino, offset, bytes);
 		folio_zero_range(folio, offset, bytes);
 		folio_mark_accessed(folio);
 
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index a1c7592d2ade..ebfcc07ace94 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -5,6 +5,7 @@
  */
 #include <linux/fs.h>
 #include <linux/iomap.h>
+#include <linux/pagemap.h>
 #include "trace.h"
 
 static inline int iomap_iter_advance(struct iomap_iter *iter)
@@ -28,15 +29,18 @@ static inline int iomap_iter_advance(struct iomap_iter *iter)
 	return 1;
 }
 
-static inline void iomap_iter_done(struct iomap_iter *iter)
+static inline void iomap_iter_done(struct iomap_iter *iter, u16 iomap_flags)
 {
 	WARN_ON_ONCE(iter->iomap.offset > iter->pos);
 	WARN_ON_ONCE(iter->iomap.length == 0);
 	WARN_ON_ONCE(iter->iomap.offset + iter->iomap.length <= iter->pos);
 
+	iter->iomap.flags |= iomap_flags;
 	trace_iomap_iter_dstmap(iter->inode, &iter->iomap);
-	if (iter->srcmap.type != IOMAP_HOLE)
+	if (iter->srcmap.type != IOMAP_HOLE) {
+		iter->srcmap.flags |= iomap_flags;
 		trace_iomap_iter_srcmap(iter->inode, &iter->srcmap);
+	}
 }
 
 /**
@@ -57,6 +61,7 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 {
 	int ret;
+	u16 iomap_flags = 0;
 
 	if (iter->iomap.length && ops->iomap_end) {
 		ret = ops->iomap_end(iter->inode, iter->pos, iomap_length(iter),
@@ -71,10 +76,16 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	if (ret <= 0)
 		return ret;
 
+	if ((iter->flags & IOMAP_ZERO) &&
+	    filemap_range_needs_writeback(iter->inode->i_mapping, iter->pos,
+					  iter->pos + iter->len - 1)) {
+		iomap_flags |= IOMAP_F_DIRTY_CACHE;
+	}
+
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
 		return ret;
-	iomap_iter_done(iter);
+	iomap_iter_done(iter, iomap_flags);
 	return 1;
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2e10e1c66ad6..3c40a81d6da0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -840,16 +840,6 @@ xfs_setattr_size(
 		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
 				&did_zeroing);
 	} else {
-		/*
-		 * iomap won't detect a dirty page over an unwritten block (or a
-		 * cow block over a hole) and subsequently skips zeroing the
-		 * newly post-EOF portion of the page. Flush the new EOF to
-		 * convert the block before the pagecache truncate.
-		 */
-		error = filemap_write_and_wait_range(inode->i_mapping, newsize,
-						     newsize);
-		if (error)
-			return error;
 		error = xfs_truncate_page(ip, newsize, &did_zeroing);
 	}
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 238a03087e17..bbfbda7bc905 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -56,6 +56,7 @@ struct vm_fault;
 #define IOMAP_F_MERGED		0x08
 #define IOMAP_F_BUFFER_HEAD	0x10
 #define IOMAP_F_ZONE_APPEND	0x20
+#define IOMAP_F_DIRTY_CACHE	0x40
 
 /*
  * Flags set by the core iomap code during operations:

