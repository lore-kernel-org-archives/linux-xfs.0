Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E644C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 01:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiAEBPp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 20:15:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbiAEBPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 20:15:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2873E615EF
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 01:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F33BC36AE0;
        Wed,  5 Jan 2022 01:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641345344;
        bh=A54LY1rNTLmn8cWzaSDfRqSJu/mdSh8ndGqSP3qBOdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eupl3b+q15H89wAI584RVyX0HnsGVtpw8i1EL8vdh5xuOgb87xtWyneyn8lFI2KCq
         VPFxX6mDPiuUXpxaUeWEgyCP883DIHb4z0vmGLbW8AZN3Jp+GRDCsMf3zf01NUBD0B
         2xo4tWpTbwegW2XYgF/robnAl0viu1VMwTz3Wwb6P38ogiioRoPw/2Ggo3bE3lvANH
         4zXVuLosCiO3gRuF7rg9eRrl1avnC8tBuZ/xgFofaDElURlwzyQb52m1e966kpu2Mh
         3gzuhqWaLNCcUmHH9LdrO2SdfKb73roW0WD1fHrLao2TL70Aq5KDXt/eDuoYX8oCb2
         8Ig0wKsmCOqcQ==
Date:   Tue, 4 Jan 2022 17:15:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 18/20] xfsprogs: Add mkfs option to create filesystem
 with large extent counters
Message-ID: <20220105011544.GE656707@magnolia>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-19-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084811.764481-19-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:18:09PM +0530, Chandan Babu R wrote:
> Enabling nrext64 option on mkfs.xfs command line extends the maximum values of
> inode data and attr fork extent counters to 2^48 - 1 and 2^32 - 1
> respectively.  This also sets the XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag
> on the superblock preventing older kernels from mounting such a filesystem.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks reasonable.  There's a silly nit that mtk prefers that each
sentence in a Linux man page start on a separate line, but I'll let Eric
decide if he cares about that for xfsprogs manpages.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  man/man8/mkfs.xfs.8 |  7 +++++++
>  mkfs/xfs_mkfs.c     | 23 +++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index a7f70285..923940e3 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -639,6 +639,13 @@ space over time such that no free extents are large enough to
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
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 53904677..6609776f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -78,6 +78,7 @@ enum {
>  	I_ATTR,
>  	I_PROJID32BIT,
>  	I_SPINODES,
> +	I_NREXT64,
>  	I_MAX_OPTS,
>  };
>  
> @@ -432,6 +433,7 @@ static struct opt_params iopts = {
>  		[I_ATTR] = "attr",
>  		[I_PROJID32BIT] = "projid32bit",
>  		[I_SPINODES] = "sparse",
> +		[I_NREXT64] = "nrext64",
>  	},
>  	.subopt_params = {
>  		{ .index = I_ALIGN,
> @@ -480,6 +482,12 @@ static struct opt_params iopts = {
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
> @@ -804,6 +812,7 @@ struct sb_feat_args {
>  	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
>  	bool	nodalign;
>  	bool	nortalign;
> +	bool	nrext64;
>  };
>  
>  struct cli_params {
> @@ -1585,6 +1594,9 @@ inode_opts_parser(
>  	case I_SPINODES:
>  		cli->sb_feat.spinodes = getnum(value, opts, subopt);
>  		break;
> +	case I_NREXT64:
> +		cli->sb_feat.nrext64 = getnum(value, opts, subopt);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2153,6 +2165,14 @@ _("timestamps later than 2038 not supported without CRC support\n"));
>  			usage();
>  		}
>  		cli->sb_feat.bigtime = false;
> +
> +		if (cli->sb_feat.nrext64 &&
> +			cli_opt_set(&iopts, I_NREXT64)) {
> +			fprintf(stderr,
> +_("64 bit extent count not supported without CRC support\n"));
> +			usage();
> +		}
> +		cli->sb_feat.nrext64 = false;
>  	}
>  
>  	if (!cli->sb_feat.finobt) {
> @@ -3145,6 +3165,8 @@ sb_set_features(
>  		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
>  	}
>  
> +	if (fp->nrext64)
> +		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
>  }
>  
>  /*
> @@ -3854,6 +3876,7 @@ main(
>  			.nodalign = false,
>  			.nortalign = false,
>  			.bigtime = false,
> +			.nrext64 = false,
>  		},
>  	};
>  
> -- 
> 2.30.2
> 
