Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388993AbfCAQxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 11:53:34 -0500
Date: Fri, 1 Mar 2019 08:53:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] xfs: fix reporting supported extra file attributes for
 statx()
Message-ID: <20190301165327.GQ21626@magnolia>
References: <20171031221305.12908-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031221305.12908-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 31, 2017 at 03:13:05PM -0700, Luis R. Rodriguez wrote:
> statx(2) notes that any attribute that is not indicated as supported by
> stx_attributes_mask has no usable value. Commit 5f955f26f3d42d ("xfs: report
> crtime and attribute flags to statx") added support for informing userspace
> of extra file attributes but forgot to list these flags as supported
> making reporting them rather useless for the pedantic userspace author.
> 
> $ git describe --contains 5f955f26f3d42d04aba65590a32eb70eedb7f37d
> v4.11-rc6~5^2^2~2
> 
> Fixes: 5f955f26f3d42d ("xfs: report crtime and attribute flags to statx")
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
> 
> Its unclear why David left these out or if it was just a mistake, I checked
> the original patch thread [0] but it was not clear in the end. David?
> 
> Also, I posted a patch to add support to clearing these flags through
> xfs_repair on symlinks [1] due to the pain this can cause as you have no option
> but to use xfs_db to fix these otherwise. Since we *didn't* list these extra
> file attributes as supported, it begs the question if instead we should only
> set them *and* this mask if !S_ISLNK(inode->i_mode)).
> 
> If so, that also begs the question if we should add further sanity check
> on the xfs setattr to ensure these are never set on symbolic links, despite the
> fact that FS_IOC_FSSETXATTR ioctl won't be able to set them...
> 
> A long shot question in terms of semantics is if all the above is rather
> generic for Linux, is if the VFS should even be checking for immutable or
> append flags on unlink for symbolic links.
> 
> [0] https://patchwork.kernel.org/patch/9607879/
> [1] https://lkml.kernel.org/r/20171031215156.12544-1-mcgrof@kernel.org
> 
>  fs/xfs/xfs_iops.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 17081c77ef86..6b7d293a4aab 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -531,6 +531,10 @@ xfs_vn_getattr(
>  	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
>  		stat->attributes |= STATX_ATTR_NODUMP;
>  
> +	stat->attributes_mask |= (STATX_ATTR_IMMUTABLE |
> +				  STATX_ATTR_APPEND |
> +				  STATX_ATTR_NODUMP);
> +

Heh, I just posted the same diff as a patch, having forgotten that this
existed.  I'll ... just take this one instead.

Sorry for whiffing on this for a year and a half(!!)

--D

>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFBLK:
>  	case S_IFCHR:
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
