Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33716 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbeAYVkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 16:40:03 -0500
Date: Thu, 25 Jan 2018 13:30:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC][PATCH] xfs: preserve i_rdev when recycling a reclaimable
 inode
Message-ID: <20180125213040.GO9068@magnolia>
References: <1516915298-8886-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516915298-8886-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Jan 25, 2018 at 11:21:38PM +0200, Amir Goldstein wrote:
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Darrick,
> 
> This patch fixes a problem I am hitting consistenty with xfstest
> overlay/017 with certain overlay mount options (index=on,nfs_export=off).
> 
> I see that overlayfs looks up in underlying xfs and gets a chardev
> or blockdev inode with non initialized i_rdev (these are not whiteout
> inodes).
> 
> It takes a certain timing which happens in this test that does lookup
> immediately after drop caches. The test causes a permanent error in
> inode cache of xfs that is only fixed after another drop caches or
> cycle mount.
> 
> So I am certain there is a problem and that this patch fixes the
> problem, I'm just not sure this is the right fix and if it is, which
> is the commit that it "Fixes".

We're basically reinitializing a VFS inode that was on its way to being
reclaimed, which means that we don't xfs_iread.  We still have to
reinitialize the vfs inode state (because we'd already torn that down),
so we have to preserve all the vfs inode state that the xfs inode stores
in the vfs inode.

Oh, right, hch moved if_rdev to i_rdev in 66f364649d870 ("xfs: remove
if_rdev") but forgot the xfs_reinit_inode usage.  so that would be the
commit that this fixes.  Doh.

--D

> 
> Thanks,
> Amir.
> 
>  fs/xfs/xfs_icache.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3861d61fb265..3ce946063ffe 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -295,6 +295,7 @@ xfs_reinit_inode(
>  	uint32_t	generation = inode->i_generation;
>  	uint64_t	version = inode->i_version;
>  	umode_t		mode = inode->i_mode;
> +	dev_t		dev = inode->i_rdev;
>  
>  	error = inode_init_always(mp->m_super, inode);
>  
> @@ -302,6 +303,7 @@ xfs_reinit_inode(
>  	inode->i_generation = generation;
>  	inode->i_version = version;
>  	inode->i_mode = mode;
> +	inode->i_rdev = dev;
>  	return error;
>  }
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
