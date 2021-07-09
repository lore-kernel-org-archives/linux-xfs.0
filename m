Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D8BC07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 08:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9078B613C9
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 08:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhGIIgG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 04:36:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhGIIgG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 04:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625819602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MS+YsjdtkNxq4zORqtX33/ETxzAerhNkn8k+82opvQw=;
        b=K0+Kr8lP0zf3jMup/jxjrhN9aymPwxC1lqZNPIejHiptZhw4k2QaJU/SoHJ7ey6vc6ubXa
        MwCP+sxVs1S86yoEHq9+RL3ty8c/tdr2Mq/yAzV+rO8h7SAoCcETXzBYsATtKt9lnUuadL
        NjUbedkw6/kcjytUgO5AoveZAAGuJ4g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-cCj3_jL4OQiDLYz60xaA5g-1; Fri, 09 Jul 2021 04:33:21 -0400
X-MC-Unique: cCj3_jL4OQiDLYz60xaA5g-1
Received: by mail-ed1-f69.google.com with SMTP id w15-20020a05640234cfb02903951279f8f3so4839210edc.11
        for <linux-xfs@vger.kernel.org>; Fri, 09 Jul 2021 01:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=MS+YsjdtkNxq4zORqtX33/ETxzAerhNkn8k+82opvQw=;
        b=SaXrTbf64ZLc/2jmIzjbfVaY//HdHBV4+hYlXP/rMP7mYJpnn4pdYboDbXM8UDmf1/
         e1LHns5Ho3y6AzeX/Rp0WBZA+SIHwo1WYXC90DoZu4nAShkXBhsqZqvTSFh3NXnl9Adl
         4/bmgWQNumB/f/xo9fcwcUNiRzT6MLPbUqLfalgpWPKQz3WJFgYGOYv/iHXa8L/YyB26
         MTdoMX0kKGhWnNtZQB+SOTeSSu6Mlmq/JiaxBzt6oZjToDJ1GVkofdnSa3OXMZRxd1ME
         KuS9wIVgMCcjSySuSUiq70Op8lFxv/5kxzmIpVjc37fbX6SM8OL2ZaZ5j6hcH2azk1Wd
         WnxA==
X-Gm-Message-State: AOAM532Fv2gP0sl/aOyy1sj3La6UWSzXlRJ9PrGeVEYaJHe9+0x7MFDC
        AHFl8X6ofUka6PpWh8sffqhW2A4MGYli6nDIAvtSS9zD4uGQibW1LXtiK8cw6hqpGQB+DoXMzD9
        fj+YtA1berl8IMib7UDWT
X-Received: by 2002:a17:906:38f:: with SMTP id b15mr10427675eja.186.1625819600215;
        Fri, 09 Jul 2021 01:33:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyd/Q1DFqF/YPG/pEGD3LVVwvVJggn1beq10a6jI6vvRi+Dat8ciRvgCqJtF3AkN2FYDQTI4w==
X-Received: by 2002:a17:906:38f:: with SMTP id b15mr10427658eja.186.1625819599970;
        Fri, 09 Jul 2021 01:33:19 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id p23sm2603512edt.71.2021.07.09.01.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 01:33:19 -0700 (PDT)
Date:   Fri, 9 Jul 2021 10:33:17 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: correct the narrative around misaligned
 rtinherit/extszinherit dirs
Message-ID: <20210709083317.rwglsgg5ma7xwxim@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20210709041152.GN11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709041152.GN11588@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 08, 2021 at 09:11:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While auditing the realtime growfs code, I realized that the GROWFSRT
> ioctl (and by extension xfs_growfs) has always allowed sysadmins to
> change the realtime extent size when adding a realtime section to the
> filesystem.  Since we also have always allowed sysadmins to set
> RTINHERIT and EXTSZINHERIT on directories even if there is no realtime
> device, this invalidates the premise laid out in the comments added in
> commit 603f000b15f2.
> 
> In other words, this is not a case of inadequate metadata validation.
> This is a case of nearly forgotten (and apparently untested) but
> supported functionality.  Update the comments to reflect what we've
> learned, and remove the log message about correcting the misalignment.
> 
> Fixes: 603f000b15f2 ("xfs: validate extsz hints against rt extent size when rtinherit is set")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   |   28 ++++++++++++++++------------
>  fs/xfs/libxfs/xfs_trans_inode.c |   10 ++++------
>  fs/xfs/xfs_ioctl.c              |    8 ++++----
>  3 files changed, 24 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 04ce361688f7..84ea2e0af9f0 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -592,23 +592,27 @@ xfs_inode_validate_extsize(
>  	/*
>  	 * This comment describes a historic gap in this verifier function.
>  	 *
> -	 * On older kernels, the extent size hint verifier doesn't check that
> -	 * the extent size hint is an integer multiple of the realtime extent
> -	 * size on a directory with both RTINHERIT and EXTSZINHERIT flags set.
> -	 * The verifier has always enforced the alignment rule for regular
> -	 * files with the REALTIME flag set.
> +	 * For a directory with both RTINHERIT and EXTSZINHERIT flags set, this
> +	 * function has never checked that the extent size hint is an integer
> +	 * multiple of the realtime extent size.  Since we allow users to set
> +	 * this combination  on non-rt filesystems /and/ to change the rt
> +	 * extent size when adding a rt device to a filesystem, the net effect
> +	 * is that users can configure a filesystem anticipating one rt
> +	 * geometry and change their minds later.  Directories do not use the
> +	 * extent size hint, so this is harmless for them.
>  	 *
>  	 * If a directory with a misaligned extent size hint is allowed to
>  	 * propagate that hint into a new regular realtime file, the result
>  	 * is that the inode cluster buffer verifier will trigger a corruption
> -	 * shutdown the next time it is run.
> +	 * shutdown the next time it is run, because the verifier has always
> +	 * enforced the alignment rule for regular files.
>  	 *
> -	 * Unfortunately, there could be filesystems with these misconfigured
> -	 * directories in the wild, so we cannot add a check to this verifier
> -	 * at this time because that will result a new source of directory
> -	 * corruption errors when reading an existing filesystem.  Instead, we
> -	 * permit the misconfiguration to pass through the verifiers so that
> -	 * callers of this function can correct and mitigate externally.
> +	 * Because we allow administrators to set a new rt extent size when
> +	 * adding a rt section, we cannot add a check to this verifier because
> +	 * that will result a new source of directory corruption errors when
> +	 * reading an existing filesystem.  Instead, we rely on callers to
> +	 * decide when alignment checks are appropriate, and fix things up as
> +	 * needed.
>  	 */
>  
>  	if (rt_flag)
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 8d595a5c4abd..16f723ebe8dd 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -143,16 +143,14 @@ xfs_trans_log_inode(
>  	}
>  
>  	/*
> -	 * Inode verifiers on older kernels don't check that the extent size
> -	 * hint is an integer multiple of the rt extent size on a directory
> -	 * with both rtinherit and extszinherit flags set.  If we're logging a
> -	 * directory that is misconfigured in this way, clear the hint.
> +	 * Inode verifiers do not check that the extent size hint is an integer
> +	 * multiple of the rt extent size on a directory with both rtinherit
> +	 * and extszinherit flags set.  If we're logging a directory that is
> +	 * misconfigured in this way, clear the hint.
>  	 */
>  	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
>  	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
>  	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
> -		xfs_info_once(ip->i_mount,
> -	"Correcting misaligned extent size hint in inode 0x%llx.", ip->i_ino);
>  		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
>  				   XFS_DIFLAG_EXTSZINHERIT);
>  		ip->i_extsize = 0;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0f6794333b01..cfc2e099d558 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1292,10 +1292,10 @@ xfs_ioctl_setattr_check_extsize(
>  	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
>  
>  	/*
> -	 * Inode verifiers on older kernels don't check that the extent size
> -	 * hint is an integer multiple of the rt extent size on a directory
> -	 * with both rtinherit and extszinherit flags set.  Don't let sysadmins
> -	 * misconfigure directories.
> +	 * Inode verifiers do not check that the extent size hint is an integer
> +	 * multiple of the rt extent size on a directory with both rtinherit
> +	 * and extszinherit flags set.  Don't let sysadmins misconfigure
> +	 * directories.
>  	 */
>  	if ((new_diflags & XFS_DIFLAG_RTINHERIT) &&
>  	    (new_diflags & XFS_DIFLAG_EXTSZINHERIT)) {
> 

-- 
Carlos

