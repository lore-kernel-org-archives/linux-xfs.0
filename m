Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 14:25:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MLPoVv021986
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:25:50 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DB1B53033B
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:27:35 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id JUGhSGLW6oNM7JB1 for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:27:35 -0700 (PDT)
Date: Thu, 23 Oct 2008 08:27:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] stop using xfs_itobp in xfs_bulkstat
Message-ID: <20081022212733.GR18495@disturbed>
References: <20081022163034.GB25556@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022163034.GB25556@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 22, 2008 at 12:30:34PM -0400, Christoph Hellwig wrote:
> xfs_bulkstat only wants the dinode, offset and buffer from a given
> inode number.  Instead of using xfs_itobp on a fake inode which is
> complicated and currently leads to leaks of the security data just use
> xfs_inotobp which is designed to do exactly the kind of lookup
> xfs_bulkstat wants.  The only thing that's missing in xfs_inotobp is
> a flags paramter that let's us pass down XFS_IMAP_BULKSTAT, but that can
> easily added.

Looks good.

> Index: xfs-2.6/fs/xfs/xfs_inode.h
> ===================================================================
> --- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-20 23:49:30.000000000 +0200
> +++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-21 09:28:03.000000000 +0200
> @@ -158,7 +158,7 @@ typedef struct xfs_icdinode {
>  #define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
>  
>  /*
> - * Flags for xfs_itobp(), xfs_imap() and xfs_dilocate().
> + * Flags for xfs_inotobp, xfs_itobp(), xfs_imap() and xfs_dilocate().
>   */

Not really important, but for consistency that should be
"xfs_inotobp()". Perhaps just fix that in the followup patch
that removes the imap_flags from xfs_itobp() so this can go
straight in without another round trip.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
