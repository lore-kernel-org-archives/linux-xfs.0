Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2948C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 02:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9052664ED1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 02:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhBYClu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 21:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhBYClu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 21:41:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F6D36146B;
        Thu, 25 Feb 2021 02:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614220869;
        bh=8T+cuQvEJ4HfPxpCl/bC08eklcknk4YQmXPl1RGDedU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p6oWjxkT08XpRa86h8gua5cMlESA1n/T/oSZbGC72PZDr5+q5qS8Hprg3qjepz7vW
         dFn6GQwC5Xkz4UlLwpE8XTM39TPtGG1FwdimwdaqYzwTXk8ky2hxFRmIQgWQLcT1nM
         1tQjpw/ua9Bs0tSQqVQw5Xjld5L3MtsrnOz5J7y8iz4XtZEd9D7s4ga86HhL8rzWkX
         qv4TNudV0ItwzIWKZgGIdQjuucZctX0kDe5Gd2kkvQ4bZTtPrZyJtGfyI16+upokqU
         pYHCbrdl2XOpVgUR+icVmKpb0oEnQ5IQTQ1A/RlqjKMV0wnlGxbi68DoiuIjYGCFuJ
         nRSImcCuy62wg==
Date:   Wed, 24 Feb 2021 18:41:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: Skip repetitive warnings about mount options
Message-ID: <20210225024109.GI7272@magnolia>
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

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

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
