Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbeLGNhx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Dec 2018 08:37:53 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6516C07455F
        for <linux-xfs@vger.kernel.org>; Fri,  7 Dec 2018 13:37:52 +0000 (UTC)
Date: Fri, 7 Dec 2018 08:37:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/10] xfs: set failaddr into vc for checksum failures
Message-ID: <20181207133747.GC55482@bfoster>
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
 <d380b0b8-b88f-fc96-8515-c5bd97918317@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d380b0b8-b88f-fc96-8515-c5bd97918317@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 05, 2018 at 03:09:48PM -0600, Eric Sandeen wrote:
> Modify CRC checking functions to set __this_address into the
> verifier context failaddr vc->fa using new macro XFS_BADCRC_RETURN,
> and pass that to failure handlers as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          |  4 ++--
>  fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c      |  2 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c     |  2 +-
>  fs/xfs/libxfs/xfs_cksum.h          |  5 ++++-
>  fs/xfs/libxfs/xfs_da_btree.c       |  3 +--
>  fs/xfs/libxfs/xfs_dir2_block.c     |  2 +-
>  fs/xfs/libxfs/xfs_dir2_data.c      |  2 +-
>  fs/xfs/libxfs/xfs_dir2_leaf.c      |  2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c      |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c         |  2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
>  fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
>  fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
>  fs/xfs/libxfs/xfs_symlink_remote.c |  2 +-
>  fs/xfs/libxfs/xfs_types.h          | 12 ++++++++++--
>  fs/xfs/xfs_linux.h                 |  7 -------
>  17 files changed, 29 insertions(+), 26 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 29b0d354d9b7..ab045e8dfcb9 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -45,8 +45,16 @@ struct xfs_vc {
>  	xfs_failaddr_t	fa;
>  };
>  
> -#define XFS_CORRUPTED_RETURN(vc) ({(vc)->fa = __this_address; false;})
> -#define XFS_VERIFIED_RETURN(vc) ({(vc)->fa = NULL; true;})
> +/*
> + * Return the address of a label.  Use barrier() so that the optimizer
> + * won't reorder code to refactor the error jumpouts into a single
> + * return, which throws off the reported address.
> + */
> +#define __this_address ({ __label__ __here; __here: barrier(); &&__here; })
> + 

FYI, minor whitespace damage on the line above.

> +#define XFS_CORRUPTED_RETURN(vc)	({(vc)->fa = __this_address; false;})
> +#define XFS_BADCRC_RETURN(vc)		({(vc)->fa = __this_address; false;})
> +#define XFS_VERIFIED_RETURN(vc)		({(vc)->fa = NULL; true;})
>  

A couple high level comments..

I don't particularly care that much whether we bury function returns in
the macro or open-code it, but the macro naming suggests the former
(based on precedent of other such macros in XFS) while we implement the
latter. If there's objection to a return within a macro, perhaps a
reasonable compromise between this and the common pattern of having to
return on a separate line is to tweak the macros to never clobber an
existing error and update the verifiers to check/return failure state at
opportune points. For example:

	...
	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
		XFS_VC_CORRUPT(vc);
	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
		XFS_VC_CORRUPT(vc);
	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != bp->b_pag->pag_agno)
		XFS_VC_CORRUPT(vc);
	...

	return vc->fa ? false : true;

Of course, that assumes it's safe to keep checking the structure(s) as
such in the event of corruption, which perhaps is not ideal. Anyways, we
could also just return on a separate line or rename the macros. Just
thinking out loud a bit.

I'm also a little curious why we have the need for the success macro at
all. I've only made a cursory pass at this point, but is there a
particular need to set anything in the xfs_vc at the point of a
successful return as opposed to just leaving the structure in the
initialized state?

Brian

>  /*
>   * Null values for the types.
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index edbd5a210df2..4141e70bb3fa 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -131,13 +131,6 @@ typedef __u32			xfs_nlink_t;
>  #define SYNCHRONIZE()	barrier()
>  #define __return_address __builtin_return_address(0)
>  
> -/*
> - * Return the address of a label.  Use barrier() so that the optimizer
> - * won't reorder code to refactor the error jumpouts into a single
> - * return, which throws off the reported address.
> - */
> -#define __this_address	({ __label__ __here; __here: barrier(); &&__here; })
> -
>  #define XFS_PROJID_DEFAULT	0
>  
>  #define howmany(x, y)	(((x)+((y)-1))/(y))
> -- 
> 2.17.0
> 
> 
