Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728224AbfEMPqN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 May 2019 11:46:13 -0400
Date: Mon, 13 May 2019 11:46:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/6] xfs: refactor by-size extent allocation mode
Message-ID: <20190513154610.GF61135@bfoster>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-6-bfoster@redhat.com>
 <20190510173413.GD18992@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510173413.GD18992@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 10:34:13AM -0700, Christoph Hellwig wrote:
> > @@ -724,8 +723,6 @@ xfs_alloc_ag_vextent(
> >  	args->wasfromfl = 0;
> >  	switch (args->type) {
> >  	case XFS_ALLOCTYPE_THIS_AG:
> > -		error = xfs_alloc_ag_vextent_size(args);
> > -		break;
> >  	case XFS_ALLOCTYPE_NEAR_BNO:
> >  	case XFS_ALLOCTYPE_THIS_BNO:
> >  		error = xfs_alloc_ag_vextent_type(args);
> > @@ -817,6 +814,8 @@ xfs_alloc_cur_setup(
> >  
> >  	if (args->agbno != NULLAGBLOCK)
> >  		agbno = args->agbno;
> > +	if (args->type == XFS_ALLOCTYPE_THIS_AG)
> > +		acur->cur_len += args->alignment - 1;
> 
> At this point we can just kill that switch, or even better
> merge xfs_alloc_ag_vextent_type and xfs_alloc_ag_vextent.

Yeah, we can probably replace that switch with a simple assert on the
allocation type.

WRT to merging the functions, I'm a little concerned about the result
being too large. What do you think about folding in _vextent_type() but
at the same time factoring out the rmap/counter/resv post alloc bits
into an xfs_alloc_ag_vextent_accounting() helper or some such?

Brian
