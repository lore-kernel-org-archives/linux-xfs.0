Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:10807 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbeJaFuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 01:50:39 -0400
Date: Wed, 31 Oct 2018 07:55:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] repair: parallelise phase 6
Message-ID: <20181030205533.GR19305@dastard>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-8-david@fromorbit.com>
 <20181030175158.GL4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030175158.GL4135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:51:58AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 30, 2018 at 10:20:43PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > +static void
> > +traverse_function(
> > +	struct workqueue	*wq,
> > +	xfs_agnumber_t		agno,
> > +	void			*arg)
> > +{
> > +	struct ino_tree_node	*irec;
> >  	prefetch_args_t		*pf_args = arg;
> > +	struct workqueue	lwq;
> > +	struct xfs_mount	*mp = wq->wq_ctx;
> > +
> >  
> >  	wait_for_inode_prefetch(pf_args);
> >  
> >  	if (verbose)
> >  		do_log(_("        - agno = %d\n"), agno);
> >  
> > +	/*
> > +	 * The more AGs we have in flight at once, the fewer processing threads
> > +	 * per AG. This means we don't overwhelm the machine with hundreds of
> > +	 * threads when we start acting on lots of AGs at once. We just want
> > +	 * enough that we can keep multiple CPUs busy across multiple AGs.
> > +	 */
> > +	workqueue_create_bound(&lwq, mp, ag_stride, 1000);
> 
> Unlikely to happen, but do we need to check for errors here?
> create_work_queue aborts repair if workqueue_create fails.

Yup, will fix.


-- 
Dave Chinner
david@fromorbit.com
