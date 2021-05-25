Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEABC2B9F8
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 10:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9794161423
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 10:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhEYKuk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 06:50:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230514AbhEYKuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 06:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621939749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hnY+EGYsk7Eny3DcoZUZ8VTXqv2LVASAENBO9wVrE+E=;
        b=YGiZjhtc+A+mbcD73UbTM5OltuY7kxWFico0NPoec98rtAFgKJ2KuCKZs4AEPqrYhYEyBr
        HVEydKX2s5hctyQriniOWoWPZecB34dkSm79C+ORbHgpl5OAngIQAyX74uf5h/2utfqBj2
        A6WI+7zkWUl35PSHFSOE5VGeLlUuTl0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-1S-KJS1CPzaoSSj662yRxw-1; Tue, 25 May 2021 06:49:06 -0400
X-MC-Unique: 1S-KJS1CPzaoSSj662yRxw-1
Received: by mail-ed1-f71.google.com with SMTP id w22-20020a05640234d6b029038d04376b6aso17031188edc.21
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 03:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=hnY+EGYsk7Eny3DcoZUZ8VTXqv2LVASAENBO9wVrE+E=;
        b=pDRkYj6mMagKMvIJxqto9KYM7GAto7jC1Gm/fXvDKVi9cDG84yFWiKhdu3Pu0VWvcj
         KqU5GYok0W467Jx4lhVD+he4Rste2BMFBXvSMBtD7m8JBv+2mxtMFAUZ3qZAGvLYQdxX
         dEf7GKhAZcz3uxl5xS3OSD1brmwwPS4ZUQr3wUbzpRsqM5ZhaldcUjfibZfEAaJDhNnA
         1yOYnhCKLKljMGYwnJSKW2OBAk3l/XU149QHJjY2OGRZLR+2W2F36mZjSRkgu4KFaXHg
         rcjRPwn27qlT5E0KJrUsotLxArERSU3VLrneHO7cGZcu+0CJRy6KeUtdm/Iim22SEh3I
         Lt5Q==
X-Gm-Message-State: AOAM531iH+VINCqYGGFd/qtJzYx/+oNor5JHKCUvotQIQsQ99lYieq/x
        nLrxDsRIyAFeuKG0UDH5t2UFCIAaWoqWVdNKHtnRhxbVCvIivbt057dw5w8bFWQ0HSZ0wu5APDo
        NnZSLSbuNQx+D4SHEnJoe
X-Received: by 2002:a17:906:f885:: with SMTP id lg5mr27839975ejb.313.1621939744917;
        Tue, 25 May 2021 03:49:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxx0KDd7jgPg4TduQW5geTH/hV8Kcc293QrbftOYZEsKHQYEOw9Vc/a1jJK0v3NuJkwh6MWqw==
X-Received: by 2002:a17:906:f885:: with SMTP id lg5mr27839963ejb.313.1621939744714;
        Tue, 25 May 2021 03:49:04 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id p7sm10793844edw.43.2021.05.25.03.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 03:49:04 -0700 (PDT)
Date:   Tue, 25 May 2021 12:49:02 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Subject: Re: [PATCH v3] xfs: validate extsz hints against rt extent size when
 rtinherit is set
Message-ID: <20210525104902.sjch56wbtvav5wcr@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
References: <20210525061531.GF202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525061531.GF202121@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick.

On Mon, May 24, 2021 at 11:15:31PM -0700, Darrick J. Wong wrote:
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
> Because there may be existing filesystems with such a configuration, we
> cannot simply amend the inode verifier to trip on these directories and
> call it a day because that will cause previously "working" filesystems
> to start throwing errors abruptly.  Note that it's valid to have
> directories with rtinherit set even if there is no realtime volume, in
> which case the problem does not manifest because rtinherit is ignored if
> there's no realtime device; and it's possible that someone set the flag,
> crashed, repaired the filesystem (which clears the hint on the realtime
> file) and continued.
> 
> Therefore, mitigate this issue in several ways: First, if we try to
> write out an inode with both rtinherit/extszinherit set and an unaligned
> extent size hint, turn off the hint to correct the error.  Second, if
> someone tries to misconfigure a directory via the fssetxattr ioctl, fail
> the ioctl.  Third, reverify both extent size hint values when we
> propagate heritable inode attributes from parent to child, to prevent
> misconfigurations from spreading.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: disable incorrect hints at runtime instead of whacking filesystems
>     with verifier errors
> v3: revise the comment in the verifier to describe the source of the
>     problem, the observable symptoms, and how the solution fits the
>     historical context

IMHO the patch is fine, I have just one comment I'd like to address though:

> +	/*
> +	 * Inode verifiers on older kernels don't check that the extent size
> +	 * hint is an integer multiple of the rt extent size on a directory
> +	 * with both rtinherit and extszinherit flags set.  If we're logging a
> +	 * directory that is misconfigured in this way, clear the hint.
> +	 */
> +	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> +	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> +	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
> +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> +				   XFS_DIFLAG_EXTSZINHERIT);
> +		ip->i_extsize = 0;
> +		flags |= XFS_ILOG_CORE;
> +	}
> +
...
> +	 * that we don't let broken hints propagate.
> +	 */
> +	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
> +			VFS_I(ip)->i_mode, ip->i_diflags);
> +	if (failaddr) {
> +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> +				   XFS_DIFLAG_EXTSZINHERIT);
> +		ip->i_extsize = 0;
> +	}
>  }

...
> +	/* Don't let invalid cowextsize hints propagate. */
> +	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
> +			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
> +	if (failaddr) {
> +		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> +		ip->i_cowextsize = 0;
> +	}
>  }

In all cases above, wouldn't be interesting to at least log the fact we are
resetting the extent size? At least in debug mode? This may let users clueless
on why the extent size has been reset, or at least give us some debug data when
required?


The patch itself looks fine, with or without logging the extsize reset, you can
add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cheers

>  
>  /*
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6407921aca96..1fe4c1fc0aea 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1291,6 +1291,21 @@ xfs_ioctl_setattr_check_extsize(
>  
>  	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
>  
> +	/*
> +	 * Inode verifiers on older kernels don't check that the extent size
> +	 * hint is an integer multiple of the rt extent size on a directory
> +	 * with both rtinherit and extszinherit flags set.  Don't let sysadmins
> +	 * misconfigure directories.
> +	 */
> +	if ((new_diflags & XFS_DIFLAG_RTINHERIT) &&
> +	    (new_diflags & XFS_DIFLAG_EXTSZINHERIT)) {
> +		unsigned int	rtextsize_bytes;
> +
> +		rtextsize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> +		if (fa->fsx_extsize % rtextsize_bytes)
> +			return -EINVAL;
> +	}
> +
>  	failaddr = xfs_inode_validate_extsize(ip->i_mount,
>  			XFS_B_TO_FSB(mp, fa->fsx_extsize),
>  			VFS_I(ip)->i_mode, new_diflags);
> 

-- 
Carlos

