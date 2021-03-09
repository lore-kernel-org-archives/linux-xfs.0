Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAF5C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 11:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF7C6523C
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 11:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhCILod (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 06:44:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230140AbhCILoH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 06:44:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615290247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TGo6yojRuiJ9sGJkBY1zj+k2Ph8CZE5LGAUMuXoHHvo=;
        b=M6J942yTW7vNZLrzA68fC+s71MiUsyHpXpJMErQMUDKiKibXbOIopZiDTCqmZxKIiz1Lxk
        Ej9f1O0lEZdv69HCq3kioznAIrqn1tFs6NTsm2xPpPxKpDd+P5fcVOYbwO+MqZrDCfAgMj
        8zwJ4smslAq4cfOjPc47kqMoxcpzTb4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-850w1hF8MWS3RXtSgT6fZw-1; Tue, 09 Mar 2021 06:44:05 -0500
X-MC-Unique: 850w1hF8MWS3RXtSgT6fZw-1
Received: by mail-wm1-f72.google.com with SMTP id z26so1018809wml.4
        for <linux-xfs@vger.kernel.org>; Tue, 09 Mar 2021 03:44:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=TGo6yojRuiJ9sGJkBY1zj+k2Ph8CZE5LGAUMuXoHHvo=;
        b=En4NTeXVm/QwKD8IPVxQfuvW1IDn/RY9bjQ5XnwcXzcVWhnSBw+Uqt7iWUz889Fqny
         7BDwpZPaJDOh9Wy+bD9fMrg/snVaQBQY4PMYnkp9buc6WtRxlQ3G8nmdBHlf0Z1glX2z
         oCDnaSwC8emoYfFuTNb2JXS3B+vM2O0ixoIeiVT4cr3zN+fiVoSDQDUD9w46eqDdnF+7
         U7MQajqElm9+jIjm7uqV8L0NXy9Ca6Fd7QJiSeDCsPyLtjBhDEB2S0qXE2o8Wq+FHOCu
         VnM6RJRay++aAAWmR0eWg/f0YOTBkE5LoqwuaB4dKi4ITmSpb4CnV9dmQVIQkEWD8w96
         DKEw==
X-Gm-Message-State: AOAM532h/G9wKEKUgwymm5BKLN4waAZgZRZ8QDqiphsSEVcjRqwKI36E
        HeZ4xlFgFVSVuFGWbB/wYfebaR4g8Y9df3yQlXFUS2IdZJAe+7YBaxFZKLqTrwUdeoEfdXzHCmT
        q9l6GRTswgnsG1OBZus3g
X-Received: by 2002:adf:cd8c:: with SMTP id q12mr27224132wrj.185.1615290244016;
        Tue, 09 Mar 2021 03:44:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwRfYklzBDMXGAfG9qkX6d6zGdj5Dv+arZl9dH7xrLER6eMfEOJYNKGYkdyzjpMK/86WFc5Tg==
X-Received: by 2002:adf:cd8c:: with SMTP id q12mr27224128wrj.185.1615290243865;
        Tue, 09 Mar 2021 03:44:03 -0800 (PST)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id n6sm4543294wrw.63.2021.03.09.03.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 03:44:03 -0800 (PST)
Date:   Tue, 9 Mar 2021 12:44:02 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: Skip repetitive warnings about mount options
Message-ID: <20210309114402.rivqafyo5l33mym4@andromeda.lan>
Mail-Followup-To: Pavel Reichl <preichl@redhat.com>,
        linux-xfs@vger.kernel.org
References: <20210224214323.394286-1-preichl@redhat.com>
 <20210224214323.394286-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224214323.394286-4-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 10:43:23PM +0100, Pavel Reichl wrote:
> Skip the warnings about mount option being deprecated if we are
> remounting and deprecated option state is not changing.
> 
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
> Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7e281d1139dc..ba113a28b631 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1155,6 +1155,22 @@ suffix_kstrtoint(
>  	return ret;
>  }
>  

Looks good indeed.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> +static inline void
> +xfs_fs_warn_deprecated(
> +	struct fs_context	*fc,
> +	struct fs_parameter	*param,
> +	uint64_t		flag,
> +	bool			value)
> +{
> +	/* Don't print the warning if reconfiguring and current mount point
> +	 * already had the flag set
> +	 */
> +	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
> +			!!(XFS_M(fc->root->d_sb)->m_flags & flag) == value)
> +		return;
> +	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
> +}
> +
>  /*
>   * Set mount state from a mount option.
>   *
> @@ -1294,19 +1310,19 @@ xfs_fs_parse_param(
>  #endif
>  	/* Following mount options will be removed in September 2025 */
>  	case Opt_ikeep:
> -		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
> +		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
>  		parsing_mp->m_flags |= XFS_MOUNT_IKEEP;
>  		return 0;
>  	case Opt_noikeep:
> -		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
> +		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, false);
>  		parsing_mp->m_flags &= ~XFS_MOUNT_IKEEP;
>  		return 0;
>  	case Opt_attr2:
> -		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
> +		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_ATTR2, true);
>  		parsing_mp->m_flags |= XFS_MOUNT_ATTR2;
>  		return 0;
>  	case Opt_noattr2:
> -		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
> +		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_NOATTR2, true);
>  		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
>  		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
>  		return 0;
> -- 
> 2.29.2
> 

-- 
Carlos

