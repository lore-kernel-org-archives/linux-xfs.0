Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeGHPvP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 11:51:15 -0400
Date: Sun, 8 Jul 2018 08:51:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 5/8] xfs: consider the local format inode in misc
 operations
Message-ID: <20180708155114.GC8625@infradead.org>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-6-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-6-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:26AM +0800, Shan Hai wrote:
> The local format inode is a legal citizen from now on and consider
> it in misc operations.

This probably wants to go towards the front of the series, and split
into multiple patches with better changelogs for each.

>  
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> -	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
> +	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
> +	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL),

This are all the three possible values.  It is kinda confusing to read
the checks this way as we alreayd checked for a valid fork type in
the inode read verifies.

Also this seems to be in xfs_bmapi_read, for which reading allowing
inline format forks seems wrong to me.

> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +	if (!(ifp->if_flags & (XFS_IFINLINE | XFS_IFEXTENTS))) {
>  		error = xfs_iread_extents(NULL, ip, whichfork);
>  		if (error)
>  			return error;

I think we need to clean this up better.  We probably want an
xfs_inode_has_extents helper, or even hide the check inside
xfs_iread_extents itself.  Also I wonder if the above is read, the
XFS_IFEXTENTS flag has always meant that we have the current extent list
in memory, which should always be the case for a fork in inline format.

> @@ -5244,11 +5239,18 @@ __xfs_bunmapi(
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	if (unlikely(
>  	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> +	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL &&
>  	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
>  		XFS_ERROR_REPORT("xfs_bunmapi", XFS_ERRLEVEL_LOW,
>  				 ip->i_mount);
>  		return -EFSCORRUPTED;
>  	}
> +
> +	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
> +		*rlen = 0;
> +		return 0;
> +	}

I don't think we should ever call bunmapi for an inline format fork.

>  };
>  
> -
>  /*

Spurious whitespace change.

>   * This routine is called to map an inode to the buffer containing the on-disk
>   * version of the inode.  It returns a pointer to the buffer containing the
> @@ -384,12 +383,7 @@ xfs_dinode_verify_fork(
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
> -		/*
> -		 * no local regular files yet
> -		 */
>  		if (whichfork == XFS_DATA_FORK) {
> -			if (S_ISREG(be16_to_cpu(dip->di_mode)))
> -				return __this_address;

I think you need to check the new feature bit here and only allow the
inline regular case if the feature bit it set.

> @@ -283,7 +283,7 @@ xfs_scrub_dinode(
>  			xfs_scrub_ino_set_corrupt(sc, ino);
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -		if (!S_ISDIR(mode) && !S_ISLNK(mode))
> +		if (!S_ISREG(mode) && !S_ISDIR(mode) && !S_ISLNK(mode))
>  			xfs_scrub_ino_set_corrupt(sc, ino);
>  		break;

Same here.
