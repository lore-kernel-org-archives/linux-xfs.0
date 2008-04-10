Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 21:35:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A4ZVQr031295
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 21:35:33 -0700
Subject: Re: [patch] fix logic error in xfs_alloc_ag_vextent_near()
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080410032555.GS108924158@sgi.com>
Date: Thu, 10 Apr 2008 14:36:43 +1000
Message-ID: <op.t9dofhqn3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080410032555.GS108924158@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, 10 Apr 2008 13:25:55 +1000, David Chinner <dgc@sgi.com> wrote:

> Fix a logic error in xfs_alloc_ag_vextent_near(). This is
> a regression introduced by the error handling changes.

Ah, I see how you made the mistake, looks good now.

(ie. was if (!xfs_alloc_compute_aligned() continue;)

> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.c	2008-04-10 10:00:50.000000000  
> +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.c	2008-04-10 13:10:17.948126881 +1000
> @@ -838,7 +838,7 @@ xfs_alloc_ag_vextent_near(
>  			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
>  			xfs_alloc_compute_aligned(ltbno, ltlen, args->alignment,
>  					args->minlen, &ltbnoa, &ltlena);
> -			if (ltlena >= args->minlen)
> +			if (ltlena < args->minlen)
>  				continue;
>  			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
>  			xfs_alloc_fix_len(args);
