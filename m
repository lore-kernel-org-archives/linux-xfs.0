Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:8890 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726258AbeJFGlK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 02:41:10 -0400
Date: Sat, 6 Oct 2018 09:40:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: move the define for superblock magic to uapi
Message-ID: <20181005234009.GJ12041@dastard>
References: <20181005122741.5100-1-kilobyte@angband.pl>
 <20181005160600.GR19324@magnolia>
 <20181005181032.pal6fwt7ebijvqu4@angband.pl>
 <20181005182356.GA19324@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005182356.GA19324@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Adam Borowski <kilobyte@angband.pl>, linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 11:23:56AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 05, 2018 at 08:10:32PM +0200, Adam Borowski wrote:
> > On Fri, Oct 05, 2018 at 09:06:00AM -0700, Darrick J. Wong wrote:
> > > On Fri, Oct 05, 2018 at 02:27:41PM +0200, Adam Borowski wrote:
> > > > Needed by users of fstatfs().
> > > 
> > > NAK.
> > > 
> > > The XFS superblock magic number is part of the on-disk format definition
> > > of XFS. It belongs with all the other on-disk format definitions in this
> > > file.
> > > 
> > > I don't think it's a good idea for userspace to associate s_magic with
> > > userspace API feature sets, though the cat's long escaped the bag on
> > > that one.
> > > 
> > > With that being reality, "the XFS superblock magic number" has a
> > > different semantic meaning than "the agreed upon statfs.f_type value for
> > > XFS", which means the latter should have a different symbol name to
> > > reflect that difference.
> > 
> > Ie, you'd be ok with the same value to be defined in two places -- do I
> > understand this right?
> > 
> > > > --- a/fs/xfs/libxfs/xfs_format.h
> > > > -#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
> > > > +#define	XFS_SB_MAGIC		XFS_SUPER_MAGIC /* 0x58465342 = 'XFSB' */
> > > > --- a/include/uapi/linux/magic.h
> > > >  #define JFFS2_SUPER_MAGIC	0x72b6
> > > > +#define XFS_SUPER_MAGIC		0x58465342	/* "XFSB" */
> > > >  #define PSTOREFS_MAGIC		0x6165676C
> 
> Sorry, hit send too fast.
> 
> include/uapi/linux/magic.h would get:
> 
> #define XFS_STATFS_MAGIC	0x58465342	/* 'XFSB' */

$ man statfs |grep 0x5846
           XFS_SUPER_MAGIC       0x58465342
$

-Dave.
-- 
Dave Chinner
david@fromorbit.com
