Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 06:20:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m98DKZY0022542
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 06:20:35 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8334613B8A74
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 06:22:14 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id LkE5U0xB1Hl5N5w3 for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 06:22:14 -0700 (PDT)
Date: Wed, 8 Oct 2008 15:22:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] kill xfs_dinode_core_t
Message-ID: <20081008132212.GF25392@lst.de>
References: <20081007202201.GC16485@lst.de> <20081007213610.GV30001@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007213610.GV30001@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Oct 08, 2008 at 08:36:10AM +1100, Dave Chinner wrote:
> >  	switch (dic->di_format) {
> >  	case XFS_DINODE_FMT_DEV:
> > -		buf->dt_rdev = be32_to_cpu(dip->di_u.di_dev);
> > +		buf->dt_rdev = be32_to_cpu(*(__be32 *)XFS_DFORK_DPTR(mp, dic));
> 
> That's not particularly obvious where the rdev value is stored.
> Perhaps a comment indicating that it's a direct dereference out
> of the start of the data area in the inode?

Yeah.  Or maybe I should add a nice accessor that does the casting
and endianess conversion.

> > +#define XFS_DINODE_CORE_SIZE(mp)	(96)
> > +#define XFS_DINODE_SIZE(mp)		(96 + sizeof(__be32))
> 
> probably shouldn't hard-code the second "96" there. Perhaps
> the XFS_DINODE_SIZE() macro should be a sizeof(xfs_dinode_t)?

Well, that will change once xfs_dinode grows.  But we could do it for
now and then use offsetoff of the first new member for the old one.

I'll see if I can find a way to make this a little more clear.
