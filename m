Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8513FC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 17:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F11161ABF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 17:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355493AbhJAR4g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:56:36 -0400
Received: from sandeen.net ([63.231.237.45]:45238 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355478AbhJAR4g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Oct 2021 13:56:36 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id ACF1514A18;
        Fri,  1 Oct 2021 12:54:11 -0500 (CDT)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174721668.350433.1083608596895028766.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 04/61] libxfs: port xfs_set_inode_alloc from the kernel
Message-ID: <4964baa5-fb26-1aba-1ce4-055c556f07e6@sandeen.net>
Date:   Fri, 1 Oct 2021 12:54:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <163174721668.350433.1083608596895028766.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/15/21 6:06 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> To prepare to perag initialization code move to libxfs, port the
> xfs_set_inode_alloc function from the kernel and make
> libxfs_initialize_perag use it.  The code isn't 1:1 identical, but
> AFAICT it behaves the same way.  In a future kernel release we'll
> move the function into xfs_ag.c and update xfsprogs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Ok, so this is in effect syncing up:


commit 2d2194f61fddab3a9731b6e7a7ae3a4a19dd810c
Author: Carlos Maiolino <cmaiolino@redhat.com>
Date:   Thu Sep 20 10:32:38 2012 -0300

     xfs: reduce code duplication handling inode32/64 options

and a few others up to about this change:

commit 12c3f05c7b592ae3bf2219392f1cbf252645cd79
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Mar 2 09:58:09 2016 +1100

     xfs: fix up inode32/64 (re)mount handling

from the kernel.  The pitfalls of having copied kernel code that's not
in libxfs.  :(

The change looks legit and works fine here.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> ---
>   libxfs/init.c |  142 ++++++++++++++++++++++++++++++++++++---------------------
>   1 file changed, 89 insertions(+), 53 deletions(-)
> 
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 1ec83791..6223181f 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -482,18 +482,102 @@ rtmount_init(
>   	return 0;
>   }
>   
> +/*
> + * Set parameters for inode allocation heuristics, taking into account
> + * filesystem size and inode32/inode64 mount options; i.e. specifically
> + * whether or not XFS_MOUNT_SMALL_INUMS is set.
> + *
> + * Inode allocation patterns are altered only if inode32 is requested
> + * (XFS_MOUNT_SMALL_INUMS), and the filesystem is sufficiently large.
> + * If altered, XFS_MOUNT_32BITINODES is set as well.
> + *
> + * An agcount independent of that in the mount structure is provided
> + * because in the growfs case, mp->m_sb.sb_agcount is not yet updated
> + * to the potentially higher ag count.
> + *
> + * Returns the maximum AG index which may contain inodes.
> + */
> +xfs_agnumber_t
> +xfs_set_inode_alloc(
> +	struct xfs_mount *mp,
> +	xfs_agnumber_t	agcount)
> +{
> +	xfs_agnumber_t	index;
> +	xfs_agnumber_t	maxagi = 0;
> +	xfs_sb_t	*sbp = &mp->m_sb;
> +	xfs_agnumber_t	max_metadata;
> +	xfs_agino_t	agino;
> +	xfs_ino_t	ino;
> +
> +	/*
> +	 * Calculate how much should be reserved for inodes to meet
> +	 * the max inode percentage.  Used only for inode32.
> +	 */
> +	if (M_IGEO(mp)->maxicount) {
> +		uint64_t	icount;
> +
> +		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
> +		do_div(icount, 100);
> +		icount += sbp->sb_agblocks - 1;
> +		do_div(icount, sbp->sb_agblocks);
> +		max_metadata = icount;
> +	} else {
> +		max_metadata = agcount;
> +	}
> +
> +	/* Get the last possible inode in the filesystem */
> +	agino =	XFS_AGB_TO_AGINO(mp, sbp->sb_agblocks - 1);
> +	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
> +
> +	/*
> +	 * If user asked for no more than 32-bit inodes, and the fs is
> +	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
> +	 * the allocator to accommodate the request.
> +	 */
> +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
> +		mp->m_flags |= XFS_MOUNT_32BITINODES;
> +	else
> +		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> +
> +	for (index = 0; index < agcount; index++) {
> +		struct xfs_perag	*pag;
> +
> +		ino = XFS_AGINO_TO_INO(mp, index, agino);
> +
> +		pag = xfs_perag_get(mp, index);
> +
> +		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
> +			if (ino > XFS_MAXINUMBER_32) {
> +				pag->pagi_inodeok = 0;
> +				pag->pagf_metadata = 0;
> +			} else {
> +				pag->pagi_inodeok = 1;
> +				maxagi++;
> +				if (index < max_metadata)
> +					pag->pagf_metadata = 1;
> +				else
> +					pag->pagf_metadata = 0;
> +			}
> +		} else {
> +			pag->pagi_inodeok = 1;
> +			pag->pagf_metadata = 0;
> +		}
> +
> +		xfs_perag_put(pag);
> +	}
> +
> +	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
> +}
> +
>   static int
>   libxfs_initialize_perag(
>   	xfs_mount_t	*mp,
>   	xfs_agnumber_t	agcount,
>   	xfs_agnumber_t	*maxagi)
>   {
> -	xfs_agnumber_t	index, max_metadata;
> +	xfs_agnumber_t	index;
>   	xfs_agnumber_t	first_initialised = 0;
>   	xfs_perag_t	*pag;
> -	xfs_agino_t	agino;
> -	xfs_ino_t	ino;
> -	xfs_sb_t	*sbp = &mp->m_sb;
>   	int		error = -ENOMEM;
>   
>   	/*
> @@ -522,55 +606,7 @@ libxfs_initialize_perag(
>   		}
>   	}
>   
> -	/*
> -	 * If we mount with the inode64 option, or no inode overflows
> -	 * the legacy 32-bit address space clear the inode32 option.
> -	 */
> -	agino = XFS_AGB_TO_AGINO(mp, sbp->sb_agblocks - 1);
> -	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
> -
> -	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
> -		mp->m_flags |= XFS_MOUNT_32BITINODES;
> -	else
> -		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> -
> -	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
> -		/*
> -		 * Calculate how much should be reserved for inodes to meet
> -		 * the max inode percentage.
> -		 */
> -		if (M_IGEO(mp)->maxicount) {
> -			uint64_t	icount;
> -
> -			icount = sbp->sb_dblocks * sbp->sb_imax_pct;
> -			do_div(icount, 100);
> -			icount += sbp->sb_agblocks - 1;
> -			do_div(icount, sbp->sb_agblocks);
> -			max_metadata = icount;
> -		} else {
> -			max_metadata = agcount;
> -		}
> -
> -		for (index = 0; index < agcount; index++) {
> -			ino = XFS_AGINO_TO_INO(mp, index, agino);
> -			if (ino > XFS_MAXINUMBER_32) {
> -				index++;
> -				break;
> -			}
> -
> -			pag = xfs_perag_get(mp, index);
> -			pag->pagi_inodeok = 1;
> -			if (index < max_metadata)
> -				pag->pagf_metadata = 1;
> -			xfs_perag_put(pag);
> -		}
> -	} else {
> -		for (index = 0; index < agcount; index++) {
> -			pag = xfs_perag_get(mp, index);
> -			pag->pagi_inodeok = 1;
> -			xfs_perag_put(pag);
> -		}
> -	}
> +	index = xfs_set_inode_alloc(mp, agcount);
>   
>   	if (maxagi)
>   		*maxagi = index;
> 
