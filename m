Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 03:49:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5PAnMdo010255
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 03:49:24 -0700
Date: Mon, 25 Jun 2007 20:49:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] remove hard-coded fnames from tracing functions
Message-ID: <20070625104914.GB31489@sgi.com>
References: <467F48B9.7060504@sandeen.net> <467F4A2F.2060101@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467F4A2F.2060101@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Jun 24, 2007 at 11:53:03PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > This has been on my stack a while, still compiles clean but feel free
> > to double-check. :-)
> > 
> >  xfs_alloc.c      |   53 ++--------
> >  xfs_bmap.c       |  266 +++++++++++++++++++++++--------------------------------
> >  xfs_bmap.h       |    6 -
> >  xfs_bmap_btree.c |   88 +++---------------
> >  xfs_inode.c      |    8 -
> >  5 files changed, 149 insertions(+), 272 deletions(-)
> > 
> > ---------------
> > 
> > Remove the hardcoded "fnames" for tracing, and just embed
> > them in tracing macros via __FUNCTION__.  Kills a lot of #ifdefs
> > too.
> 
> Hm... guess I did send this one already, but don't see it in cvs...
> Dave, is it in your stack yet?

<sigh>

It got as far as my incoming directory. I even remember reviewing it,
and then I forgot to import the patch. My bad.

I'll add it now.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
