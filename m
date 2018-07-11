Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39596 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732580AbeGKNMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 09:12:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id h10-v6so18110208wre.6
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jul 2018 06:08:28 -0700 (PDT)
Date: Wed, 11 Jul 2018 15:08:25 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH RFC 7/8] xfs: return non-zero blocks for inline data
Message-ID: <20180711130825.dkreolul3mlvtf3b@odin.usersys.redhat.com>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-8-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-8-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:28AM +0800, Shan Hai wrote:
> Return non-zero blocks for inline data even though the inode has
> no external blocks, otherwise the "ls -ls" would show zero blocks
> occupied by the file.
> 

Is there any issue you ran into while leaving inodes with zero blocks allocated?
Inodes should actually report the real amount of allocated blocks, not fake it.
Inodes with inlined data should actually report 0 blocks, otherwise, many
applications which actually relies on the amount of allocated blocks for each
file will misbehave.

> Signed-off-by: Shan Hai <shan.hai@oracle.com>
> ---
>  fs/xfs/xfs_iops.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0fa29f39d658..63be1355a473 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -500,8 +500,14 @@ xfs_vn_getattr(
>  	stat->atime = inode->i_atime;
>  	stat->mtime = inode->i_mtime;
>  	stat->ctime = inode->i_ctime;
> -	stat->blocks =
> +
> +	if (xfs_sb_version_hasinlinedata(&mp->m_sb) &&
> +		XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_LOCAL) {
> +			stat->blocks = BTOBB(XFS_ISIZE(ip));
> +	} else {
> +		stat->blocks =
>  		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
> +	}
>  
>  	if (ip->i_d.di_version == 3) {
>  		if (request_mask & STATX_BTIME) {
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
