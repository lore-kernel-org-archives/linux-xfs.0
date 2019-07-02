Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41547 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfGBI0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 04:26:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so16701760wrm.8
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2019 01:26:11 -0700 (PDT)
Date: Tue, 2 Jul 2019 10:26:08 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/1] xfsprogs: Fix uninitialized cfg->lsunit
Message-ID: <20190702082608.ju5gvqpo2twmm2eh@pegasus.maiolino.io>
References: <20190701173538.29710-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190701173538.29710-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi,

On Mon, Jul 01, 2019 at 10:35:38AM -0700, Allison Collins wrote:
> While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
> left uninitialized when it should not.  This is because calc_stripe_factors
> in some cases needs cfg->loginternal to be set first.  This is done in
> validate_logdev. So move calc_stripe_factors below validate_logdev while
> parsing configs.
> 

I believe cfg->lsunit will be left 'uninitialized' every time if it is not
explicitly set in mkfs command line.

I believe you are referring to this specific part of the code here:

┆       if (lsunit) {
┆       ┆       /* convert from 512 byte blocks to fs blocks */
┆       ┆       cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
┆       } else if (cfg->sb_feat.log_version == 2 && 
┆       ┆          cfg->loginternal && cfg->dsunit) {
┆       ┆       /* lsunit and dsunit now in fs blocks */
┆       ┆       cfg->lsunit = cfg->dsunit;
┆       }

Which, well, unless we set lsunit at command line, we will always fall into the
else if and leave cfg->lsunit uninitialized, once we still don't have
cfg->loginternal set.

This is 'okayish' because we initialize the cfg structure here in main:

struct mkfs_params┆     cfg = {};


By default (IIRC), GCC will initialize to 0 all members of the struct, so, we
are 'safe' here in any case. But, at the same time, (also IIRC), structs should
not be initialized by empty braces (according to ISO C).

So, while I agree with your patch, while you're still on it, could you please
also (and if others agree), properly initialize the structs in main(){}?

Like:

@@ -3848,15 +3849,15 @@ main(
                .isdirect = LIBXFS_DIRECT,
                .isreadonly = LIBXFS_EXCLUSIVELY,
        };
-       struct xfs_mount        mbuf = {};
+       struct xfs_mount        mbuf = {0};
        struct xfs_mount        *mp = &mbuf;
        struct xfs_sb           *sbp = &mp->m_sb;
-       struct fs_topology      ft = {};
+       struct fs_topology      ft = {0};
        struct cli_params       cli = {
                .xi = &xi,
                .loginternal = 1,
        };
-       struct mkfs_params      cfg = {};
+       struct mkfs_params      cfg = {0};
 



Anyway, this is more a suggestion due ISO C 'formalities' (which I *think* GCC
would complain if -Wpedantic was enabled), otherwise I can send a patch later
changing that, if you decide to go with your patch as-is, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cheers

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ddb25ec..f4a5e4b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3995,7 +3995,6 @@ main(
>  	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
>  
>  	validate_rtextsize(&cfg, &cli, &ft);
> -	calc_stripe_factors(&cfg, &cli, &ft);
>  
>  	/*
>  	 * Open and validate the device configurations
> @@ -4005,6 +4004,7 @@ main(
>  	validate_datadev(&cfg, &cli);
>  	validate_logdev(&cfg, &cli, &logfile);
>  	validate_rtdev(&cfg, &cli, &rtfile);
> +	calc_stripe_factors(&cfg, &cli, &ft);
>  
>  	/*
>  	 * At this point when know exactly what size all the devices are,
> -- 
> 2.7.4
> 

-- 
Carlos
