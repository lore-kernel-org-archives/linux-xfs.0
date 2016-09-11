Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28663 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756237AbcIKS4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2016 14:56:50 -0400
Date: Sun, 11 Sep 2016 11:56:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] ioctl_xfs_ioc_getfsmap.2: document XFS_IOC_GETFSMAP
 ioctl
Message-ID: <20160911185635.GA3866@birch.djwong.org>
References: <147216758326.32321.8525481353986871349.stgit@birch.djwong.org>
 <147216760214.32321.8331561706153372268.stgit@birch.djwong.org>
 <32A3DAED-21FC-4252-B53E-3503764342E8@dilger.ca>
 <20160830190949.GA8262@birch.djwong.org>
 <20160908233806.GB30056@dastard>
 <20160909060716.GD8969@birch.djwong.org>
 <20160910000029.GI30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160910000029.GI30056@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-man@vger.kernel.org, linux-api@vger.kernel.org, xfs <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org, mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Sat, Sep 10, 2016 at 10:00:29AM +1000, Dave Chinner wrote:
> On Thu, Sep 08, 2016 at 11:07:16PM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 09, 2016 at 09:38:06AM +1000, Dave Chinner wrote:
> > > On Tue, Aug 30, 2016 at 12:09:49PM -0700, Darrick J. Wong wrote:
> > > > > I recall for FIEMAP that some filesystems may not have files aligned
> > > > > to sector offsets, and we just used byte offsets.  Storage like
> > > > > NVDIMMs are cacheline granular, so I don't think it makes sense to
> > > > > tie this to old disk sector sizes.  Alternately, the units could be
> > > > > in terms of fs blocks as returned by statvfs.st_bsize, but mixing
> > > > > units for fmv_block, fmv_offset, fmv_length is uneeded complexity.
> > > > 
> > > > Ugh.  I'd rather just change the units to bytes rather than force all
> > > > the users to multiply things. :)
> > > 
> > > Yup, units need to be either in disk addresses (i.e. 512 byte units)
> > > or bytes. If people can't handle disk addresses (seems to be the
> > > case), the bytes it should be.
> > 
> > <nod>
> > 
> > > > I'd much rather just add more special owner codes for any other
> > > > filesystem that has distinguishable metadata types that are not
> > > > covered by the existing OWN_ codes.  We /do/ have 2^64 possible
> > > > values, so it's not like we're going to run out.
> > > 
> > > This is diagnositc information as much as anything, just like
> > > fiemap is diagnostic information. So if we have specific type
> > > information, it needs to be reported accurately to be useful.
> > > 
> > > Hence I really don't care if the users and developers of other fs
> > > types don't understand what the special owner codes that a specific
> > > filesystem returns mean. i.e. it's not useful user information -
> > > only a tool that groks the specific filesystem is going to be able
> > > to anything useful with special owner codes. So, IMO, there's little
> > > point trying to make them generic or to even trying to define and
> > > explain them in the man page....
> > 
> > <shrug> I'm ok with describing generally what each special owner code
> > means.  Maybe the manpage could be more explicit about "None of these
> > codes are useful unless you're a low level filesystem tool"?
> 
> You can add that, but it doesn't address the underlying problem.
> i.e.  that we can add/change the codes, their name, meaning, etc,
> and now there's a third party man page that is incorrect and out of
> date. It's the same problem with documenting filesystem specific
> mount options in mount(8). Better, IMO, is to simple say "refer to
> filesystem specific documentation for a description of these special
> values". e.g. refer them to the XFS Filesystem Structure
> document where this is all spelled out in enough detail to be useful
> for someone thinking that they might want to use them....

We could simply put a manpage in the xfsprogs source documenting the XFS
owner codes and let other implementers make their own manpage with a
discussion of the owner codes (and whatever other quirks they have).
Sort of fragments things, but that's probably unavoidable. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
