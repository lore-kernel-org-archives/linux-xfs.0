Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56440 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbeEKCU6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 22:20:58 -0400
Date: Thu, 10 May 2018 19:20:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC v2 2/4] xfs: add verifier check for symlink with
 append/immutable flags
Message-ID: <20180511022020.GG11261@magnolia>
References: <20180510231359.16899-1-mcgrof@kernel.org>
 <20180510231359.16899-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510231359.16899-3-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca, clm@fb.com, jbacik@fb.com, dsterba@suse.com, sandeen@sandeen.net, dhowells@redhat.com, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, May 10, 2018 at 04:13:57PM -0700, Luis R. Rodriguez wrote:
> The Linux VFS does not allow a way to set append/immuttable attributes
> to symlinks, this is just not possible. If this is detected we can
> correct this with xfs_repair, so inform the user.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_symlink_remote.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index 5ef5f354587e..42dd81ede3d6 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -242,5 +242,10 @@ xfs_symlink_shortform_verify(
>  	/* We /did/ null-terminate the buffer, right? */
>  	if (*endp != 0)
>  		return __this_address;
> +
> +	/* Immutable and append flags are not allowed on symlinks */
> +	if (ip->i_d.di_flags & (XFS_DIFLAG_APPEND | XFS_DIFLAG_IMMUTABLE))
> +		return __this_address;

This belongs in xfs_dinode_verify so that it checks all symlinks, not
just the one shortform ones.

--D

> +
>  	return NULL;
>  }
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
