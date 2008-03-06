Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 22:19:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m266JNsU028769
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 22:19:27 -0800
Date: Thu, 6 Mar 2008 17:19:41 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [REVIEW] mkfs.xfs man page needs the default settings updated, TAKE 2.
Message-ID: <20080306061941.GH155407@sgi.com>
References: <ncc8x0zhwxw.fsf@sgi.com> <47CD6D0E.3090301@sandeen.net> <47CD6ED7.5050505@sandeen.net> <ncczltcfoqu.fsf_-_@sgi.com> <47CF8127.40900@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF8127.40900@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Wed, Mar 05, 2008 at 11:29:11PM -0600, Eric Sandeen wrote:
> Niv Sardi wrote:
> > Thanks to Eric for the comments, is this better ?
> > 
> > Cheers,
> > 
> > -- Niv Sardi
> > 
> > 
> > 
> > From 7e0e328663858ecf13f35678f1a6d349c3d4dd5a Mon Sep 17 00:00:00 2001
> > From: Niv Sardi <xaiki@sgi.com>
> > Date: Fri, 22 Feb 2008 16:48:32 +1100
> > Subject: [PATCH] Update mkfs manpage for new defaults:
> > 
> > log, attr and inodes v2,
> > Drop the ability to turn unwritten extents off completly,
> > reduce imaxpct for big filesystems, less AGs for single disks configs.
> > ---
> >  xfsprogs/man/man8/mkfs.xfs.8 |   41 ++++++++++++++++++-----------------------
> >  1 files changed, 18 insertions(+), 23 deletions(-)
> > 
> > diff --git a/xfsprogs/man/man8/mkfs.xfs.8 b/xfsprogs/man/man8/mkfs.xfs.8
> > index b6024c3..afc284c 100644
> > --- a/xfsprogs/man/man8/mkfs.xfs.8
> > +++ b/xfsprogs/man/man8/mkfs.xfs.8
> > @@ -304,10 +304,16 @@ bits.
> >  This specifies the maximum percentage of space in the filesystem that
> >  can be allocated to inodes. The default
> >  .I value
> > -is 25%. Setting the
> > +is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
> > +for filesystems over 50TB. Setting the
> >  .I value
> > -to 0 means that essentially all of the filesystem can
> > -become inode blocks.
> > +to 0 means that essentially all of the filesystem can become inode
> > +blocks. Note that this is only used by inode32 (on 32bits platforms),
> > +and is ignored on 64bits platforms. 
> 
> Really?  The m_maxicount tests in xfs_ialloc_ag_alloc and xfs_dialloc
> don't seem to care about inode32 or not, unless I'm missing something.

See xfs_set_maxicount() and then how it is used in xfs_initialize_perag()
to set up pag->pagi_inodeok, pag->pagf_metadata and mp->m_maxagi which
are used by the allocator....

> How about...
> 
> maxpct=value
> 	This specifies the maximum percentage of space in the
> 	filesystem that can be allocated to  inodes. The
> 	default value is 25% for filesystems under 1TB, 5% for
> 	filesystems under 50TB and 1% for filesystems over 50TB.
> 
> 	In the default inode allocation mode, inode blocks are
> 	chosen such that inode numbers will not exceed 32 bits,
> 	which restricts the inode blocks to the lower portion of
> 	the filesystem.  The data block allocator will avoid these
> 	low blocks to accommodate the specified maxpct, so a high
> 	value may result in a filesystem with nothing but inodes
> 	in a significant portion of the lower blocks of the
> 	filesystem.  (This restriction is not present when
> 	the filesystem is mounted with the "inode64" option on
> 	64-bit platforms).
> 
> 	Setting the value to 0 means that essentially all of the
> 	filesystem can become inode blocks, subject to inode32
> 	restrictions.
> 
> 	This value can be modified with xfs_growfs(8).
> 
> eh... could be better... but how's it sound?

Much better.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
