Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 18:09:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B19Nh2016302
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:09:23 -0700
Date: Fri, 11 Jul 2008 03:10:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] simplify xfs_setattr
Message-ID: <20080711011017.GA20486@lst.de>
References: <20080627154557.GB31476@lst.de> <20080705172021.GA7177@lst.de> <48747DAD.7060501@sgi.com> <20080709162914.GA16308@lst.de> <4876AA39.804@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4876AA39.804@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jul 11, 2008 at 10:32:57AM +1000, Timothy Shimmin wrote:
> Hmm...confusing re NO_BLOCK.
> 
> 1 linux-2.6/xfs_vnode.h <global>           228 #define ATTR_NONBLOCK 0x100
> 2 linux-2.6/xfs_ioctl.c xfs_ioc_space      686 attr_flags |= ATTR_NONBLOCK;
> 3 linux-2.6/xfs_ioctl.c xfs_ioc_fssetxattr 899 attr_flags |= ATTR_NONBLOCK;
> 4 linux-2.6/xfs_ioctl.c xfs_ioc_setxflags  951 attr_flags |= ATTR_NONBLOCK;
> 5 linux-2.6/xfs_iops.c  xfs_vn_setattr     703 flags |= ATTR_NONBLOCK;
> 
> 1 xfs/xfs_dmapi.h    <global>     169 #define AT_DELAY_FLAG(f) ((f&ATTR_NONBLOCK) ? DM_FLAGS_NDELAY : 0)
> 2 xfs/xfs_vnodeops.c xfs_setattr          200 int dmflags = AT_DELAY_FLAG(flags) | DM_SEM_FLAG_WR;
> 3 xfs/xfs_vnodeops.c xfs_setattr          757 0, 0, AT_DELAY_FLAG(flags));
> 4 xfs/xfs_vnodeops.c xfs_free_file_space 3536 AT_DELAY_FLAG(attr_flags), NULL);
> 
> So it's just used for dmapi stuff as it only looks like it is tested by
> AT_DELAY_FLAG().
> So for xfs_setattr it will be expecting it coming in as flags param
> and then testing it via AT_DELAY_FLAG.
> Hmmm...doesn't seem so good. So looks like it was handled by
> xfs_setattr and still is.
> So are we going to be doing the right thing now?
> If it could just never be set then what is the point of using
> AT_DELAY_FLAG() in xfs_setattr?

We scan till set XFS_ATTR_NONBLOCK, just not coming from xfs_vn_setattr.
Currently that's only done in xfs_ioc_space.

> 
> 
> >> So we get rid of the test for XFS_AT_NOSET.
> >> where:
> >> #define XFS_AT_NOSET    (XFS_AT_NLINK|XFS_AT_RDEV|XFS_AT_FSID|XFS_AT_NODEID|\
> >>                 XFS_AT_TYPE|XFS_AT_BLKSIZE|XFS_AT_NBLOCKS|XFS_AT_VCODE|\
> >>                 XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|XFS_AT_GENCOUNT)
> >>
> >> I can't see anywhere we set any of these.
> >> Presumably out of the xattr calls.
> >> Some left over from IRIX I guess.
> > 
> > Probably.  Note that linux uses the ATTR_ flags only for ->setattr so
> > there are per defintion none that can't be set.
> > 
> Which is nice.
> 
> >> #define XFS_AT_UPDATIME         0x00010000
> >> #define XFS_AT_UPDMTIME         0x00020000
> >> #define XFS_AT_UPDCTIME         0x00040000
> >> 3 more not supported by vfs ATTR_* macros.
> >> I can't see where we set any of these.
> >> So no loss there I guess.
> >> Presumably they were just for IRIX.
> > 
> > It's an IRIX leftover.  I will submit a patch to introduce something
> > similar to Linux for 2.6.27, that's why I'd like these patches in for
> > 2.6.26 so that I have a clean base to start from.
> Ok.
> 
> --Tim
---end quoted text---
