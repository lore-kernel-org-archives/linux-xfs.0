Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44498 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfANUbL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jan 2019 15:31:11 -0500
Date: Mon, 14 Jan 2019 12:31:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/5] xfs: fix off-by-one error in rtbitmap cross-reference
Message-ID: <20190114203104.GK21010@magnolia>
References: <154697976479.2839.3584921201780682011.stgit@magnolia>
 <154697978351.2839.11888108672644284957.stgit@magnolia>
 <20190111151053.GB30640@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111151053.GB30640@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Fri, Jan 11, 2019 at 10:10:54AM -0500, Brian Foster wrote:
> On Tue, Jan 08, 2019 at 12:36:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix an off-by-one error in the realtime bitmap "is used" cross-reference
> > helper function.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/rtbitmap.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> > index 665d4bbb17cc..5402211f980b 100644
> > --- a/fs/xfs/scrub/rtbitmap.c
> > +++ b/fs/xfs/scrub/rtbitmap.c
> > @@ -143,7 +143,7 @@ xchk_xref_is_used_rt_space(
> >  	do_div(startext, sc->mp->m_sb.sb_rextsize);
> >  	if (do_div(endext, sc->mp->m_sb.sb_rextsize))
> >  		endext++;
> > -	extcount = endext - startext;
> > +	extcount = endext - startext + 1;
> 
> I'm not terribly familiar with rt code, but isn't the above endext++
> also rounding this up in some cases?

Yep.  Sorry for the drain bamage, this ought to be:

	startext = fsbno;
	endext = fsbno + len - 1;
	do_div(startext, sc->mp->m_sb.sb_rextsize);
	do_div(endext, sc->mp->m_sb.sb_rextsize);
	extcount = endext - startext + 1;

--D

> Brian
> 
> >  	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
> >  	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
> >  			&is_free);
> > 
