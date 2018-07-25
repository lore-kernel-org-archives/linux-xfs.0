Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34391 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbeGYFfR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 01:35:17 -0400
Received: by mail-wm0-f67.google.com with SMTP id l2-v6so13791941wme.1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 21:25:28 -0700 (PDT)
Date: Wed, 25 Jul 2018 06:25:24 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2 V3] xfs_repair: notify user if free inodes contain
 errors
Message-ID: <20180725042524.m3qf2squ4s33yyam@odin.usersys.redhat.com>
References: <b6f745ab-3016-9a95-3085-8584f7200b64@redhat.com>
 <75f628bc-e8e7-b4fd-0bbb-fb3ca0fabac8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75f628bc-e8e7-b4fd-0bbb-fb3ca0fabac8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 23, 2018 at 07:34:13PM -0700, Eric Sandeen wrote:
> xfs_repair checks allocated but unused (free) inodes in on-disk clusters,
> and up until now silently repairs any errors, and as a result does not
> alter exit status if errors are found.
>     
> The in-kernel verifiers will be noisy about these errors and instruct
> the user to run repair, so it's best if repair is explicit about any
> fixes it makes as a result.
> 
> To ensure we catch anything the kernel would complain about, re-use
> xfs_dinode_verify to determine whether we must clear a free inode.
> 
> Note, however, that the verifier contains only a subset of the checks
> currently in clear_dinode.  This should be ok; if it's not, the checks
> should be added to the verifier in any case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 

Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index a98483b..05c06a7 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -134,6 +134,7 @@
>  #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
>  
>  #define xfs_verify_cksum		libxfs_verify_cksum
> +#define xfs_dinode_verify		libxfs_dinode_verify
>  
>  #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
>  #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
> diff --git a/repair/dinode.c b/repair/dinode.c
> index d36338f..c0db15a 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2560,12 +2560,20 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  		 */
>  		if (was_free) {
>  			/*
> -			 * easy case, inode free -- inode and map agree, clear
> +			 * easy case, inode free -- inode and map agree, check
>  			 * it just in case to ensure that format, etc. are
>  			 * set correctly
>  			 */
> -			if (!no_modify)
> -				*dirty += clear_dinode(mp, dino, lino);
> +			if (libxfs_dinode_verify(mp, lino, dino) != NULL) {
> +				do_warn(
> + _("free inode %" PRIu64 " contains errors, "), lino);
> +				if (!no_modify) {
> +					*dirty += clear_dinode(mp, dino, lino);
> +					do_warn(_("corrected\n"));
> +				} else {
> +					do_warn(_("would correct\n"));
> +				}
> +			}
>  			*used = is_free;
>  			return 0;
>  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
