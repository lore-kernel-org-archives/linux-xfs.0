Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94854C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 12:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F0F6145D
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 12:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhENMjv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 May 2021 08:39:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232712AbhENMjv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 May 2021 08:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620995919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s89697pCUJ2/vhg39Jx5slm0qUODWQos+MIXELMumZg=;
        b=YNUz11AmlR7YN2fiILhNe5houOMCipZa6LSmFGWnBQNuCgjl+vKsEB5hPJ462v4IPAo9/y
        35liN911CKfT+vUdAtguLLDxo/Yta5JLrA0DeA51g5LLif+yyx5VRuRlEBWMTkM/TGdxRa
        KwjQ7ZVagZQbwjyKHxD/b+IY34Uk0/U=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-TIjlK3L5NxiF5tk1SC6zsQ-1; Fri, 14 May 2021 08:38:38 -0400
X-MC-Unique: TIjlK3L5NxiF5tk1SC6zsQ-1
Received: by mail-qv1-f72.google.com with SMTP id d11-20020a0cdb0b0000b02901c0da4391d5so23766760qvk.12
        for <linux-xfs@vger.kernel.org>; Fri, 14 May 2021 05:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s89697pCUJ2/vhg39Jx5slm0qUODWQos+MIXELMumZg=;
        b=W64lVbxKYkghPlgCdIuhsZ7ZcH/Ux8yUVlcEADMXXjYsexvMeh98CD6NXW2rpQMtsp
         y0h36jlpgYGbPSIw9lozLUFrMwT39nhOT7NbLr8C2mBS52oGh9Wmak1Zx5WGFJ01QE3u
         6E6xPqEP/xxhAxRi2mpCoD+ZSiiyEmRyRd+PwG/bKJfuoCWRzd55jG7hUIsB/CTKUl50
         ef5aNGob8JNkHhhJcbc/FlwKPI9T2ZKIHvJ6J6wC/uVN5ewNhfChJt7+VT0CH9r007WQ
         BY3LvY7b4CqLSTUxw1SkhrVo/7fT/BIwLhehQNtTUc5nsxQcwU6gFboUdujSH6aKroqC
         I8VA==
X-Gm-Message-State: AOAM530hrFpnO1vzyOAv57rQtRGVkTWaX4RcENDoiTq5gY7BOLkE3qij
        TYBXAujlMObuF+X3ZdZdLtFScMKMV+6Wu9c7SHQ4VbG3BCVVdOoNMA570igJHMcG1vfGen/N3wI
        myEQBVVTMwKUSDkABGSzs
X-Received: by 2002:a37:447:: with SMTP id 68mr43308595qke.15.1620995917623;
        Fri, 14 May 2021 05:38:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZgo41kYFAVlfrhUVfJTRV/AbP4wqg80NIATgcQ7+nTHHd898NPYkfVrXFoUjbLxnDiBeHIA==
X-Received: by 2002:a37:447:: with SMTP id 68mr43308572qke.15.1620995917314;
        Fri, 14 May 2021 05:38:37 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id f12sm4538371qtj.26.2021.05.14.05.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:38:37 -0700 (PDT)
Date:   Fri, 14 May 2021 08:38:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: validate extsz hints against rt extent size
 when rtinherit is set
Message-ID: <YJ5vS+o3BydK1DrP@bfoster>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
 <162086771885.3685783.16422648250546171771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162086771885.3685783.16422648250546171771.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 06:01:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The RTINHERIT bit can be set on a directory so that newly created
> regular files will have the REALTIME bit set to store their data on the
> realtime volume.  If an extent size hint (and EXTSZINHERIT) are set on
> the directory, the hint will also be copied into the new file.
> 
> As pointed out in previous patches, for realtime files we require the
> extent size hint be an integer multiple of the realtime extent, but we
> don't perform the same validation on a directory with both RTINHERIT and
> EXTSZINHERIT set, even though the only use-case of that combination is
> to propagate extent size hints into new realtime files.  This leads to
> inode corruption errors when the bad values are propagated.
> 
> Strengthen the validation routine to avoid this situation and fix the
> open-coded unit conversion while we're at it.  Note that this is
> technically a breaking change to the ondisk format, but the risk should
> be minimal because (a) most vendors disable realtime, (b) letting
> unaligned hints propagate to new files would immediately crash the
> filesystem, and (c) xfs_repair flags such filesystems as corrupt, so
> anyone with such a configuration is broken already anyway.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Ok, so this looks more like a proper fix, but does this turn an existing
directory with (rtinherit && extszinherit) and a badly aligned extsz
hint into a read validation error?

Brian

>  fs/xfs/libxfs/xfs_inode_buf.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 5c9a7440d9e4..25261dd73290 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -569,19 +569,20 @@ xfs_inode_validate_extsize(
>  	uint16_t			mode,
>  	uint16_t			flags)
>  {
> -	bool				rt_flag;
> +	bool				rt_flag, rtinherit_flag;
>  	bool				hint_flag;
>  	bool				inherit_flag;
>  	uint32_t			extsize_bytes;
>  	uint32_t			blocksize_bytes;
>  
>  	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> +	rtinherit_flag = (flags & XFS_DIFLAG_RTINHERIT);
>  	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
>  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
>  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
>  
> -	if (rt_flag)
> -		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> +	if (rt_flag || (rtinherit_flag && inherit_flag))
> +		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
>  	else
>  		blocksize_bytes = mp->m_sb.sb_blocksize;
>  
> 

