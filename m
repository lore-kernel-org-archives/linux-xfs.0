Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896F3C3F2CE
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 23:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A07520866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 23:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388531AbgCDXxj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 18:53:39 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53199 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388511AbgCDXxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 18:53:39 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 317AF7EA345;
        Thu,  5 Mar 2020 10:53:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9dpX-00055M-Al; Thu, 05 Mar 2020 10:53:35 +1100
Date:   Thu, 5 Mar 2020 10:53:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20200304235335.GE10776@dread.disaster.area>
References: <158329250190.2423432.16958662769192587982.stgit@magnolia>
 <158329250827.2423432.18007812133503266256.stgit@magnolia>
 <20200304182103.GB22037@bfoster>
 <20200304233459.GG1752567@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304233459.GG1752567@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=w5--9OuVuTzmtBEsEwkA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 03:34:59PM -0800, Darrick J. Wong wrote:
> On Wed, Mar 04, 2020 at 01:21:03PM -0500, Brian Foster wrote:
> > On Tue, Mar 03, 2020 at 07:28:28PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Create an in-core fake root for AG-rooted btree types so that callers
> > > can generate a whole new btree using the upcoming btree bulk load
> > > function without making the new tree accessible from the rest of the
> > > filesystem.  It is up to the individual btree type to provide a function
> > > to create a staged cursor (presumably with the appropriate callouts to
> > > update the fakeroot) and then commit the staged root back into the
> > > filesystem.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > The code all seems reasonable, mostly infrastructure. Just a few high
> > level comments..
> > 
> > It would be helpful if the commit log (or code comments) explained more
> > about the callouts that are replaced for a staging tree (and why).
> 
> Ok.  I have two block comments to add.
> 
> > >  fs/xfs/libxfs/xfs_btree.c |  117 +++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_btree.h |   42 ++++++++++++++--
> > >  fs/xfs/xfs_trace.h        |   28 +++++++++++
> > >  3 files changed, 182 insertions(+), 5 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > index e6f898bf3174..9a7c1a4d0423 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > @@ -382,6 +382,8 @@ xfs_btree_del_cursor(
> > >  	/*
> > >  	 * Free the cursor.
> > >  	 */
> > > +	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
> > > +		kmem_free((void *)cur->bc_ops);
> > >  	kmem_cache_free(xfs_btree_cur_zone, cur);
> > >  }
> > >  
> > > @@ -4908,3 +4910,118 @@ xfs_btree_has_more_records(
> > >  	else
> > >  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
> > >  }
> 
> Add here a new comment:
> 
> /*
>  * Staging Cursors and Fake Roots for Btrees
>  * =========================================
>  *
>  * A staging btree cursor is a special type of btree cursor that callers
>  * must use to construct a new btree index using the btree bulk loader
>  * code.  The bulk loading code uses the staging btree cursor to
>  * abstract the details of initializing new btree blocks and filling
>  * them with records or key/ptr pairs.  Regular btree operations (e.g.
>  * queries and modifications) are not supported with staging cursors,
>  * and callers must not invoke them.
>  *
>  * Fake root structures contain all the information about a btree that
>  * is under construction by the bulk loading code.  Staging btree
>  * cursors point to fake root structures instead of the usual AG header
>  * or inode structure.
>  *
>  * Callers are expected to initialize a fake root structure and pass it
>  * into the _stage_cursor function for a specific btree type.  When bulk
>  * loading is complete, callers should call the _commit_staged_btree
>  * function for that specific btree type to commit the new btree into
>  * the filesystem.
>  */
> 
> 
> > > +
> > > +/* We don't allow staging cursors to be duplicated. */
> 
> /*
>  * Don't allow staging cursors to be duplicated because they're supposed
>  * to be kept private to a single thread.
>  */

private to a single -thread- or a single -btree modification
context-?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
