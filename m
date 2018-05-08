Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755343AbeEHRZZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 13:25:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48HLCOR116644
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:25:24 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2hs4k29p5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 17:25:24 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w48HPNnK006934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:25:23 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w48HPMrW013948
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:25:22 GMT
Date: Tue, 8 May 2018 10:25:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/21] xfsprogs: Add parent pointer flag to cmd
Message-ID: <20180508172521.GR11261@magnolia>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-19-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525754479-12177-19-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 07, 2018 at 09:41:16PM -0700, Allison Henderson wrote:
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Needs commit message:

mkfs: enable formatting with parent pointers

Wire up parent pointer support in mkfs via the '-m parent' parameter.

Signed-off-by: <etc>

> ---
>  mkfs/xfs_mkfs.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 78d0ce5..554e1bf 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -129,6 +129,7 @@ enum {
>  	M_UUID,
>  	M_RMAPBT,
>  	M_REFLINK,
> +	M_PARENT,

Hmm, is this better off in the naming section?

e.g. "mkfs.xfs -n parent=1"

>  	M_MAX_OPTS,
>  };
>  
> @@ -663,6 +664,7 @@ struct opt_params mopts = {
>  		[M_UUID] = "uuid",
>  		[M_RMAPBT] = "rmapbt",
>  		[M_REFLINK] = "reflink",
> +		[M_PARENT] = "parent",
>  	},
>  	.subopt_params = {
>  		{ .index = M_CRC,
> @@ -693,6 +695,13 @@ struct opt_params mopts = {
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
> +		{ .index = M_PARENT,
> +		  .conflicts = { {NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 0,

This (misleadingly named) field is the default value if you pass the
argument without explicitly assigning a value, i.e.

# mkfs.xfs -m parent /dev/sda

sets parent to whatever defaultval is.  In this case you'd get no parent
pointers, which is a little surprising.

And, uh, seeing as people keep getting this wrong maybe we should rename
it?

> +		},
> +
>  	},
>  };
>  
> @@ -865,7 +874,7 @@ usage( void )
>  {
>  	fprintf(stderr, _("Usage: %s\n\
>  /* blocksize */		[-b size=num]\n\
> -/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
> +/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,parent=0|1]\n\
>  /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
>  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
>  			    sectsize=num\n\
> @@ -1586,6 +1595,9 @@ meta_opts_parser(
>  	case M_REFLINK:
>  		cli->sb_feat.reflink = getnum(value, opts, subopt);
>  		break;
> +	case M_PARENT:
> +		cli->sb_feat.parent_pointers = getnum(value, &mopts, M_PARENT);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2887,6 +2899,8 @@ sb_set_features(
>  		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
>  	if (fp->reflink)
>  		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
> +	if (fp->parent_pointers)
> +		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_PARENT;

Otherwise looks ok to me....

--D

>  
>  	/*
>  	 * Sparse inode chunk support has two main inode alignment requirements.
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
