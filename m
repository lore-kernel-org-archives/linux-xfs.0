Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65425C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 15:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D47661A1A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 15:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhCZPba (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 11:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhCZPbQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 11:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED59F61A1A;
        Fri, 26 Mar 2021 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616772676;
        bh=zaMYBhtv3s52vYyrmTfPUAkwohe8m0QP8GScyWIJ4V8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pbZrt8MAl7vTT7uh5ptVlDZQjo6tQroKrG53UeRu+st3WqcTcD0QwXnipyvSAyLCW
         Dvbc3bAplz6dzIdqFY8QmUniu8doMSR9YkHOOXq+iTu65Ycvg3iMvcAmYfcUUlXNZn
         CdoIiTSpfPXAxRQBjjN4Zbn2HcyjFuXqH9DiTMhvbaaDE6+5IW9u4z2NISub6LMtTW
         iq0D4uxwcrmi/g0AW4WZJvzBw4LPOg5jHxoPZi+6+ahnwHqxzjwUf0AlSiHOvQW2UG
         MlW6tJK7txlAsWCE06LsqRBUv/+3mp3HJpAdoqk3PrIevY8H4aGr2yP+INU1tEs76V
         kL4nGWNDqNk8Q==
Date:   Fri, 26 Mar 2021 08:31:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove BMV_IF_NO_DMAPI_READ flag
Message-ID: <20210326153115.GT4090233@magnolia>
References: <20210326125321.28047-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326125321.28047-1-ailiop@suse.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 01:53:19PM +0100, Anthony Iliopoulos wrote:
> Use of the flag has had no effect since kernel commit 288699fecaff
> ("xfs: drop dmapi hooks"), which removed all dmapi related code, so
> drop it completely.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h | 3 +--
>  fs/xfs/xfs_ioctl.c     | 2 --
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 6fad140d4c8e..23da047c3098 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -65,13 +65,12 @@ struct getbmapx {
>  
>  /*	bmv_iflags values - set by XFS_IOC_GETBMAPX caller.	*/
>  #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
> -#define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */

I don't think we can drop this definition completely.  Something has to
be here to discourage anyone from reusing 0x2, since there are
undoubtedly programs out there that will check for this.  It's also not
a good idea to break kabi by removing names.

#define BMV_IF_NO_DMAPI_READ	0x2	/* Deprecated */

(Everything else in the patch looks fine.)

--D

>  #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
>  #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
>  #define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
>  #define BMV_IF_COWFORK		0x20	/* return CoW fork rather than data */
>  #define BMV_IF_VALID	\
> -	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
> +	(BMV_IF_ATTRFORK|BMV_IF_PREALLOC|	\
>  	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES|BMV_IF_COWFORK)
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
