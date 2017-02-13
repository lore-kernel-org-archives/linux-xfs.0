Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:62106 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752730AbdBMVfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Feb 2017 16:35:12 -0500
Date: Tue, 14 Feb 2017 08:34:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: fix inode uid/gid initialization
Message-ID: <20170213213416.GA15349@dastard>
References: <1487008001.3125.41.camel@HansenPartnership.com>
 <20170213194337.GA9852@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170213194337.GA9852@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>

On Mon, Feb 13, 2017 at 11:43:37AM -0800, Christoph Hellwig wrote:
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -814,18 +814,10 @@ xfs_ialloc(
>  	if (ip->i_d.di_version == 1)
>  		ip->i_d.di_version = 2;
>  
> -	inode->i_mode = mode;
> +	inode_init_owner(inode, pip ? VFS_I(pip) : NULL, mode);
>  	set_nlink(inode, nlink);
> -	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
> -	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
>  	xfs_set_projid(ip, prid);
>  
> -	if (pip && XFS_INHERIT_GID(pip)) {
> -		ip->i_d.di_gid = pip->i_d.di_gid;
> -		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
> -			inode->i_mode |= S_ISGID;
> -	}
> -

Doesn't this hunk break the "nogrpid" mount option?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
