Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 13:22:52 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JKMguw006205
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 13:22:46 -0700
Date: Wed, 19 Sep 2007 22:22:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill XFS_INOBT_IS_FREE_DISK
Message-ID: <20070919202239.GA32475@lst.de>
References: <20070919161202.GA18130@lst.de> <46F16752.1090702@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F16752.1090702@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Sep 19, 2007 at 01:15:46PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > This macro is unused an all other acros in this family operate on native
> > types, so we most likely won't grow a user either.
> 
> Looks good to me... FWIW, here are the currently-unused macros in xfs
> cvs, if I'm massaging it right:
> 
> _ACL_ACCESS_EXISTS
> _ACL_GET_ACCESS

> SGI_ACL_DEFAULT_SIZE

will go away with conversion to generic posix acl code.

> ATTR_DONTFOLLOW
> ATTR_TRUST

might go away with conversion to generic xattr code.

> BMBT_USE_64

I have a patch for this one.

> CE_CONT
> current_clear_flags_nested
> FSYNC_INVAL
> FSYNC_NOWAIT

We should probably kill these.

> HAVE_DM_EVENTTYPE_T
> HAVE_DM_RIGHT_T

no idea for these.

> HAVE_SPLICE


Backward compat?

> MODEMASK
> NDPP

kill?

> nested_spinlock
> nested_spinunlock

don't your patches kill these?

> SV_KEYED
> SV_LIFO
> SV_PRIO
> sv_timedwait
> sv_timedwait_sig
> sv_wait_sig


should probably go.

> TRACE0
> TRACE1
> TRACE3

kill?

> VN_ISBLK
> VN_ISCHR
> VN_ISLNK
> VREAD
> VSUID
> VSVTX
> VWRITE

I have a patch to kill all this gunk.

> XFS_AT_ALL
> XFS_AT_SIZE_NOPERM
> XFS_AT_TIMES

I have some patches patch to kill XFS_AT_*

> XFS_DFORK_ASIZE_HOST
> XFS_DFORK_DSIZE_HOST

I have some patches to rework XFS_{C,D,I}FORK*

> XB_GET_OWNER
> xfs_buf_ctob
> XFS_BUF_ISORDERED
> XFS_BUF_ISWRITE
> XFS_BUF_OFFSET
> XFS_BUF_SET_OFFSET
> XFS_BUF_SET_SIZE
> XFS_BUF_UNBUSY
> XFS_BUF_VSEMA

not sure what to do with all the buf stuff.

> XFS_IO_DCXVN
> XFS_IOMAP_WRITE_UNWRITTEN

should be gone with the patches I sent to the list.

> xfs_probe_dmapi
> xfs_probe_ioops
> xfs_probe_quota

these are gone in a patch that I sent to the list already.

> XFS_SBF_NOFLAGS
> XFS_SB_VERSION2_REALFBITS
> XFS_SB_VERSION2_RESERVED1BIT
> XFS_SB_VERSION2_RESERVED4BIT
> XFS_SB_VERSION_ADDDALIGN
> XFS_SB_VERSION_ADDEXTFLGBIT
> XFS_SB_VERSION_ADDSHARED
> XFS_SB_VERSION_SUBEXTFLGBIT
> XFS_SB_VERSION_SUBSHARED

I suspect there are kind expected to be unused.
