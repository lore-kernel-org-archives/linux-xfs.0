Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43078 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfGCRrI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 13:47:08 -0400
Subject: Re: [PATCH v2 1/1] xfsprogs: Fix uninitialized cfg->lsunit
References: <20190702232746.22516-1-allison.henderson@oracle.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6a2dd675-f392-dc72-4c8c-7061b9222b89@sandeen.net>
Date: Wed, 3 Jul 2019 12:47:06 -0500
MIME-Version: 1.0
In-Reply-To: <20190702232746.22516-1-allison.henderson@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On 7/2/19 6:27 PM, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
> left uninitialized when it should not.  This is because calc_stripe_factors
> in some cases needs cfg->loginternal to be set first.  This is done in
> validate_logdev. So move calc_stripe_factors below validate_logdev while
> parsing configs.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Ok, while I appreciate you taking Carlos's input, the patch now does
far more than the commit log says, with no explanation of why it's doing
so.  (and there's no indication of what actually changed in V2: - putting
that info below the "---" line is helpful)

I'd prefer to take the original patch and if we really want to change
how we initialize empty structures, that should be a separate patch, and
should hit everywhere we do it, not just mkfs.

But to Carlos's point, cfg->lsunit isn't exactly "uninitialized"
(to me, uninitialized means that it was never set, when in fact it was
initialized, to zero, right?)

So it's not quite clear to me what's happening here; I guess this test:

        /*
         * check that log sunit is modulo fsblksize or default it to dsunit.
         */
        if (lsunit) {
                /* convert from 512 byte blocks to fs blocks */
                cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
        } else if (cfg->sb_feat.log_version == 2 &&
                   cfg->loginternal && cfg->dsunit) {
                /* lsunit and dsunit now in fs blocks */
                cfg->lsunit = cfg->dsunit;
        }

is doing the wrong thing because cfg->loginternal hasn't actually been
evaluated yet?  Is there a mkfs command that demonstrates the problem
which could be included in the changelog?  Does it only happen with
external logs?  If you can provide a bit more information about when and
how this actually fails, that would improve the changelog for future
generations.

(also agreeing w/ darrick that these seem like little time bombs...)

Thanks,
-Eric

> ---
>  mkfs/xfs_mkfs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 468b8fd..6e32403 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3861,15 +3861,15 @@ main(
>  		.isdirect = LIBXFS_DIRECT,
>  		.isreadonly = LIBXFS_EXCLUSIVELY,
>  	};
> -	struct xfs_mount	mbuf = {};
> +	struct xfs_mount	mbuf = {0};
>  	struct xfs_mount	*mp = &mbuf;
>  	struct xfs_sb		*sbp = &mp->m_sb;
> -	struct fs_topology	ft = {};
> +	struct fs_topology	ft = {0};
>  	struct cli_params	cli = {
>  		.xi = &xi,
>  		.loginternal = 1,
>  	};
> -	struct mkfs_params	cfg = {};
> +	struct mkfs_params	cfg = {0};
>  
>  	/* build time defaults */
>  	struct mkfs_default_params	dft = {
> @@ -4008,7 +4008,6 @@ main(
>  	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
>  
>  	validate_rtextsize(&cfg, &cli, &ft);
> -	calc_stripe_factors(&cfg, &cli, &ft);
>  
>  	/*
>  	 * Open and validate the device configurations
> @@ -4018,6 +4017,7 @@ main(
>  	validate_datadev(&cfg, &cli);
>  	validate_logdev(&cfg, &cli, &logfile);
>  	validate_rtdev(&cfg, &cli, &rtfile);
> +	calc_stripe_factors(&cfg, &cli, &ft);
>  
>  	/*
>  	 * At this point when know exactly what size all the devices are,
> 
