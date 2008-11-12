Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 07:39:52 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mACFdcql024086
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 07:39:38 -0800
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2065154BE4A
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 07:39:37 -0800 (PST)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by cuda.sgi.com with ESMTP id BJxUPu8SnQEuC91T for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 07:39:37 -0800 (PST)
Date: Wed, 12 Nov 2008 10:39:03 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] XFS: random cleanups of xfs_swap_extents
Message-ID: <20081112153903.GE27125@josefsipek.net>
References: <20081107230054.GH26208@josefsipek.net> <20081112100958.GB32567@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112100958.GB32567@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Wed, Nov 12, 2008 at 05:09:58AM -0500, Christoph Hellwig wrote:
> On Fri, Nov 07, 2008 at 06:00:54PM -0500, Josef 'Jeff' Sipek wrote:
> > XFS: random cleanups of xfs_swap_extents
> > 
> > From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> > 
> > 1) remove lock_flags var since it's never modified and only obfuscates the
> > code
> > 
> > 2) calling kfree/vfree on a NULL is valid
> 
> Looks good to me, but I'd go even further and kill the stupid locked
> variable by having the exit path structured as:
> 
>  out_trans_cancel:
> 	xfs_trans_cancel(tp, 0);
>  out_unlock:
> 	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> 	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>  out_free:
> 	kmem_free(tempifp);
>  out:
> 	return error;
> }
> 
> With the one case that does a trans_cancel with partially unlocked
> inodes handcoding most of it.

Ok, I'll do that.

Josef 'Jeff' Sipek.

-- 
Mankind invented the atomic bomb, but no mouse would ever construct a
mousetrap.
		- Albert Einstein
