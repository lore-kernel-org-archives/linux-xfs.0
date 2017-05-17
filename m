Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34533 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751531AbdEQMPW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 May 2017 08:15:22 -0400
Date: Wed, 17 May 2017 14:15:19 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] xfs: Move handling of missing page into one place in
 xfs_find_get_desired_pgoff()
Message-ID: <20170517121519.GA2630@quack2.suse.cz>
References: <20170511165023.29887-1-jack@suse.cz>
 <20170511165023.29887-2-jack@suse.cz>
 <20170512162302.GG4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170512162302.GG4519@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org

On Fri 12-05-17 09:23:02, Darrick J. Wong wrote:
> On Thu, May 11, 2017 at 06:50:23PM +0200, Jan Kara wrote:
> > Currently several places in xfs_find_get_desired_pgoff() handle the case
> > of a missing page. Make them all handled in one place after the loop has
> > terminated.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_file.c | 24 ++++++++----------------
> >  1 file changed, 8 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index df51c025adfe..719923b99ba1 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1069,10 +1069,6 @@ xfs_find_get_desired_pgoff(
> >  				break;
> >  
> >  			ASSERT(type == HOLE_OFF);
> > -			if (lastoff == startoff || lastoff < endoff) {
> > -				found = true;
> > -				*offset = lastoff;
> > -			}
> >  			break;
> >  		}
> 
> Hm.  This leaves the following weird looking hunk:
> 
> if (nr_pages == 0) {
> 	/* Data search found nothing */
> 	if (type == DATA_OFF)
> 		break;
> 
> 	ASSERT(type == HOLE_OFF);
> 	break;
> }
> 
> Which could be simplified to:
> 
> if (nr_pages == 0) {
> 	ASSERT(type == HOLE_OFF || type == DATA_OFF);
> 	break;
> }
> 
> Right?  Maybe a better cleanup would be to name the enum defining
> {HOLE,DATA}_OFF and change the xfs_find_get_desired_pgoff prototype to
> use that enum, and then we also get compiler type checking.

Well, given this function is called only from one place, enum looks like an
overkill and even the assert is weird. I've just simplified the condition
to:

if (nr_pages == 0)
	break;

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
