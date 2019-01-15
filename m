Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48940 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731673AbfAOTc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 14:32:29 -0500
Date: Tue, 15 Jan 2019 11:32:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/5] xfs: fix off-by-one error in rtbitmap
 cross-reference
Message-ID: <20190115193222.GD12689@magnolia>
References: <154697976479.2839.3584921201780682011.stgit@magnolia>
 <154697978351.2839.11888108672644284957.stgit@magnolia>
 <20190114203201.GA12689@magnolia>
 <20190115104954.GA23423@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115104954.GA23423@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Jan 15, 2019 at 05:49:54AM -0500, Brian Foster wrote:
> On Mon, Jan 14, 2019 at 12:32:01PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix an off-by-one error in the realtime bitmap "is used" cross-reference
> > helper function if the realtime extent size is a single block.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for reviewing this series!

--D

> >  fs/xfs/scrub/rtbitmap.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> > index 665d4bbb17cc..dbe115b075f7 100644
> > --- a/fs/xfs/scrub/rtbitmap.c
> > +++ b/fs/xfs/scrub/rtbitmap.c
> > @@ -141,9 +141,8 @@ xchk_xref_is_used_rt_space(
> >  	startext = fsbno;
> >  	endext = fsbno + len - 1;
> >  	do_div(startext, sc->mp->m_sb.sb_rextsize);
> > -	if (do_div(endext, sc->mp->m_sb.sb_rextsize))
> > -		endext++;
> > -	extcount = endext - startext;
> > +	do_div(endext, sc->mp->m_sb.sb_rextsize);
> > +	extcount = endext - startext + 1;
> >  	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
> >  	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
> >  			&is_free);
