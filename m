Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED62C2BB3F
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 15:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbjKTPib (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 10:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjKTPia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 10:38:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE4F9F;
        Mon, 20 Nov 2023 07:38:27 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD42C433C9;
        Mon, 20 Nov 2023 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1700494707;
        bh=gzMXJTNTN4NUqcZczVuLvOkFTVJuZ1eQ1YAhkb6eRuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k4PC0YhV3VufLOQv5T/lMRGTz5Y0QDUWs9mpbAmQbvP4+n08AuVLJb06KCPV4HOo4
         Um5fl5m01rKctlj5KvuQDq7EWSvYisRfJ3FiVVndrQNdqQCcKkiyEnBpa1eimNl0Nk
         wmevix7emJDJr4cy34FWLFvxLI0YbtitxmydNbYI=
Date:   Mon, 20 Nov 2023 16:38:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        ChenXiaoSong <chenxiaosong2@huawei.com>,
        Guo Xuenan <guoxuenan@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: Re: [PATCH 5.15 09/17] xfs: fix NULL pointer dereference in
 xfs_getbmap()
Message-ID: <2023112053-monogamy-corned-68ba@gregkh>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
 <20231116022833.121551-9-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231116022833.121551-9-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 15, 2023 at 06:28:25PM -0800, Leah Rumancik wrote:
> From: ChenXiaoSong <chenxiaosong2@huawei.com>
> 
> [ Upstream commit 001c179c4e26d04db8c9f5e3fef9558b58356be6 ]
> 
> Reproducer:
>  1. fallocate -l 100M image
>  2. mkfs.xfs -f image
>  3. mount image /mnt
>  4. setxattr("/mnt", "trusted.overlay.upper", NULL, 0, XATTR_CREATE)
>  5. char arg[32] = "\x01\xff\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00"
>                    "\x00\x00\x00\x00\x00\x08\x00\x00\x00\xc6\x2a\xf7";
>     fd = open("/mnt", O_RDONLY|O_DIRECTORY);
>     ioctl(fd, _IOC(_IOC_READ|_IOC_WRITE, 0x58, 0x2c, 0x20), arg);
> 
> NULL pointer dereference will occur when race happens between xfs_getbmap()
> and xfs_bmap_set_attrforkoff():
> 
>          ioctl               |       setxattr
>  ----------------------------|---------------------------
>  xfs_getbmap                 |
>    xfs_ifork_ptr             |
>      xfs_inode_has_attr_fork |
>        ip->i_forkoff == 0    |
>      return NULL             |
>    ifp == NULL               |
>                              | xfs_bmap_set_attrforkoff
>                              |   ip->i_forkoff > 0
>    xfs_inode_has_attr_fork   |
>      ip->i_forkoff > 0       |
>    ifp == NULL               |
>    ifp->if_format            |
> 
> Fix this by locking i_lock before xfs_ifork_ptr().
> 
> Fixes: abbf9e8a4507 ("xfs: rewrite getbmap using the xfs_iext_* helpers")
> Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> [djwong: added fixes tag]
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> Acked-by: Chandan Babu R <chandanbabu@kernel.org>
> ---
>  fs/xfs/xfs_bmap_util.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index fd2ad6a3019c..bea6cc26abf9 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -439,29 +439,28 @@ xfs_getbmap(
>  		whichfork = XFS_COW_FORK;
>  	else
>  		whichfork = XFS_DATA_FORK;
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
>  
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  	switch (whichfork) {
>  	case XFS_ATTR_FORK:
> +		lock = xfs_ilock_attr_map_shared(ip);
>  		if (!XFS_IFORK_Q(ip))
> -			goto out_unlock_iolock;
> +			goto out_unlock_ilock;
>  
>  		max_len = 1LL << 32;
> -		lock = xfs_ilock_attr_map_shared(ip);
>  		break;
>  	case XFS_COW_FORK:
> +		lock = XFS_ILOCK_SHARED;
> +		xfs_ilock(ip, lock);
> +
>  		/* No CoW fork? Just return */
> -		if (!ifp)
> -			goto out_unlock_iolock;
> +		if (!XFS_IFORK_PTR(ip, whichfork))
> +			goto out_unlock_ilock;
>  
>  		if (xfs_get_cowextsz_hint(ip))
>  			max_len = mp->m_super->s_maxbytes;
>  		else
>  			max_len = XFS_ISIZE(ip);
> -
> -		lock = XFS_ILOCK_SHARED;
> -		xfs_ilock(ip, lock);
>  		break;
>  	case XFS_DATA_FORK:
>  		if (!(iflags & BMV_IF_DELALLOC) &&
> @@ -491,6 +490,8 @@ xfs_getbmap(
>  		break;
>  	}
>  
> +	ifp = XFS_IFORK_PTR(ip, whichfork);
> +
>  	switch (ifp->if_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
>  	case XFS_DINODE_FMT_BTREE:
> -- 
> 2.43.0.rc0.421.g78406f8d94-goog
> 

This patch breaks the build, how was it tested?

fs/xfs/xfs_bmap_util.c: In function ‘xfs_getbmap’:
fs/xfs/xfs_bmap_util.c:457:21: error: the comparison will always evaluate as ‘true’ for the address of ‘i_df’ will never be NULL [-Werror=address]
  457 |                 if (!XFS_IFORK_PTR(ip, whichfork))
      |                     ^
In file included from fs/xfs/xfs_bmap_util.c:16:
fs/xfs/xfs_inode.h:38:33: note: ‘i_df’ declared here
   38 |         struct xfs_ifork        i_df;           /* data fork */
      |                                 ^~~~
cc1: all warnings being treated as errors


