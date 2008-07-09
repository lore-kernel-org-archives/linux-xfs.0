Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 09:28:28 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69GSOlD003565
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 09:28:25 -0700
Date: Wed, 9 Jul 2008 18:29:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] simplify xfs_setattr
Message-ID: <20080709162914.GA16308@lst.de>
References: <20080627154557.GB31476@lst.de> <20080705172021.GA7177@lst.de> <48747DAD.7060501@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48747DAD.7060501@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 09, 2008 at 06:58:21PM +1000, Timothy Shimmin wrote:
> > -	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET))
> > -		flags |= ATTR_UTIME;
> > -#ifdef ATTR_NO_BLOCK
> > -	if ((ia_valid & ATTR_NO_BLOCK))
> > -		flags |= ATTR_NONBLOCK;
> > -#endif
> > -
> 
> So this code looks different.
> We are now dropping the flags. Why is that?
> Presumably because we were mapping ia_valid's:
>    ATTR_MTIME_SET or ATTR_ATIME_SET --> ATTR_UTIME
>    ATTR_NO_BLOCK -> ATTR_NONBLOCK
> But now we pass ATTR_?TIME_SET and ATTR_NO_BLOCK straight thru.
> So previously we didn't map them onto va_mask bits but as separate flags
> instead.

Yeah, not that ATTR_NO_BLOCK doesn't actually exist in any tree I have
access to, and thus it's not actually handled in the new xfs_setattr.

> So we get rid of the test for XFS_AT_NOSET.
> where:
> #define XFS_AT_NOSET    (XFS_AT_NLINK|XFS_AT_RDEV|XFS_AT_FSID|XFS_AT_NODEID|\
>                 XFS_AT_TYPE|XFS_AT_BLKSIZE|XFS_AT_NBLOCKS|XFS_AT_VCODE|\
>                 XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|XFS_AT_GENCOUNT)
> 
> I can't see anywhere we set any of these.
> Presumably out of the xattr calls.
> Some left over from IRIX I guess.

Probably.  Note that linux uses the ATTR_ flags only for ->setattr so
there are per defintion none that can't be set.

> #define XFS_AT_UPDATIME         0x00010000
> #define XFS_AT_UPDMTIME         0x00020000
> #define XFS_AT_UPDCTIME         0x00040000
> 3 more not supported by vfs ATTR_* macros.
> I can't see where we set any of these.
> So no loss there I guess.
> Presumably they were just for IRIX.

It's an IRIX leftover.  I will submit a patch to introduce something
similar to Linux for 2.6.27, that's why I'd like these patches in for
2.6.26 so that I have a clean base to start from.
