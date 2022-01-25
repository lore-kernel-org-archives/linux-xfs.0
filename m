Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66F8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 02:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3417756AbiAYCLJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3416009AbiAYByA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 20:54:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D6BC0C27C0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 16:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D85E161208
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 00:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3901AC340EE;
        Tue, 25 Jan 2022 00:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643070836;
        bh=q9WO1JWhgevFf9egr4fJd9pQaqOBH8rUiW7iwTvFs+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SgvnMufbTlsoaqm4I5aF5ULMaE5BlycNq87fl+S2BXzWEz8g1LzXIBvHeGDlrAhBI
         v8vT6ZNHspqaxoAwFtMM3jxQBAvLuqwkunVA4+H3mkwTjj8C6L/jrAiXn9FSYdbQPG
         vNo0lEHWDbcta4xOtnbDI62KiDCr7/hzkXtGFzV1OM/ku2lHvW9Yq+lbyAAtEB4HtI
         5l+iu1lWSDkMZIQ5oAra/rv0isXzf80CRBw9ZOoQWwW2PbPCLSIAEJz+49EuS6E3gl
         HImyzOYhDBkgVuWgdiWDQKJhAtR6OC4yIagHVWo14703KLjw8Bo3vzz/+6xfXxVZZB
         F2j2EIU6szgXQ==
Date:   Mon, 24 Jan 2022 16:33:55 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 18/20] xfsprogs: Add mkfs option to create filesystem
 with large extent counters
Message-ID: <20220125003355.GX13540@magnolia>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
 <20220121052019.224605-19-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121052019.224605-19-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> xfsprogs: Add mkfs option to create filesystem with large extent
> counters

This ought to be shorter and more direct about this being an mkfs
patch:

"mkfs: add option to create filesystem with large extent counters"

On Fri, Jan 21, 2022 at 10:50:17AM +0530, Chandan Babu R wrote:
> Enabling nrext64 option on mkfs.xfs command line extends the maximum values of
> inode data and attr fork extent counters to 2^48 - 1 and 2^32 - 1
> respectively.  This also sets the XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag
> on the superblock preventing older kernels from mounting such a filesystem.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  man/man8/mkfs.xfs.8.in |  7 +++++++
>  mkfs/lts_4.19.conf     |  1 +
>  mkfs/lts_5.10.conf     |  1 +
>  mkfs/lts_5.15.conf     |  1 +
>  mkfs/lts_5.4.conf      |  1 +
>  mkfs/xfs_mkfs.c        | 23 +++++++++++++++++++++++
>  6 files changed, 34 insertions(+)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index a3526753..7d764f19 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -647,6 +647,13 @@ space over time such that no free extents are large enough to
>  accommodate a chunk of 64 inodes. Without this feature enabled, inode
>  allocations can fail with out of space errors under severe fragmented
>  free space conditions.
> +.TP
> +.BI nrext64[= value]
> +Extend maximum values of inode data and attr fork extent counters from 2^31 -
> +1 and 2^15 - 1 to 2^48 - 1 and 2^32 - 1 respectively. If the value is
> +omitted, 1 is assumed. This feature is disabled by default. This feature is
> +only available for filesystems formatted with -m crc=1.
> +.TP
>  .RE
>  .PP
>  .PD 0
> diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
> index d21fcb7e..751be45e 100644
> --- a/mkfs/lts_4.19.conf
> +++ b/mkfs/lts_4.19.conf
> @@ -2,6 +2,7 @@
>  # kernel was released at the end of 2018.
>  
>  [metadata]
> +nrext64=0
>  bigtime=0
>  crc=1
>  finobt=1
> diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
> index ac00960e..a1c991ce 100644
> --- a/mkfs/lts_5.10.conf
> +++ b/mkfs/lts_5.10.conf
> @@ -2,6 +2,7 @@
>  # kernel was released at the end of 2020.
>  
>  [metadata]
> +nrext64=0
>  bigtime=0
>  crc=1
>  finobt=1
> diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
> index 32082958..d751f4c4 100644
> --- a/mkfs/lts_5.15.conf
> +++ b/mkfs/lts_5.15.conf
> @@ -2,6 +2,7 @@
>  # kernel was released at the end of 2021.
>  
>  [metadata]
> +nrext64=0
>  bigtime=1
>  crc=1
>  finobt=1
> diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
> index dd60b9f1..7e8a0ff0 100644
> --- a/mkfs/lts_5.4.conf
> +++ b/mkfs/lts_5.4.conf
> @@ -2,6 +2,7 @@
>  # kernel was released at the end of 2019.
>  
>  [metadata]
> +nrext64=0
>  bigtime=0
>  crc=1
>  finobt=1
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 96682f9a..28aca7b0 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -79,6 +79,7 @@ enum {
>  	I_ATTR,
>  	I_PROJID32BIT,
>  	I_SPINODES,
> +	I_NREXT64,
>  	I_MAX_OPTS,
>  };
>  
> @@ -433,6 +434,7 @@ static struct opt_params iopts = {
>  		[I_ATTR] = "attr",
>  		[I_PROJID32BIT] = "projid32bit",
>  		[I_SPINODES] = "sparse",
> +		[I_NREXT64] = "nrext64",
>  	},
>  	.subopt_params = {
>  		{ .index = I_ALIGN,
> @@ -481,6 +483,12 @@ static struct opt_params iopts = {
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
> +		{ .index = I_NREXT64,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 1,
> +		}
>  	},
>  };
>  
> @@ -805,6 +813,7 @@ struct sb_feat_args {
>  	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
>  	bool	nodalign;
>  	bool	nortalign;
> +	bool	nrext64;
>  };
>  
>  struct cli_params {
> @@ -1595,6 +1604,9 @@ inode_opts_parser(
>  	case I_SPINODES:
>  		cli->sb_feat.spinodes = getnum(value, opts, subopt);
>  		break;
> +	case I_NREXT64:
> +		cli->sb_feat.nrext64 = getnum(value, opts, subopt);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2172,6 +2184,14 @@ _("timestamps later than 2038 not supported without CRC support\n"));
>  			usage();
>  		}
>  		cli->sb_feat.bigtime = false;
> +
> +		if (cli->sb_feat.nrext64 &&
> +			cli_opt_set(&iopts, I_NREXT64)) {
> +			fprintf(stderr,

Nit: second line of if test has the same indentation level as the first
line of the if body.

With those two things fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +_("64 bit extent count not supported without CRC support\n"));
> +			usage();
> +		}
> +		cli->sb_feat.nrext64 = false;
>  	}
>  
>  	if (!cli->sb_feat.finobt) {
> @@ -3164,6 +3184,8 @@ sb_set_features(
>  		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
>  	}
>  
> +	if (fp->nrext64)
> +		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
>  }
>  
>  /*
> @@ -3875,6 +3897,7 @@ main(
>  			.nodalign = false,
>  			.nortalign = false,
>  			.bigtime = true,
> +			.nrext64 = false,
>  			/*
>  			 * When we decide to enable a new feature by default,
>  			 * please remember to update the mkfs conf files.
> -- 
> 2.30.2
> 
