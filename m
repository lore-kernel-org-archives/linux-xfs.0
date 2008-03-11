Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 18:55:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2B1tJCd007297
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 18:55:21 -0700
Date: Mon, 10 Mar 2008 21:55:49 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: Final call for review of sb_bad_features2 in userspace
Message-ID: <20080311015549.GB8870@josefsipek.net>
References: <op.t7ky1txm3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t7ky1txm3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Thu, Mar 06, 2008 at 05:02:07PM +1100, Barry Naujok wrote:
> I think the attached patch maybe the least offensive for past
> kernels, and XFSQA!
>
> xfs_check and xfs_repair will ignore sb_bad_features2 if it is
> zero, and if not, makes sure it's the same as sb_features2.
>
> mkfs.xfs will set sb_bad_features2 to be the same. Maybe if
> we change the behaviour of the kernel mount code with
> respects of sb_bad_features2, this can be revisited.
>
> (An intermediate solution I has was if "xfs_repair -n" is
> run AND sb_bad_features is zero, then ignore it to let
> xfs_repair continue, otherwise duplicate it, but doing
> that requires a golden output change to QA 030 and 033
> unless the kernel mount code is changed... ARGH!)

Tiny comments below, but either way, looks good.

Josef 'Jeff' Sipek.


> ===========================================================================
> xfsprogs/db/check.c
> ===========================================================================
>
> --- a/xfsprogs/db/check.c	2008-03-06 16:59:31.000000000 +1100
> +++ b/xfsprogs/db/check.c	2008-03-06 12:32:54.664882390 +1100
> @@ -869,6 +869,15 @@ blockget_f(
>  				mp->m_sb.sb_frextents, frextents);
>  		error++;
>  	}
> +	if (mp->m_sb.sb_bad_features2 != 0 &&
> +			mp->m_sb.sb_bad_features2 != mp->m_sb.sb_features2) {

cosmetic: I'd align the second line to have the sb-> start in the same
column :) It looks kinda odd to have the second line as indented as the
dbprintf few lines later.

> +		if (!sflag)
> +			dbprintf("sb_features2 (0x%x) not same as "
> +				"sb_bad_features2 (0x%x)\n",
> +				mp->m_sb.sb_features2,
> +				mp->m_sb.sb_bad_features2);
> +		error++;
> +	}
>  	if ((sbversion & XFS_SB_VERSION_ATTRBIT) &&
>  	    !XFS_SB_VERSION_HASATTR(&mp->m_sb)) {
>  		if (!sflag)
>
...
> ===========================================================================
> xfsprogs/include/xfs_sb.h
> ===========================================================================
>
> --- a/xfsprogs/include/xfs_sb.h	2008-03-06 16:59:31.000000000 +1100
> +++ b/xfsprogs/include/xfs_sb.h	2008-02-29 17:16:33.814417687 +1100
> @@ -151,6 +151,7 @@ typedef struct xfs_sb
>  	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
>  	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
>  	__uint32_t	sb_features2;	/* additional feature bits */
> +	__uint32_t	sb_bad_features2; /* unusable space */
>  } xfs_sb_t;

__attribute__((packed))  ?

...
> ===========================================================================
> xfsprogs/repair/phase1.c
> ===========================================================================
>
> --- a/xfsprogs/repair/phase1.c	2008-03-06 16:59:31.000000000 +1100
> +++ b/xfsprogs/repair/phase1.c	2008-03-06 16:57:40.021125442 +1100
> @@ -91,6 +91,20 @@ phase1(xfs_mount_t *mp)
>  		primary_sb_modified = 1;
>  	}
>
> +	/*
> +	 * Check bad_features2 and make sure features2 the same as
> +	 * bad_features (ORing the two together). Leave bad_features2
> +	 * set so older kernels can still use it and not mount unsupported
> +	 * filesystems when it reads bad_features2.
> +	 */
> +	if (sb->sb_bad_features2 != 0 &&
> +			sb->sb_bad_features2 != sb->sb_features2) {

Same as the check.c comment above.

-- 
You measure democracy by the freedom it gives its dissidents, not the
freedom it gives its assimilated conformists.
		- Abbie Hoffman
