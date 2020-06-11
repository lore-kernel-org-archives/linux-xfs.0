Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F1AC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 14:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354662083E
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 14:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STCnd8jC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgFKOHS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 10:07:18 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51648 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726109AbgFKOHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jun 2020 10:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591884435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x7MBmCvoIFf0gvZWAFPFWPMbFoPh93H0EMnuwsKUdFY=;
        b=STCnd8jC9nxCWIuhYo/0KkRb1YPMjAUbF7axIFAEuAdDlCIF+hOL2KSuqK3/XsrqxjDXNS
        xRVK+Ks2ZgIChwY91TkuXT0njuoTnbke3bNzY/CxI9HMXvi3sX54R1Lz0stss8ILlhgG+n
        l5AMlS8d2OxiX+EN+dJpNQLLYNyMbws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-9FOSMPXTO3qQSODeuS0FPQ-1; Thu, 11 Jun 2020 10:07:13 -0400
X-MC-Unique: 9FOSMPXTO3qQSODeuS0FPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 277F68018AB;
        Thu, 11 Jun 2020 14:07:12 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1C9A5D9DC;
        Thu, 11 Jun 2020 14:07:11 +0000 (UTC)
Date:   Thu, 11 Jun 2020 10:07:09 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/30] xfs: factor xfs_iflush_done
Message-ID: <20200611140709.GB56572@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-30-david@fromorbit.com>
 <20200609131249.GC40899@bfoster>
 <20200609221431.GK2040@dread.disaster.area>
 <20200610130833.GB50747@bfoster>
 <20200611001622.GN2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611001622.GN2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 11, 2020 at 10:16:22AM +1000, Dave Chinner wrote:
> On Wed, Jun 10, 2020 at 09:08:33AM -0400, Brian Foster wrote:
> > On Wed, Jun 10, 2020 at 08:14:31AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 09, 2020 at 09:12:49AM -0400, Brian Foster wrote:
> > > > On Thu, Jun 04, 2020 at 05:46:05PM +1000, Dave Chinner wrote:
...
> > 
> > I'm referring to the fact that we no longer check the lsn of each
> > (flushed) log item attached to the buffer under the ail lock.
> 
> That whole loop in xfs_iflush_ail_updates() runs under the AIL
> lock, so it does the right thing for anything that is moved to the
> "ail_updates" list.
> 
> If we win the unlocked race (li_lsn does not change) then we move
> the inode to the ail update list and it gets rechecked under the AIL
> lock and does the right thing. If we lose the race (li_lsn changes)
> then the inode has been redirtied and we *don't need to check it
> under the AIL* - all we need to do is leave it attached to the
> buffer.
> 
> This is the same as the old code: win the race, need_ail is
> incremented and we recheck under the AIL lock. Lose the race and
> we don't recheck under the AIL because we don't need to. This
> happened less under the old code, because it typically only happened
> with single dirty inodes on a cluster buffer (think directory inode
> under long running large directory modification operations), but
> that race most definitely existed and the code most definitely
> handled it correctly.
> 
> Keep in mind that this inode redirtying/AIL repositioning race can
> even occur /after/ we've locked and removed items from the AIL but
> before we've run xfs_iflush_finish(). i.e. we can remove it from the
> AIL but by the time xfs_iflush_finish() runs it's back in the AIL.
> 

All of the above would make a nice commit log for an independent patch.
;) Note again that I wasn't suggesting the logic was incorrect...

> > Note that
> > I am not saying it's necessarily wrong, but rather that IMO it's too
> > subtle a change to silently squash into a refactoring patch.
> 
> Except it isn't a change at all. The same subtle issue exists in the
> code before this patch. It's just that this refactoring makes subtle
> race conditions that were previously unknown to reviewers so much
> more obvious they can now see them clearly. That tells me the code
> is much improved by this refactoring, not that there's a problem
> that needs reworking....
> 

This patch elevates a bit of code from effectively being an (ail) lock
avoidance optimization to essentially per-item filtering logic without
any explanation beyond facilitating future modifications. Independent of
whether it's correct, this is not purely a refactoring change IMO.

> > > FWIW, I untangled the function this way because the "track dirty
> > > inodes by ordered buffers" patchset completely removes the AIL stuff
> > > - the ail_updates list and the xfs_iflush_ail_updates() function go
> > > away completely and the rest of the refactoring remains unchanged.
> > > i.e.  as the commit messages says, this change makes follow-on
> > > patches much easier to understand...
> > > 
> > 
> > The general function breakdown seems fine to me. I find the multiple
> > list processing to be a bit overdone, particularly if it doesn't serve a
> > current functional purpose. If the purpose is to support a future patch
> > series, I'd suggest to continue using the existing logic of moving all
> > flushed inodes to a single list and leave the separate list bits to the
> > start of the series where it's useful so it's possible to review with
> > the associated context (or alternatively just defer the entire patch).
> 
> That's how I originally did it, and it was a mess. it didn't
> separate cleanly at all, and didn't make future patches much easier
> at all. Hence I don't think reworking the patch just to look
> different gains us anything at this point...
> 

I find that hard to believe. This patch splits the buffer list into two
lists, processes the first one, immediately combines it with the second,
then processes the second which is no different from the single list
that was constructed by the original code. The only reasons I can see
for this kind of churn is either to address some kind of performance or
efficiency issue or if the lists are used for further changes. The
former is not a documented reason and there's no context for the latter
because it's apparently part of some future series.

TBH, I think this patch should probably be broken down into two or three
independent patches anyways. What's the issue with something like the
appended diff (on top of this patch) in the meantime? If the multiple
list logic is truly necessary, reintroduce it when it's used so it's
actually reviewable..

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 3894d190ea5b..83580e204560 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -718,8 +718,8 @@ xfs_iflush_done(
 	struct xfs_buf		*bp)
 {
 	struct xfs_log_item	*lip, *n;
-	LIST_HEAD(flushed_inodes);
-	LIST_HEAD(ail_updates);
+	int			need_ail = 0;
+	LIST_HEAD(tmp);
 
 	/*
 	 * Pull the attached inodes from the buffer one at a time and take the
@@ -732,25 +732,24 @@ xfs_iflush_done(
 			xfs_iflush_abort(iip->ili_inode);
 			continue;
 		}
+
 		if (!iip->ili_last_fields)
 			continue;
 
-		/* Do an unlocked check for needing the AIL lock. */
+		list_move_tail(&lip->li_bio_list, &tmp);
+
+		/* Do an unlocked check for needing AIL processing */
 		if (iip->ili_flush_lsn == lip->li_lsn ||
 		    test_bit(XFS_LI_FAILED, &lip->li_flags))
-			list_move_tail(&lip->li_bio_list, &ail_updates);
-		else
-			list_move_tail(&lip->li_bio_list, &flushed_inodes);
+			need_ail++;
 	}
 
-	if (!list_empty(&ail_updates)) {
-		xfs_iflush_ail_updates(bp->b_mount->m_ail, &ail_updates);
-		list_splice_tail(&ail_updates, &flushed_inodes);
-	}
+	if (need_ail)
+		xfs_iflush_ail_updates(bp->b_mount->m_ail, &tmp);
 
-	xfs_iflush_finish(bp, &flushed_inodes);
-	if (!list_empty(&flushed_inodes))
-		list_splice_tail(&flushed_inodes, &bp->b_li_list);
+	xfs_iflush_finish(bp, &tmp);
+	if (!list_empty(&tmp))
+		list_splice_tail(&tmp, &bp->b_li_list);
 }
 
 /*

