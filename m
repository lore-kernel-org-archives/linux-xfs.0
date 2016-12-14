Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16562 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754334AbcLNSj6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2016 13:39:58 -0500
Date: Wed, 14 Dec 2016 10:38:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] duperemove: test presence of dedupe ioctl
Message-ID: <20161214183845.GA5357@birch.djwong.org>
References: <20161209175645.GB16813@birch.djwong.org>
 <20161214104436.GB16862@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214104436.GB16862@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: mfasheh@versity.com, xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Wed, Dec 14, 2016 at 02:44:36AM -0800, Christoph Hellwig wrote:
> On Fri, Dec 09, 2016 at 09:56:45AM -0800, Darrick J. Wong wrote:
> > Since a zero-length dedupe operation is guaranteed to succeed, use that
> > to test whether or not this filesystem supports dedupe.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  file_scan.c |   47 +++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 37 insertions(+), 10 deletions(-)
> > 
> > diff --git a/file_scan.c b/file_scan.c
> > index 617f166..a34453e 100644
> > --- a/file_scan.c
> > +++ b/file_scan.c
> > @@ -45,11 +45,7 @@
> >  #include "file_scan.h"
> >  #include "dbfile.h"
> >  #include "util.h"
> > -
> > -/* This is not in linux/magic.h */
> > -#ifndef	XFS_SB_MAGIC
> > -#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
> > -#endif
> > +#include "btrfs-ioctl.h"
> >  
> >  static char path[PATH_MAX] = { 0, };
> >  static char *pathp = path;
> > @@ -189,6 +185,39 @@ static int walk_dir(const char *name)
> >  	return ret;
> >  }
> >  
> > +struct fake_btrfs_ioctl_same_args {
> > +	struct btrfs_ioctl_same_args args;
> > +	struct btrfs_ioctl_same_extent_info info;
> > +};
> 
> Why does this need a fake structure here?

In order to test the ioctl we have to fill out at least one
btrfs_ioctl_same_extent_info so that we get far enough into the fs-specific
dedupe_range handler that we've verified that the fs is capable of dedupe and
that the fs is willing to try to satisfy the request.

We could just malloc sizeof(_same_args) + sizeof(_same_extent_info)...

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
