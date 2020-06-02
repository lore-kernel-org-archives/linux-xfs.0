Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D14C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 07:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7589720734
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 07:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgFBHGP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 03:06:15 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:59010 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgFBHGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 03:06:14 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 269841A8B8F;
        Tue,  2 Jun 2020 17:06:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jg0zw-0003un-EV; Tue, 02 Jun 2020 17:06:08 +1000
Date:   Tue, 2 Jun 2020 17:06:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/30] xfs: Don't allow logging of XFS_ISTALE inodes
Message-ID: <20200602070608.GE2040@dread.disaster.area>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-2-david@fromorbit.com>
 <20200602043052.GZ8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602043052.GZ8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=iqlEFPBwl9b5J_jsSEEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:30:52PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 02, 2020 at 07:42:22AM +1000, Dave Chinner wrote:
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1740,10 +1740,31 @@ xfs_inactive_ifree(
> >  		return error;
> >  	}
> >  
> > +	/*
> > +	 * We do not hold the inode locked across the entire rolling transaction
> > +	 * here. We only need to hold it for the first transaction that
> > +	 * xfs_ifree() builds, which may mark the inode XFS_ISTALE if the
> > +	 * underlying cluster buffer is freed. Relogging an XFS_ISTALE inode
> > +	 * here breaks the relationship between cluster buffer invalidation and
> > +	 * stale inode invalidation on cluster buffer item journal commit
> > +	 * completion, and can result in leaving dirty stale inodes hanging
> > +	 * around in memory.
> > +	 *
> > +	 * We have no need for serialising this inode operation against other
> > +	 * operations - we freed the inode and hence reallocation is required
> > +	 * and that will serialise on reallocating the space the deferops need
> > +	 * to free. Hence we can unlock the inode on the first commit of
> > +	 * the transaction rather than roll it right through the deferops. This
> > +	 * avoids relogging the XFS_ISTALE inode.
> 
> Hmm.  What defer ops causes a transaction roll?  Is it the EFI that
> frees the inode cluster blocks?

Yeah, xfs_difree_inode_chunk() calls xfs_bmap_add_free() which goes
through the deferops to free the inode chunk extent(s).

I suspect that we can also get xfs_alloc_fix_freelist() deferring
AGFL frees here too. I basically just assume anything that allocates
or frees extents is likely to have at least one deferop as a result
of this....

> > +	 *
> > +	 * We check that xfs_ifree() hasn't grown an internal transaction roll
> > +	 * by asserting that the inode is still locked when it returns.
> > +	 */
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -	xfs_trans_ijoin(tp, ip, 0);
> > +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> 
> This looks right to me since we should be marking the inode free in the
> first transaction and therefore should not keep it attached to the
> transaction...

*nod*

That was my thinking about the problem, too.

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
