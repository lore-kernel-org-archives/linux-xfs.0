Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0225.hostedemail.com ([216.40.44.225]:46801 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750796AbdELO1r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 May 2017 10:27:47 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id CE1BF18440C
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2017 14:18:52 +0000 (UTC)
Message-ID: <1494598724.2028.19.camel@perches.com>
Subject: Re: [PATCH] xfs: avoid harmless gcc-7 warnings
From: Joe Perches <joe@perches.com>
Date: Fri, 12 May 2017 07:18:44 -0700
In-Reply-To: <20170511124932.226016-1-arnd@arndb.de>
References: <20170511124932.226016-1-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Calvin Owens <calvinowens@fb.com>, linux-kernel@vger.kernel.org

On Thu, 2017-05-11 at 14:49 +0200, Arnd Bergmann wrote:
> gcc-7 flags the use of integer math inside of a condition
> as a potential bug:
> 
> fs/xfs/xfs_bmap_util.c: In function 'xfs_swap_extents_check_format':
> fs/xfs/xfs_bmap_util.c:1619:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> fs/xfs/xfs_bmap_util.c:1629:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> 
> This one is clearly fine, and we can add a comparison to zero
> to shut up the warning.
[]
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
[]
> @@ -1613,7 +1613,7 @@ xfs_swap_extents_check_format(
>  	 * extent format...
>  	 */
>  	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> -		if (XFS_IFORK_BOFF(ip) &&
> +		if ((XFS_IFORK_BOFF(ip) != 0) &&

As far as I can tell, this suggestion makes no sense.

$ git grep -E "define\s+XFS_IFORK_BOFF"
fs/xfs/libxfs/xfs_inode_fork.h:#define XFS_IFORK_BOFF(ip)               ((int)((ip)->i_d.di_forkoff << 3))

$ git grep -w di_forkoff|grep -P "\w+\s+di_forkoff\s*;"
fs/xfs/libxfs/xfs_format.h:	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
fs/xfs/libxfs/xfs_inode_buf.h:	__uint8_t	di_forkoff;	/* attr fork offs, <<3 for 64b align */
fs/xfs/libxfs/xfs_log_format.h:	__uint8_t	di_forkoff;	/* attr fork offs, <<3 for 64b align */


