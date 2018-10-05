Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34158 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbeJFBR0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 21:17:26 -0400
Date: Fri, 5 Oct 2018 11:17:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: move the define for superblock magic to uapi
Message-ID: <20181005181726.GZ19324@magnolia>
References: <20181005122741.5100-1-kilobyte@angband.pl>
 <20181005160600.GR19324@magnolia>
 <20181005181032.pal6fwt7ebijvqu4@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181005181032.pal6fwt7ebijvqu4@angband.pl>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 08:10:32PM +0200, Adam Borowski wrote:
> On Fri, Oct 05, 2018 at 09:06:00AM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 05, 2018 at 02:27:41PM +0200, Adam Borowski wrote:
> > > Needed by users of fstatfs().
> > 
> > NAK.
> > 
> > The XFS superblock magic number is part of the on-disk format definition
> > of XFS. It belongs with all the other on-disk format definitions in this
> > file.
> > 
> > I don't think it's a good idea for userspace to associate s_magic with
> > userspace API feature sets, though the cat's long escaped the bag on
> > that one.
> > 
> > With that being reality, "the XFS superblock magic number" has a
> > different semantic meaning than "the agreed upon statfs.f_type value for
> > XFS", which means the latter should have a different symbol name to
> > reflect that difference.
> 
> Ie, you'd be ok with the same value to be defined in two places -- do I
> understand this right?

I'd be fine with it, but let's see what the other XFS maintainers think.
I still don't like the practice of inferring behaviors from magic
numbers, but at least we'd decouple the disk format from the UABI. :)

> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > -#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
> > > +#define	XFS_SB_MAGIC		XFS_SUPER_MAGIC /* 0x58465342 = 'XFSB' */
> > > --- a/include/uapi/linux/magic.h
> > >  #define JFFS2_SUPER_MAGIC	0x72b6
> > > +#define XFS_SUPER_MAGIC		0x58465342	/* "XFSB" */
> > >  #define PSTOREFS_MAGIC		0x6165676C

You'd change xfs_fs_fill_super and xfs_fs_statfs too, right?

--D

> 
> 
> Meow!
> -- 
> ⢀⣴⠾⠻⢶⣦⠀ 
> ⣾⠁⢰⠒⠀⣿⡁ 10 people enter a bar: 1 who understands binary,
> ⢿⡄⠘⠷⠚⠋⠀ 1 who doesn't, D who prefer to write it as hex,
> ⠈⠳⣄⠀⠀⠀⠀ and 1 who narrowly avoided an off-by-one error.
