Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4263FC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 15:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A4F721848
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 15:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389382AbfISPFU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 11:05:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389179AbfISPFU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 11:05:20 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F5AD308AA11;
        Thu, 19 Sep 2019 15:05:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A5E45C207;
        Thu, 19 Sep 2019 15:05:18 +0000 (UTC)
Date:   Thu, 19 Sep 2019 11:05:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 11/11] xfs: optimize near mode bnobt scans with
 concurrent cntbt lookups
Message-ID: <20190919150517.GG35460@bfoster>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-12-bfoster@redhat.com>
 <20190918211158.GA2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918211158.GA2229799@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 19 Sep 2019 15:05:19 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 02:11:58PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 16, 2019 at 08:16:35AM -0400, Brian Foster wrote:
> > The near mode fallback algorithm consists of a left/right scan of
> > the bnobt. This algorithm has very poor breakdown characteristics
> > under worst case free space fragmentation conditions. If a suitable
> > extent is far enough from the locality hint, each allocation may
> > scan most or all of the bnobt before it completes. This causes
> > pathological behavior and extremely high allocation latencies.
> > 
> > While locality is important to near mode allocations, it is not so
> > important as to incur pathological allocation latency to provide the
> > asolute best available locality for every allocation. If the
> > allocation is large enough or far enough away, there is a point of
> > diminishing returns. As such, we can bound the overall operation by
> > including an iterative cntbt lookup in the broader search. The cntbt
> > lookup is optimized to immediately find the extent with best
> > locality for the given size on each iteration. Since the cntbt is
> > indexed by extent size, the lookup repeats with a variably
> > aggressive increasing search key size until it runs off the edge of
> > the tree.
> > 
> > This approach provides a natural balance between the two algorithms
> > for various situations. For example, the bnobt scan is able to
> > satisfy smaller allocations such as for inode chunks or btree blocks
> > more quickly where the cntbt search may have to search through a
> > large set of extent sizes when the search key starts off small
> > relative to the largest extent in the tree. On the other hand, the
> > cntbt search more deterministically covers the set of suitable
> > extents for larger data extent allocation requests that the bnobt
> > scan may have to search the entire tree to locate.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 153 +++++++++++++++++++++++++++++++++++---
> >  fs/xfs/xfs_trace.h        |   2 +
> >  2 files changed, 143 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 381a08257aaf..4ec22040e516 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
...
> > @@ -1309,9 +1407,39 @@ xfs_alloc_ag_vextent_bnobt(
> >  			fbinc = false;
> >  			break;
> >  		}
> > +
> > +		/*
> > +		 * Check the extent with best locality based on the current
> > +		 * extent size search key and keep track of the best candidate.
> > +		 * If we fail to find anything due to busy extents, return
> > +		 * empty handed so the caller can flush and retry the search. If
> > +		 * no busy extents were found, walk backwards from the end of
> > +		 * the cntbt as a last resort.
> > +		 */
> > +		error = xfs_alloc_cntbt_iter(args, acur);
> > +		if (error)
> > +			return error;
> > +		if (!xfs_alloc_cur_active(acur->cnt)) {
> > +			trace_xfs_alloc_cur_lookup_done(args);
> > +			if (!acur->len && !acur->busy) {
> > +				error = xfs_btree_decrement(acur->cnt, 0, &i);
> > +				if (error)
> > +					return error;
> > +				if (i) {
> > +					acur->cnt->bc_private.a.priv.abt.active = true;
> 
> Line over 80 columns?
> 

Yeah..

> Or, put another way, could this be refactored not to have 5 levels of
> indent?
> 

Hmm.. I think this could just break out of the loop and then check
whether the cntbt cursor is !active again just after the loop to reset
the cursor and set up a cntbt reverse search. I'll look into it. Thanks
for the feedback...

Brian

> Otherwise looks good.
> 
> --D
> 
> > +					fbcur = acur->cnt;
> > +					fbinc = false;
> > +				}
> > +			}
> > +			break;
> > +		}
> > +
> >  	}
> >  
> > -	/* search the opposite direction for a better entry */
> > +	/*
> > +	 * Search in the opposite direction for a better entry in the case of
> > +	 * a bnobt hit or walk backwards from the end of the cntbt.
> > +	 */
> >  	if (fbcur) {
> >  		error = xfs_alloc_walk_iter(args, acur, fbcur, fbinc, true, -1,
> >  					    &i);
> > @@ -1440,9 +1568,10 @@ xfs_alloc_ag_vextent_near(
> >  	}
> >  
> >  	/*
> > -	 * Second algorithm. Search the bnobt left and right.
> > +	 * Second algorithm. Combined cntbt and bnobt search to find ideal
> > +	 * locality.
> >  	 */
> > -	error = xfs_alloc_ag_vextent_bnobt(args, &acur, &i);
> > +	error = xfs_alloc_ag_vextent_locality(args, &acur, &i);
> >  	if (error)
> >  		goto out;
> >  
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index b8b93068efe7..0c9dfeac4e75 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -1645,6 +1645,8 @@ DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_cur);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup_done);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
> > -- 
> > 2.20.1
> > 
