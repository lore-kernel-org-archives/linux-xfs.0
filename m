Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbeLGNlT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Dec 2018 08:41:19 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C876C049AFF
        for <linux-xfs@vger.kernel.org>; Fri,  7 Dec 2018 13:41:19 +0000 (UTC)
Date: Fri, 7 Dec 2018 08:41:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/10] xfs: add errno to verifier context and populate it
Message-ID: <20181207134114.GD55482@bfoster>
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
 <cc218ca1-a572-0dd0-d01b-89b33eeace4b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc218ca1-a572-0dd0-d01b-89b33eeace4b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 05, 2018 at 03:11:00PM -0600, Eric Sandeen wrote:
> Add errno to verifier context and set it on verifier failures;
> now rather than passing errno and vc->fa to xfs_verifier_error,
> we pass vc directly and let xfs_verifier_error suss out the
> errno and failaddr.
> 
> Also make 3 new macros, XFS_CORRUPTED, XFS_BADCRC, and
> XFS_VERIFIED which set errno and failaddr into the verifier context
> without returning.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          | 12 ++++----
>  fs/xfs/libxfs/xfs_alloc_btree.c    |  6 ++--
>  fs/xfs/libxfs/xfs_attr_leaf.c      |  6 ++--
>  fs/xfs/libxfs/xfs_attr_remote.c    | 49 ++++++++++++------------------
>  fs/xfs/libxfs/xfs_bmap_btree.c     |  6 ++--
>  fs/xfs/libxfs/xfs_da_btree.c       |  9 +++---
>  fs/xfs/libxfs/xfs_dir2_block.c     |  6 ++--
>  fs/xfs/libxfs/xfs_dir2_data.c      |  9 +++---
>  fs/xfs/libxfs/xfs_dir2_leaf.c      |  6 ++--
>  fs/xfs/libxfs/xfs_dir2_node.c      |  8 ++---
>  fs/xfs/libxfs/xfs_ialloc.c         |  6 ++--
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |  6 ++--
>  fs/xfs/libxfs/xfs_refcount_btree.c |  6 ++--
>  fs/xfs/libxfs/xfs_rmap_btree.c     |  6 ++--
>  fs/xfs/libxfs/xfs_sb.c             | 14 ++++++---
>  fs/xfs/libxfs/xfs_symlink_remote.c |  6 ++--
>  fs/xfs/libxfs/xfs_types.h          | 16 ++++++++--
>  fs/xfs/xfs_error.c                 |  7 ++---
>  fs/xfs/xfs_error.h                 |  3 +-
>  19 files changed, 96 insertions(+), 91 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 07e866103dc2..50726c54c2ca 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -719,9 +719,13 @@ xfs_sb_read_verify(
>  	error = xfs_validate_sb_read(mp, &sb);
>  
>  out_error:
> -	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
> -		xfs_verifier_error(bp, error, __this_address);
> -	else if (error)
> +	if (error == -EFSCORRUPTED) {
> +		XFS_CORRUPTED(vc);

Can't this clobber a previous corruption state in the vc, depending on
how we get here?

> +		xfs_verifier_error(bp, vc);
> +	} else if (error == -EFSBADCRC) {
> +		XFS_BADCRC(vc);
> +		xfs_verifier_error(bp, vc);
> +	} else if (error)
>  		xfs_buf_ioerror(bp, error);
>  }
>  
> @@ -779,7 +783,9 @@ xfs_sb_write_verify(
>  	return;
>  
>  out_error:
> -	xfs_verifier_error(bp, error, __this_address);
> +	vc->fa = __this_address;
> +	vc->errno = error;
> +	xfs_verifier_error(bp, vc);
>  }
>  
>  const struct xfs_buf_ops xfs_sb_buf_ops = {
...
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index ab045e8dfcb9..4f0b8c73b599 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
...
> @@ -51,10 +57,14 @@ struct xfs_vc {
>   * return, which throws off the reported address.
>   */
>  #define __this_address ({ __label__ __here; __here: barrier(); &&__here; })
> +
> +#define XFS_CORRUPTED(vc)	({(vc)->fa = __this_address; (vc)->errno = -EFSCORRUPTED;})
> +#define XFS_BADCRC(vc)		({(vc)->fa = __this_address; (vc)->errno = -EFSBADCRC;})
> +#define XFS_VERIFIED(vc)	({(vc)->fa = NULL; (vc)->errno = 0;})
>   
> -#define XFS_CORRUPTED_RETURN(vc)	({(vc)->fa = __this_address; false;})
> -#define XFS_BADCRC_RETURN(vc)		({(vc)->fa = __this_address; false;})
> -#define XFS_VERIFIED_RETURN(vc)		({(vc)->fa = NULL; true;})
> +#define XFS_CORRUPTED_RETURN(vc)	({(vc)->fa = __this_address; (vc)->errno = -EFSCORRUPTED; false;})
> +#define XFS_BADCRC_RETURN(vc)		({(vc)->fa = __this_address; (vc)->errno = -EFSBADCRC; false;})
> +#define XFS_VERIFIED_RETURN(vc)		({(vc)->fa = NULL; (vc)->errno = 0;  true;})
>  

Case in point wrt the naming thoughts on the previous patch: what's the
need for separate XFS_CORRUPTED() macros if the _RETURN() ones don't
actually change execution flow? They just evaluate to a logical
true/false, which should be perfectly fine outside of a return
statement.

Hmm, maybe it would be better to stick with that "return value" model
after all, but just drop the _RETURN() bit of the name and use the same
macro in both contexts.

Brian

>  /*
>   * Null values for the types.
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 9866f542e77b..4d305287823c 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -381,11 +381,10 @@ xfs_buf_verifier_error(
>  void
>  xfs_verifier_error(
>  	struct xfs_buf		*bp,
> -	int			error,
> -	xfs_failaddr_t		failaddr)
> +	struct xfs_vc		*vc)
>  {
> -	return xfs_buf_verifier_error(bp, error, "", xfs_buf_offset(bp, 0),
> -			XFS_CORRUPTION_DUMP_LEN, failaddr);
> +	return xfs_buf_verifier_error(bp, vc->errno, "", xfs_buf_offset(bp, 0),
> +			XFS_CORRUPTION_DUMP_LEN, vc->fa);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 246d3e989c6c..9b0ac387007d 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -18,8 +18,7 @@ extern void xfs_corruption_error(const char *tag, int level,
>  extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
>  			const char *name, void *buf, size_t bufsz,
>  			xfs_failaddr_t failaddr);
> -extern void xfs_verifier_error(struct xfs_buf *bp, int error,
> -			xfs_failaddr_t failaddr);
> +extern void xfs_verifier_error(struct xfs_buf *bp, struct xfs_vc *vc);
>  extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
>  			const char *name, void *buf, size_t bufsz,
>  			xfs_failaddr_t failaddr);
> -- 
> 2.17.0
> 
> 
