Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39879 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755291AbeAIA5t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 19:57:49 -0500
Date: Tue, 9 Jan 2018 11:57:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/21] xfs: cross-reference with the bnobt
Message-ID: <20180109005744.GI16421@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398985848.18741.1443595678961710395.stgit@magnolia>
 <20180108235125.GG16421@dastard>
 <20180109003441.GB5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109003441.GB5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 08, 2018 at 04:34:41PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 09, 2018 at 10:51:25AM +1100, Dave Chinner wrote:
> > On Fri, Dec 22, 2017 at 04:44:18PM -0800, Darrick J. Wong wrote:
> > > +	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
> > > +	if (error)
> > > +		return;
> > > +
> > > +	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
> > > +
> > > +	/* Check agf_freeblks */
> > > +	pcur = &sc->sa.bno_cur;
> > > +	if (*pcur) {
> > > +		blocks = 0;
> > > +		error = xfs_alloc_query_all(*pcur,
> > > +				xfs_scrub_agf_record_bno_lengths, &blocks);
> > > +		if (xfs_scrub_should_xref(sc, &error, pcur) &&
> > > +		    blocks != be32_to_cpu(agf->agf_freeblks))
> > > +			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
> > > +	}
> > 
> > I have no idea what xfs_scrub_should_xref() means in this context.
> > We're doing a xref scrub, so why are we asking if we should be
> > running a xref?
> 
> Given that we tried to retrieve some data from some other data
> structure, the function xfs_scrub_should_xref decides if we should
> actually bother with the comparison checks?   In other words, if the
> xfs_alloc_query_all returned an error code then we need to delete *pcur
> and we can skip the "blocks != be32..." check since it makes no sense.
> 
> How about xfs_scrub_should_check_xref?

Yes, that makes more sense.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
