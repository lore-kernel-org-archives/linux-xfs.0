Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAA7C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 21:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BAED64E02
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 21:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhBVV3S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 16:29:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232008AbhBVV3L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 16:29:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF1AA60295;
        Mon, 22 Feb 2021 21:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614029310;
        bh=OT4UOGUVUbuC+S4M2wLXDQgDkHIL+pPxropHv++OmgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qH/FF/Wy7Wdvv9Pp0UZ8tt27w3zspVPxoak0zIzHNz/V9mHJtIFX7GdmNOW2Ehfpw
         E57K8jz2DnpSJtlzJXxkFfQDVyH4xqc19CwAbi05zYbiIgzN9f7V1Bcl7wlBfM+Gtm
         muYP1kK+grATWH2s2dne/iIip4BLPR7rqgdXQsSV1anbfcsGkHGYfhWnIKQt3fk+EM
         DIwAfbiP6lFEKar1UVnptLj/5d+h7Sg3N/uc+9yeAj36gEbPpy6dessPTeNnfXdPLO
         wcWH6VDwkrPOsPh5hPunmiqsAO/8a8zCCrzLMQUmNG8o4JNM88wG5LNVjfwBjGilsT
         KhmU3AgUp2fBQ==
Date:   Mon, 22 Feb 2021 13:28:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: Skip repetitive warnings about mount options
Message-ID: <20210222212830.GE7272@magnolia>
References: <20210220221549.290538-1-preichl@redhat.com>
 <20210220221549.290538-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220221549.290538-3-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 20, 2021 at 11:15:49PM +0100, Pavel Reichl wrote:
> Skip the warnings about mount option being deprecated if we are
> remounting and deprecated option state is not changing.
> 
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
> Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 813be879a5e5..6724a7018d1f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1169,6 +1169,13 @@ xfs_fs_parse_param(
>  	struct fs_parse_result	result;
>  	int			size = 0;
>  	int			opt;
> +	uint64_t                prev_m_flags = 0; /* Mount flags of prev. mount */

Nit: spaces here^^^^^^^^^^^^^^^^ should be tabs.

> +	bool			remounting = fc->purpose & FS_CONTEXT_FOR_RECONFIGURE;
> +
> +	/* if reconfiguring then get mount flags of previous flags */
> +	if (remounting) {
> +		prev_m_flags  = XFS_M(fc->root->d_sb)->m_flags;
> +	}
>  
>  	opt = fs_parse(fc, xfs_fs_parameters, param, &result);
>  	if (opt < 0)
> @@ -1294,19 +1301,27 @@ xfs_fs_parse_param(
>  #endif
>  	/* Following mount options will be removed in September 2025 */
>  	case Opt_ikeep:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		if (!remounting ||  !(prev_m_flags & XFS_MOUNT_IKEEP)) {
> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		}

/me wonders if these could be refactored into a common helper, though I
can't really think of anything less clunky than:

static inline void
xfs_fs_warn_deprecated(
	struct fs_context	*fc,
	struct fs_parameter	*param)
	uint64_t		flag,
	bool			value);
{
	uint64_t		prev_m_flags;

	if (!(fc->purpose & FS_CONTEXT_FOR_RECONFIGURE))
		goto warn;
	prev_m_flags  = XFS_M(fc->root->d_sb)->m_flags;
	if (!!(prev_m_flags & flag) == value)
		goto warn;
	return;
warn:
	xfs_warn(mp, "%s mount option is deprecated.", param->key);
}
...
	case Opt_ikeep:
		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
		mp->m_flags |= XFS_MOUNT_IKEEP;
		break;
	case Opt_noikeep:
		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, false);
		mp->m_flags &= ~XFS_MOUNT_IKEEP;
		break;

Thoughts?

--D

>  		mp->m_flags |= XFS_MOUNT_IKEEP;
>  		return 0;
>  	case Opt_noikeep:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		if (!remounting || prev_m_flags & XFS_MOUNT_IKEEP) {
> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		}
>  		mp->m_flags &= ~XFS_MOUNT_IKEEP;
>  		return 0;
>  	case Opt_attr2:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		if (!remounting || !(prev_m_flags & XFS_MOUNT_ATTR2)) {
> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		}
>  		mp->m_flags |= XFS_MOUNT_ATTR2;
>  		return 0;
>  	case Opt_noattr2:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		if (!remounting || !(prev_m_flags & XFS_MOUNT_NOATTR2)) {
> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		}
>  		mp->m_flags &= ~XFS_MOUNT_ATTR2;
>  		mp->m_flags |= XFS_MOUNT_NOATTR2;
>  		return 0;
> -- 
> 2.29.2
> 
