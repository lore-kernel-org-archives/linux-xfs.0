Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F488C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 14:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 168BD20882
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 14:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbfISO6U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387407AbfISO6U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 10:58:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0E7B300D1C7;
        Thu, 19 Sep 2019 14:58:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98D1960872;
        Thu, 19 Sep 2019 14:58:19 +0000 (UTC)
Date:   Thu, 19 Sep 2019 10:58:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 03/11] xfs: track allocation busy state in allocation
 cursor
Message-ID: <20190919145817.GB35460@bfoster>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-4-bfoster@redhat.com>
 <20190918184832.GR2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918184832.GR2229799@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 19 Sep 2019 14:58:20 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 11:48:32AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 16, 2019 at 08:16:27AM -0400, Brian Foster wrote:
> > Extend the allocation cursor to track extent busy state for an
> > allocation attempt. No functional changes.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 25 ++++++++++++++-----------
> >  1 file changed, 14 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index d159377ed603..5c34d4c41761 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -716,6 +716,8 @@ struct xfs_alloc_cur {
> >  	struct xfs_btree_cur		*cnt;	/* btree cursors */
> >  	struct xfs_btree_cur		*bnolt;
> >  	struct xfs_btree_cur		*bnogt;
> > +	unsigned			busy_gen;/* busy state */
> 
> Nit: unsigned int here?
> 
> 'unsigned' without the 'int' looks a little funny to me, but eh
> whatever, I guess we do that in the iomap code so:
> 

Yeah, I was just copying from the original code and the lack of an int
didn't even register. Easy enough to fix. Note that there are still
other uses of 'unsigned busy_gen,' but those should be replaced with
this one over time..

Brian

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > +	bool				busy;
> >  };
> >  
> >  /*
> > @@ -733,6 +735,9 @@ xfs_alloc_cur_setup(
> >  
> >  	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
> >  
> > +	acur->busy = false;
> > +	acur->busy_gen = 0;
> > +
> >  	/*
> >  	 * Perform an initial cntbt lookup to check for availability of maxlen
> >  	 * extents. If this fails, we'll return -ENOSPC to signal the caller to
> > @@ -1185,8 +1190,6 @@ xfs_alloc_ag_vextent_near(
> >  	xfs_extlen_t	ltlena;		/* aligned ... */
> >  	xfs_agblock_t	ltnew;		/* useful start bno of left side */
> >  	xfs_extlen_t	rlen;		/* length of returned extent */
> > -	bool		busy;
> > -	unsigned	busy_gen;
> >  #ifdef DEBUG
> >  	/*
> >  	 * Randomly don't execute the first algorithm.
> > @@ -1211,7 +1214,6 @@ xfs_alloc_ag_vextent_near(
> >  	ltlen = 0;
> >  	gtlena = 0;
> >  	ltlena = 0;
> > -	busy = false;
> >  
> >  	/*
> >  	 * Set up cursors and see if there are any free extents as big as
> > @@ -1290,8 +1292,8 @@ xfs_alloc_ag_vextent_near(
> >  			if (error)
> >  				goto out;
> >  			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> > -			busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
> > -					&ltbnoa, &ltlena, &busy_gen);
> > +			acur.busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
> > +					&ltbnoa, &ltlena, &acur.busy_gen);
> >  			if (ltlena < args->minlen)
> >  				continue;
> >  			if (ltbnoa < args->min_agbno || ltbnoa > args->max_agbno)
> > @@ -1373,8 +1375,8 @@ xfs_alloc_ag_vextent_near(
> >  			if (error)
> >  				goto out;
> >  			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> > -			busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
> > -					&ltbnoa, &ltlena, &busy_gen);
> > +			acur.busy |= xfs_alloc_compute_aligned(args, ltbno,
> > +					ltlen, &ltbnoa, &ltlena, &acur.busy_gen);
> >  			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
> >  				break;
> >  			error = xfs_btree_decrement(acur.bnolt, 0, &i);
> > @@ -1388,8 +1390,8 @@ xfs_alloc_ag_vextent_near(
> >  			if (error)
> >  				goto out;
> >  			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> > -			busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
> > -					&gtbnoa, &gtlena, &busy_gen);
> > +			acur.busy |= xfs_alloc_compute_aligned(args, gtbno,
> > +					gtlen, &gtbnoa, &gtlena, &acur.busy_gen);
> >  			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
> >  				break;
> >  			error = xfs_btree_increment(acur.bnogt, 0, &i);
> > @@ -1449,9 +1451,10 @@ xfs_alloc_ag_vextent_near(
> >  	 */
> >  	if (!xfs_alloc_cur_active(acur.bnolt) &&
> >  	    !xfs_alloc_cur_active(acur.bnogt)) {
> > -		if (busy) {
> > +		if (acur.busy) {
> >  			trace_xfs_alloc_near_busy(args);
> > -			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> > +			xfs_extent_busy_flush(args->mp, args->pag,
> > +					      acur.busy_gen);
> >  			goto restart;
> >  		}
> >  		trace_xfs_alloc_size_neither(args);
> > -- 
> > 2.20.1
> > 
