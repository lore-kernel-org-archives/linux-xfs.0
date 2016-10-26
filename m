Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49912 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752215AbcJZBNO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 21:13:14 -0400
Date: Tue, 25 Oct 2016 18:13:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/39] xfs_db: add support for checking the refcount btree
Message-ID: <20161026011308.GC23568@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743667991.11035.9533585332530820648.stgit@birch.djwong.org>
 <20161026004920.GD23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026004920.GD23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 11:49:20AM +1100, Dave Chinner wrote:
> On Tue, Oct 25, 2016 at 04:04:39PM -0700, Darrick J. Wong wrote:
> > Do some basic checks of the refcount btree.  xfs_repair will have to
> > check that the reference counts match the various bmbt mappings.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> > @@ -1561,10 +1597,15 @@ check_set_dbmap(
> >  			agbno, agbno + len - 1, c_agno, c_agbno);
> >  		return;
> >  	}
> > -	check_dbmap(agno, agbno, len, type1);
> > +	check_dbmap(agno, agbno, len, type1, is_reflink(type2));
> >  	mayprint = verbose | blist_size;
> >  	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
> > -		*p = (char)type2;
> > +		if (*p == DBM_RLDATA && type2 == DBM_DATA)
> > +			;	/* do nothing */
> > +		if (*p == DBM_DATA && type2 == DBM_DATA)
> > +			*p = (char)DBM_RLDATA;
> > +		else
> > +			*p = (char)type2;
> 
> What this /* do nothing */ case for?

Handles the case that a data block with multiple owners encounters
another owner.  The second case in the block handles the case that
a data block with a single owner encounters a second owner.

(Assuming you're prodding me to add a comment, I'll go do that.)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
