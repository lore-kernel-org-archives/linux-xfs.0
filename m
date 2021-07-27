Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A90C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 22:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 550FB60F9E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 22:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhG0W3u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 18:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhG0W3t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 18:29:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4553A60F6E;
        Tue, 27 Jul 2021 22:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627424988;
        bh=PWE4n10NizznBaudeK9mlz2DbsCr28lWrkYZKJsh/Fk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pqvgHF9rWj/K3YdvxfPcf6BOP6Ia8vE2exejA0ThtbEE22+D08AcMCItENVPbYIOV
         pAnBQuIfqTC64PzUh4q99O/zmVJaAOkQdkv6hTxnJzR6o+d9asF18f7NX7Px/WPm4I
         awUO3izKIAJ0wkArvD3uPjuLNuRI3zPe3n/OPmf2u2VSiXZWwkZYHlfYAof5Kj9aYv
         FL87THK10apVwdFFNYuflq22WdISYmFd9YsLv5wSmiIvnqjRxXBjb8Du1mlqhY6D0Z
         TW+dmCjj4ML8Mam+9ko/Qv0LcXB3IqZGywRTPnTTitZs+UiOrYQ8+Epfa97qtrqwm2
         BjwSdLbzL99ug==
Date:   Tue, 27 Jul 2021 15:29:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 08/12] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <20210727222947.GQ559212@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-9-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-9-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:37PM +0530, Chandan Babu R wrote:
> A future commit will introduce a 64-bit on-disk data extent counter and a
> 32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
> xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
> of these quantities.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Well done!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
>  fs/xfs/libxfs/xfs_types.h      | 4 ++--
>  fs/xfs/scrub/attr_repair.c     | 2 +-
>  fs/xfs/scrub/trace.h           | 2 +-
>  fs/xfs/xfs_inode.c             | 4 ++--
>  fs/xfs/xfs_trace.h             | 4 ++--
>  7 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e5d243fd187d..a27d57ea301c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -472,7 +472,7 @@ xfs_bmap_check_leaf_extents(
>  	if (bp_release)
>  		xfs_trans_brelse(NULL, bp);
>  error_norelse:
> -	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
> +	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
>  		__func__, i);
>  	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7f7ffe29436d..336eee69703c 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -126,7 +126,7 @@ xfs_iformat_extents(
>  	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
>  	 */
>  	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
> -		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
> +		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
>  			(unsigned long long) ip->i_ino, nex);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
>  				"xfs_iformat_extents(1)", dip, sizeof(*dip),
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 8908346b1deb..584fa61e338e 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
>  typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
>  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
>  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> -typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> +typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> +typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
>  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
>  typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
>  
> diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
> index 7d92195d286b..aad4b269949d 100644
> --- a/fs/xfs/scrub/attr_repair.c
> +++ b/fs/xfs/scrub/attr_repair.c
> @@ -769,7 +769,7 @@ xrep_xattr_fork_remove(
>  		unsigned int		i = 0;
>  
>  		xfs_emerg(sc->mp,
> -	"inode 0x%llx attr fork still has %u attr extents, format %d?!",
> +	"inode 0x%llx attr fork still has %llu attr extents, format %d?!",
>  				ip->i_ino, ifp->if_nextents, ifp->if_format);
>  		for_each_xfs_iext(ifp, &icur, &irec) {
>  			xfs_err(sc->mp, "[%u]: startoff %llu startblock %llu blockcount %llu state %u", i++, irec.br_startoff, irec.br_startblock, irec.br_blockcount, irec.br_state);
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index a0303f692e52..f9be7812c8ce 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -1363,7 +1363,7 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
>  		__entry->attr_extents = attr_extents;
>  		__entry->block0 = block0;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx dblocks %llu rtblocks %llu ablocks %llu dextents %u rtextents %u aextents %u block0 %llu",
> +	TP_printk("dev %d:%d ino 0x%llx dblocks %llu rtblocks %llu ablocks %llu dextents %llu rtextents %llu aextents %u block0 %llu",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->data_blocks,
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f152f6dace0c..4070fb01350c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2510,8 +2510,8 @@ xfs_iflush(
>  	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
>  				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
> -			"%s: detected corrupt incore inode %Lu, "
> -			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
> +			"%s: detected corrupt incore inode %llu, "
> +			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
>  			__func__, ip->i_ino,
>  			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
>  			ip->i_nblocks, ip);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 5ed11f894f79..af426b9824db 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2351,7 +2351,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
>  		__entry->broot_size = ip->i_df.if_broot_bytes;
>  		__entry->fork_off = XFS_IFORK_BOFF(ip);
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
> +	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
>  		  "broot size %d, fork offset %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> @@ -4588,7 +4588,7 @@ TRACE_EVENT(xfs_swapext_delta_nextents,
>  		__entry->d_nexts1 = d_nexts1;
>  		__entry->d_nexts2 = d_nexts2;
>  	),
> -	TP_printk("dev %d:%d ino1 0x%llx nexts %u ino2 0x%llx nexts %u delta1 %lld delta2 %lld",
> +	TP_printk("dev %d:%d ino1 0x%llx nexts %llu ino2 0x%llx nexts %llu delta1 %lld delta2 %lld",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino1, __entry->nexts1,
>  		  __entry->ino2, __entry->nexts2,
> -- 
> 2.30.2
> 
