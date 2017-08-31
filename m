Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbdHaMnX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 08:43:23 -0400
Date: Thu, 31 Aug 2017 08:43:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Message-ID: <20170831124321.GA21939@bfoster.bfoster>
References: <20170830145400.3681-1-hch@lst.de>
 <20170831064033.GF3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831064033.GF3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 11:40:33PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 30, 2017 at 04:54:00PM +0200, Christoph Hellwig wrote:
> > But reject reflink + DAX file systems for now until the code to
> > support reflinks on DAX is actually implemented.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_super.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 38aaacdbb8b3..92521032468e 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1634,7 +1634,9 @@ xfs_fs_fill_super(
> >  		}
> >  		if (xfs_sb_version_hasreflink(&mp->m_sb))
> >  			xfs_alert(mp,
> > -		"DAX and reflink have not been tested together!");
> > +		"DAX and reflink can not be used together!");
> > +			error = -EINVAL;
> > +			goto out_filestream_unmount;
> 
> /This/ hunk seems fine, but...
> 
> >  	}
> >  
> >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > @@ -1648,10 +1650,6 @@ xfs_fs_fill_super(
> >  	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
> >  	}
> >  
> > -	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > -		xfs_alert(mp,
> > -	"EXPERIMENTAL reflink feature enabled. Use at your own risk!");
> > -
> 
> ...I frankly would rather wait until we land and stabilize the incore
> extent rework, because I'd rather not have the reflink story be: 1) we
> declare reflink stable in 4.14; 2) immediately people start loading up
> XFSes with sparse VM images that blow up on high order allocations and
> then 3) we get a whole lot of complaints about it.  Then in 4.15 we 4)
> land the incore extent map only now we're dragging those same users
> through the mud while /that/ stabilizes, with the result 5) that
> everyone thinks we've gone off the deep end and doesn't trust us
> anymore.
> 
> I wish that didn't also mean waiting another 6 months for something that
> none of us /developers/ have seen in practice, especially since the
> enterprise distros will have plenty of time to backport all this stuff
> before their next big releases if it /does/ become a problem.  It's fine
> enough for me (and Christoph's customers, evidently) but is that enough?
> 
> <shrug> Not sure what to do about my own fear factor. :)  Anyone want to
> offer further comments?  A quick git history trip says sparse inodes
> took about 13 months to go from initial commit to EXPERIMENTAL removed?
> 

FWIW, I don't really have a strong opinion. To me, removing experimental
means we feel the code has stabilized long enough in principle, there
are no significant problems (i.e., corruption/crash vectors) that we are
aware of and the feature is complete (full userspace tool support, etc).
The in-core extent list thing seems like more of a general problem to me
so I have no objection to removing the experimental tag from reflink if
that's really the only known drawback. Of course, I don't object if
there's developer preference to keep it for another cycle or two either.

That aside, shouldn't we consider the rmapbt experimental tag first, or
at least at the same time? It's been around for slightly longer.

Brian

> --D
> 
> >  	error = xfs_mountfs(mp);
> >  	if (error)
> >  		goto out_filestream_unmount;
> > -- 
> > 2.11.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
