Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E169BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 23:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3B0B6135E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 23:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhJGXE5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 19:04:57 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33568 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230120AbhJGXE4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Oct 2021 19:04:56 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 924B61056DD2;
        Fri,  8 Oct 2021 10:03:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mYcPj-003fNW-A7; Fri, 08 Oct 2021 10:02:59 +1100
Date:   Fri, 8 Oct 2021 10:02:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: terminate perag iteration reliably on end agno
Message-ID: <20211007230259.GG54211@dread.disaster.area>
References: <20211007125053.1096868-1-bfoster@redhat.com>
 <20211007125053.1096868-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007125053.1096868-4-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=615f7ca4
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=7-415B0cAAAA:8
        a=GEbF7MWnIMwjSIlPYqcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 07, 2021 at 08:50:53AM -0400, Brian Foster wrote:
> The for_each_perag*() set of macros are hacky in that some (i.e. those
> based on sb_agcount) rely on the assumption that perag iteration
> terminates naturally with a NULL perag at the specified end agno. Others
> allow for the final AG to have a valid perag and require the calling
> function to clean up any potential leftover xfs_perag reference on
> termination of the loop.
> 
> Aside from providing a subtly inconsistent interface, the former variant
> is racy with a potential growfs in progress because growfs can create
> discoverable post-eofs perags before the final superblock update that
> completes the grow operation and increases sb_agcount. This leads to
> unexpected assert failures (reproduced by xfs/104) such as the following
> in the superblock buffer write verifier path:
> 
>  XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22

Yeah, that's a bad assert. It's not valid in the context of grow or
shrink or any of the future advanced per-ag management things we
want to do.

I'm ok with the change being proposed as a expedient bug fix, but
I'll note that the approach taken to fix it is not compatible with
future plans for managing shrink and perag operations. I'll comment
on the patch first, then the rest of the email is commentary about
how xfs_perag_get() is intended to be used...

> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index d05c9217c3af..edcdd4fbc225 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -116,34 +116,30 @@ void xfs_perag_put(struct xfs_perag *pag);
>  
>  /*
>   * Perag iteration APIs
> - *
> - * XXX: for_each_perag_range() usage really needs an iterator to clean up when
> - * we terminate at end_agno because we may have taken a reference to the perag
> - * beyond end_agno. Right now callers have to be careful to catch and clean that
> - * up themselves. This is not necessary for the callers of for_each_perag() and
> - * for_each_perag_from() because they terminate at sb_agcount where there are
> - * no perag structures in tree beyond end_agno.

We still really need an iterator for the range iterations so that we
can have a consistent set of behaviours for all iterations and
don't need a special case just for the "mid walk break" where the
code keeps the active reference to the perag for itself...

>   */
>  static inline
>  struct xfs_perag *xfs_perag_next(
>  	struct xfs_perag	*pag,
> -	xfs_agnumber_t		*agno)
> +	xfs_agnumber_t		*agno,
> +	xfs_agnumber_t		end_agno)
>  {
>  	struct xfs_mount	*mp = pag->pag_mount;
>  
>  	*agno = pag->pag_agno + 1;
>  	xfs_perag_put(pag);
> -	pag = xfs_perag_get(mp, *agno);
> +	pag = NULL;
> +	if (*agno <= end_agno)
> +		pag = xfs_perag_get(mp, *agno);
>  	return pag;

	*agno = pag->pag_agno + 1;
	xfs_perag_put(pag);
	if (*agno > end_agno)
		return NULL;
	return xfs_perag_get(mp, *agno);

>  }
>  
>  #define for_each_perag_range(mp, agno, end_agno, pag) \
>  	for ((pag) = xfs_perag_get((mp), (agno)); \
> -		(pag) != NULL && (agno) <= (end_agno); \
> -		(pag) = xfs_perag_next((pag), &(agno)))
> +		(pag) != NULL; \
> +		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
>  
>  #define for_each_perag_from(mp, agno, pag) \
> -	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
> +	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))

Isn't this one line the entire bug fix right here? i.e. the
factoring is largely unnecessary, the grow race bug is fixed by just
this one-liner?

----

Anyway, commentary now...

> This occurs because the perag loop in xfs_icount_range() finds and
> attempts to process a perag struct where pag_agno == sb_agcount.

That's not actually a traversal bug. The whole design of the per-ag
infrastructure is that a search for an agno beyond the current
limits of the fs should return NULL, and we use that all over the
place. e.g xfs_reclaim_inodes_count():

       while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
                ag = pag->pag_agno + 1;
                reclaimable += pag->pag_ici_reclaimable;
                xfs_perag_put(pag);
        }

And xfs_icwalk_get_perag() had exactly the same setup and a mode
that does use tags so absolutely relies on xfs_perag_get() to return
NULL to terminate the walk once at the end of the fs.

So this issue was not introduced by the for_each_perag() iterators;
it has been around for pretty much forever.

This problem is that the growfs process inserts the new perags
before the superblock agcount is updated.

IOWs, the grow process does:

xfs_initialize_perag	>>>> inserts new perags beyond sb_agcount
trans_alloc
xfs_resizefs_init_new_ags
xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
			>>>> triggers sb_agcount mod on commit
xfs_trans_commit
			>>>> makes sb_agcount change externally visible

Hence if we have a traversal in progress that terminates on a NULL
AG, it will see these new AGs before sb_agcount is updated. That's
always been the case, the only difference now is that all perag
traversals use NULL as the termination case instead of sb_agcount.
The xfs_icount_range() one is only run from xfs_validate_sb_write()
which means it could run during a grow event via AIL pushing, but
otherwise will not ever be an issue.

FWIW, the underlying reason for NULL terminating traversals is that
on -shrink- perags will go away in the middle of an iteration,
indicating that we've reached the end of the filesystem. THe problem
here is this:

traversal				shrink

end agno = sb_agcount = 32;
for (agno = 0;
     agno < end_agno;
     agno = pag->pag_agno + 1)
.....
					sb_agcount = 16
					removes perags 16-31
.....
    <agno now equals 16>
    <lookup returns NULL>

IOWs, the iterations *need* to terminate on a NULL AG, and they
cannot be dependent on the end agno remaining valid for the entire
duration of the walk.

Similarly, if we are racing with a grow, why would we not want to
find those newly initialised AGs? We may actually need to operate on
them even before the grow has completed (e.g. imagine background
growing by thousands of AGs which might take a couple of minutes on
slow storage, and in the mean time someone runs an admin op that
says "don't allocate anywhere in AGs > 300". We want those newly
initialised perags to be marked as "don't allocate" so that when the
grow finishes and makes them "active" they don't suddenly allow
allocation...

So, really, the direction I'm trying to take these iterators is
to get rid of all dependence on sb_agcount for termination, and
instead rely on NULL lookups and internal per-ag state to determine
if they are seen by iterations.

Along those lines, my current patchset converts all these iterators
from "get/put" semantics to "grab/release" semantics for
active/passive reference counting. Iterators only work with grab
semantics, meaning they take active references only. If the per-ag
does not allow active references (such as it's in the middle of
instantiation via grow, teardown via shrink or being managed by
dynamic instantiation infrastructure) then xfs_perag_grab() will
return NULL rather than an uninitialised/invalid perag.

The grow code now has a two phase intialisation for perags - the
first is to init and insert it as an inactive AG, hence active
reference traversals do not see it. THe second is to mark the AG
active after the superblock has been updated, hence making it
publicly available for active referencing in ongoing operations
only after the grow has completed.

That means the iteration in xfs_icount_range() changes to never see
perags beyond sb_agcount because it can't get active references on
it and so they return NULL.

The next step in this process is to use a tag to indicate the perag
can take active references, hence we can use tag based lookups to
efficiently iterate all the active perags, allowing grow, shrink and
dynamic instantiation to be able to quickly enable/disable active
references without actually changing the perag in the radix tree
index.

We need to keep the perag in the radix tree until all operations on
the perag are done, because things like the buffer cache need the
perag to still be present and findable by xfs_perag_get() even once
active references to the perag are no longer allowed. Dynamic
management of perags needs this, too, because we'll have to wait for
passive references like the buffer cache and busy extents to be
fully purged before we can free the perag...

> The following assert failure occasionally triggers during the xfs_perag
> free path on unmount, presumably because one of the many
> for_each_perag() loops in the code that is expected to terminate with a
> NULL pag raced with a growfs and actually terminated with a non-NULL
> reference to post-eofs (at the time) perag.
> 
>  XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/libxfs/xfs_ag.c, line: 195
> 
> Rework the lower level perag iteration logic to explicitly terminate
> on the specified end agno, not implicitly rely on pag == NULL as a
> termination clause and thus avoid these problems.

IMO, this just hides the symptom that results from code that isn't
handling unexpected adverse loop termination correctly. The
iterators are going to get more complex in the near future, so we
really need them to have a robust iterator API that does all the
cleanup work correctly, rather than try to hide it all in a
increasingly complex for loop construct.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
