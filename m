Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79F3C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DD336100C
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbhCaQbT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233900AbhCaQbP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Mar 2021 12:31:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE10761008;
        Wed, 31 Mar 2021 16:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617208274;
        bh=UeNbagI1q92mBQahy0ky8joWqj1cI27Q5z5zyIFItO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ce7JLO+z/cvsY7Xu+piFHQSU9xrZc1aqvHAitJzhnpewm0ZKjZ/NjWRImw8QbH6Ro
         xuQ8zY8IK14AtY1cNtwh7HIFc9vSMc2kwEuRFq6CW8ssBgJ4jQBZQHMSlLCh/7YTsi
         UzFAHGearvSQTtjteQuVkDQz/IlRxGjLMKi2EgHMiYwkPg9BROLiyyGCSb4+n9ZEP1
         C81GXEou0j5pSuTQFsN04XgCQZpHnzI/SNiydUMNQr67I/Wxoo5NjEo6LlzVRFfe+l
         hs+2KhciKUaM7z/s8ih7/sSJwFmzQMer+XxpszAflDWMGYTtaRLmPpJQdM6FZrh4Cb
         fwvpVGLndzpgQ==
Date:   Wed, 31 Mar 2021 09:31:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: deprecate BMV_IF_NO_DMAPI_READ flag
Message-ID: <20210331163114.GC4090233@magnolia>
References: <20210331162617.17604-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331162617.17604-1-ailiop@suse.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 06:26:16PM +0200, Anthony Iliopoulos wrote:
> Use of the flag has had no effect since kernel commit 288699fecaff
> ("xfs: drop dmapi hooks"), which removed all dmapi related code, so
> deprecate it.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> ---
> changes since v1:
>  - retain flag definition to prevent reuse and not break kabi, per
>    Darrick's suggestion.
> 
>  fs/xfs/libxfs/xfs_fs.h | 4 ++--
>  fs/xfs/xfs_ioctl.c     | 2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 6fad140d4c8e..4ef813e00e9e 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -65,13 +65,13 @@ struct getbmapx {
>  
>  /*	bmv_iflags values - set by XFS_IOC_GETBMAPX caller.	*/
>  #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
> -#define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
> +#define BMV_IF_NO_DMAPI_READ	0x2	/* Deprecated */
>  #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
>  #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
>  #define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
>  #define BMV_IF_COWFORK		0x20	/* return CoW fork rather than data */
>  #define BMV_IF_VALID	\
> -	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
> +	(BMV_IF_ATTRFORK|BMV_IF_PREALLOC|	\
>  	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES|BMV_IF_COWFORK)

What about the xfs/296 regression that the kernel robot reported?

I /think/ that's a result of removing this flag from BMV_IF_VALID, which
is used to reject unknown input flags from the GETBMAP caller.  In the
current upstream the flag is valid even if it does nothing, so we have
to preserve that behavior.

--D

>  
>  /*	bmv_oflags values - returned for each non-header segment */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 99dfe89a8d08..9d3f72ef1efe 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1669,8 +1669,6 @@ xfs_ioc_getbmap(
>  		bmx.bmv_iflags = BMV_IF_ATTRFORK;
>  		/*FALLTHRU*/
>  	case XFS_IOC_GETBMAP:
> -		if (file->f_mode & FMODE_NOCMTIME)
> -			bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
>  		/* struct getbmap is a strict subset of struct getbmapx. */
>  		recsize = sizeof(struct getbmap);
>  		break;
> -- 
> 2.31.0
> 
