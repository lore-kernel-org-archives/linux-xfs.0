Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCB7C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3E620757
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgFCAog (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 20:44:36 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40210 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgFCAof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 20:44:35 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6B2C5822AB4;
        Wed,  3 Jun 2020 10:44:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgHW9-0001gG-K3; Wed, 03 Jun 2020 10:44:29 +1000
Date:   Wed, 3 Jun 2020 10:44:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200603004429.GK2040@dread.disaster.area>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
 <20200603002222.GU8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603002222.GU8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Zi-DphM19Z3KzZi9J78A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 05:22:22PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 02, 2020 at 10:52:38PM +0800, Gao Xiang wrote:
> > Sometimes no need to play with perag_tree since for many
> > cases perag can also be accessed by agbp reliably.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
....
> > @@ -2447,32 +2443,22 @@ xfs_iunlink_remove(
> >  	 * this inode's backref to point from the next inode.
> >  	 */
> >  	if (next_agino != NULLAGINO) {
> > -		pag = xfs_perag_get(mp, agno);
> > -		error = xfs_iunlink_change_backref(pag, next_agino,
> > +		error = xfs_iunlink_change_backref(agibp->b_pag, next_agino,
> >  				NULLAGINO);
> >  		if (error)
> > -			goto out;
> > +			return error;
> >  	}
> >  
> > -	if (head_agino == agino) {
> > -		/* Point the head of the list to the next unlinked inode. */
> > -		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> > -				next_agino);
> > -		if (error)
> > -			goto out;
> > -	} else {
> > +	if (head_agino != agino) {
> >  		struct xfs_imap	imap;
> >  		xfs_agino_t	prev_agino;
> >  
> > -		if (!pag)
> > -			pag = xfs_perag_get(mp, agno);
> > -
> >  		/* We need to search the list for the inode being freed. */
> >  		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
> >  				&prev_agino, &imap, &last_dip, &last_ibp,
> > -				pag);
> > +				agibp->b_pag);
> >  		if (error)
> > -			goto out;
> > +			return error;
> >  
> >  		/* Point the previous inode on the list to the next inode. */
> >  		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
> > @@ -2486,15 +2472,13 @@ xfs_iunlink_remove(
> >  		 * change_backref takes care of deleting the backref if
> >  		 * next_agino is NULLAGINO.
> >  		 */
> > -		error = xfs_iunlink_change_backref(pag, agino, next_agino);
> > -		if (error)
> > -			goto out;
> > +		return xfs_iunlink_change_backref(agibp->b_pag, agino,
> > +				next_agino);
> >  	}
> >  
> > -out:
> > -	if (pag)
> > -		xfs_perag_put(pag);
> > -	return error;
> > +	/* Point the head of the list to the next unlinked inode. */
> > +	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> > +			next_agino);
> 
> Why not cut out the agno argument here too?  Surely you could obtain it
> from agibp->b_pag->pag_agno.  Ditto for xfs_iunlink_map_prev.

Those functions go away completely in the patchset I'm currently
working on for tracking dirty inodes in ordered buffers. The
in-memory unlinked list code needs to be completely reworked to
acheive this (due to lock order constraints), so I'd much prefer
unnecessary cleanup changes in this area are kept to a minimum
because it will all away real soon.

FWIW, it was the discovery we could use agibp->b_pag instead of
get/put in my iunlink list rework that prompted me to ask Xiang to
look at the rest of the code and see where the same pattern could be
applied...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
