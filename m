Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59930 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753505AbeEAQZv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 12:25:51 -0400
Date: Tue, 1 May 2018 09:25:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: pass xfs_dqblk to
 xfs_dquot_verify/xfs_dquot_repair
Message-ID: <20180501162510.GJ4127@magnolia>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
 <20180405071412.GB17256@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180405071412.GB17256@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Apr 05, 2018 at 12:14:12AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 04, 2018 at 01:54:26PM -0500, Eric Sandeen wrote:
> > In order to validate the UUID in xfs_dquot_verify, we need
> > the full xfs_qblk, not just the xfs_disk_dquot_t (which is
> > a subset).
> > 
> > Do the same for xfs_dquot_repair, for the same reasons.
> > Casting a xfs_disk_dquot to a xfs_qblk is risky if the source
> > pointer wasn't a full xfs_dqblk, so enforce that by changing
> > the arguments to these functions.
> > 
> > In xfs_qm_dqflush we move the memcpy up so that we have
> > a full (and updated) xfs_dqblk to test.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_dquot_buf.c  | 23 +++++++++--------------
> >  fs/xfs/libxfs/xfs_quota_defs.h |  4 ++--
> >  fs/xfs/xfs_dquot.c             | 12 +++++++-----
> >  fs/xfs/xfs_log_recover.c       |  6 ++++--
> >  fs/xfs/xfs_qm.c                |  6 +++---
> >  5 files changed, 25 insertions(+), 26 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> > index a926058..f94e8c2 100644
> > --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> > +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> > @@ -44,11 +44,13 @@
> >   */
> >  xfs_failaddr_t
> >  xfs_dquot_verify(
> > -	struct xfs_mount *mp,
> > -	xfs_disk_dquot_t *ddq,
> > -	xfs_dqid_t	 id,
> > -	uint		 type)	  /* used only when IO_dorepair is true */
> > +	struct xfs_mount	*mp,
> > +	struct xfs_dqblk	*dqb,
> > +	xfs_dqid_t		id,
> > +	uint			type)	  /* used only during quota rebuild */
> >  {
> > +	struct xfs_disk_dquot	*ddq = &dqb->dd_diskdq;
> > +
> >  	/*
> >  	 * We can encounter an uninitialized dquot buffer for 2 reasons:
> >  	 * 1. If we crash while deleting the quotainode(s), and those blks got
> > @@ -104,13 +106,10 @@
> >  int
> >  xfs_dquot_repair(
> >  	struct xfs_mount	*mp,
> > -	struct xfs_disk_dquot	*ddq,
> > +	struct xfs_dqblk	*d,
> 
> Rename this to dqblks to make it clear that it is an array?
> 
> >  		if (i == 0)
> > -			id = be32_to_cpu(ddq->d_id);
> > +			id = be32_to_cpu(d[i].dd_diskdq.d_id);
> >  
> > -		fa = xfs_dquot_verify(mp, ddq, id + i, 0);
> > +		fa = xfs_dquot_verify(mp, &d[i], id + i, 0);
> 
> Can we either use only array indices or only pointer arithmetics and
> not mix the two?  (personall I prefer the pointer arithmetics).
> 
> Functionally the patch looks fine to me.

The patch looks fine to me too, though I think Christoph's comments need
some kind of response.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
