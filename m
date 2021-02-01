Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B5AC433E9
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFF464EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhBASEn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230110AbhBASEl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 13:04:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECA3864E9C;
        Mon,  1 Feb 2021 18:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202640;
        bh=l0UnMls/Ow7WCULb5zS5VrYMEZ5XwZigGHZcMSZecIw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pWsyePdhaeoR72UrEXdDiajgUgcofDnHEmjRSOBh9H67gQifg1P84TWIZk+M0r10v
         63SEIManCCBrXqQh70cWljOWVf+FnPUQN5Xkcq7uAeFs5EOj7BzpWidkkHjPqNOFWu
         YT++dDdHzXCnIJklGYFXBlNWNi1QgLwyT7XrjJ80S/awIGyTy7oXQlq66Fdk5W0+hU
         qy/Ny4u28VLwzkkilTjDYKEW7uaKyOMi4XxGnzI/8QVUqO+5cTCam9yS7gb+ZC1Dco
         RgysS/Iiq2w+6dyb18FYOembII6XtZT3qSNs+DG0vxVC92MLTWI4WF1gJHlADSQLgy
         te45yckgEwJhA==
Date:   Mon, 1 Feb 2021 10:03:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 01/17] xfs: fix xquota chown transactionality wrt
 delalloc blocks
Message-ID: <20210201180359.GA7193@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214503452.139387.3026688558992670901.stgit@magnolia>
 <20210201121425.GA3271714@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201121425.GA3271714@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 12:14:25PM +0000, Christoph Hellwig wrote:
> On Sun, Jan 31, 2021 at 06:03:54PM -0800, Darrick J. Wong wrote:
> > @@ -1785,6 +1785,28 @@ xfs_qm_vop_chown(
> >  	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
> >  	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
> >  
> > +	/*
> > +	 * Back when we made quota reservations for the chown, we reserved the
> > +	 * ondisk blocks + delalloc blocks with the new dquot.  Now that we've
> > +	 * switched the dquots, decrease the new dquot's block reservation
> > +	 * (having already bumped up the real counter) so that we don't have
> > +	 * any reservation to give back when we commit.
> > +	 */
> > +	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
> > +			-ip->i_delayed_blks);
> > +
> > +	/*
> > +	 * Give the incore reservation for delalloc blocks back to the old
> > +	 * dquot.  We don't normally handle delalloc quota reservations
> > +	 * transactionally, so just lock the dquot and subtract from the
> > +	 * reservation.  We've dirtied the transaction, so it's too late to
> > +	 * turn back now.
> > +	 */
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	xfs_dqlock(prevdq);
> > +	prevdq->q_blk.reserved -= ip->i_delayed_blks;
> > +	xfs_dqunlock(prevdq);
> 
> Any particular reason for this order of operations vs grouping it with
> the existing prevdq and newdq sections?

None aside from maintaining a similar order (ondisk blocks, then
delalloc) as the code that was moved from the reservation function.
Though the newdq side is entirely dqtrx manipulations so I don't
think it matters much.  Thanks for the review!

--D

> Otherwise loooks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
