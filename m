Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C576C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 23:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7571207E8
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 23:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GWJARygm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgKJXsk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 18:48:40 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730254AbgKJXsk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 18:48:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AANMZlL075563
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:48:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tIXRcMN31VA2GJD7dpMgnHn6cGxxRAG7sDBBgbT8kzI=;
 b=GWJARygmA6lgJNnJsGXFewAHAGlJmh33dT8k14L8g/nVxooWdgHzfIWfr7r7xSbRoTL9
 JLi67pCD3AFlRqLgt4ZFj7aERaOWbDs3bq6bNRr+3k0vh6v/ucUAVt4HWRlxsz6eN+kV
 wrXlHrq3wVe+O7saOF/3p3VnwF3lnMMwVG2wNr+GH3a+a9zZU+EYeRQRH5Mf1OecF6ty
 BKmBS6vNg6TVO/Po50jQ3cboa6c87lxQJRd0O4Ko5SQRIopGQpcZBLQibalC07Ftj6To
 5/VgcN5gjHmjq4CAcvf2mQGj9bwNwFJj5inSlLR1LUNzNrRPZnIliZUGOGzNND+trJUk vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72emr0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:48:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AANG8Xf082961
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:48:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34p5gxnq8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:48:38 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AANmcOU005378
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:48:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 15:48:36 -0800
Date:   Tue, 10 Nov 2020 15:48:34 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 14/14] xfsprogs: Add delayed attribute flag to cmd
Message-ID: <20201110234834.GM9695@magnolia>
References: <20201023063306.7441-1-allison.henderson@oracle.com>
 <20201023063306.7441-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023063306.7441-15-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100156
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 11:33:06PM -0700, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
> 
> mkfs: enable feature bit in mkfs via the '-n delattr' parameter.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

I think it's sufficient to have one signoff here.

> ---
>  mkfs/xfs_mkfs.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 8fe149d..e18fb3a 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -94,6 +94,7 @@ enum {
>  	N_SIZE = 0,
>  	N_VERSION,
>  	N_FTYPE,
> +	N_DELATTR,
>  	N_MAX_OPTS,
>  };
>  
> @@ -547,6 +548,7 @@ static struct opt_params nopts = {
>  		[N_SIZE] = "size",
>  		[N_VERSION] = "version",
>  		[N_FTYPE] = "ftype",
> +		[N_DELATTR] = "delattr",
>  	},
>  	.subopt_params = {
>  		{ .index = N_SIZE,
> @@ -569,6 +571,12 @@ static struct opt_params nopts = {
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
> +		{ .index = N_DELATTR,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 1,
> +		},
>  	},
>  };
>  
> @@ -742,6 +750,7 @@ struct sb_feat_args {
>  	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
>  	bool	nodalign;
>  	bool	nortalign;
> +	bool	delattr;		/* XFS_SB_FEAT_INCOMPAT_LOG_DELATTR */
>  };
>  
>  struct cli_params {
> @@ -873,7 +882,7 @@ usage( void )
>  /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
>  			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
>  /* label */		[-L label (maximum 12 characters)]\n\
> -/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
> +/* naming */		[-n size=num,version=2|ci,ftype=0|1,delattr=0|1]\n\
>  /* no-op info only */	[-N]\n\
>  /* prototype file */	[-p fname]\n\
>  /* quiet */		[-q]\n\
> @@ -1592,6 +1601,9 @@ naming_opts_parser(
>  	case N_FTYPE:
>  		cli->sb_feat.dirftype = getnum(value, opts, subopt);
>  		break;
> +	case N_DELATTR:
> +		cli->sb_feat.delattr = getnum(value, &nopts, N_DELATTR);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -1988,6 +2000,14 @@ _("reflink not supported without CRC support\n"));
>  		cli->sb_feat.reflink = false;
>  	}
>  
> +	if ((cli->sb_feat.delattr) &&
> +	    cli->sb_feat.dir_version == 4) {
> +		fprintf(stderr,
> +_("delayed attributes not supported on v4 filesystems\n"));

I think this should move a few lines up to the big batch of code that
turns off all the V5 features if crcs aren't enabled.

TBH this should silently turn off delattrs unless the admin explicitly
enabled them, because one day this will be enabled by default.

--D

> +		usage();
> +		cli->sb_feat.delattr = false;
> +	}
> +
>  	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
>  	    !cli->sb_feat.reflink) {
>  		fprintf(stderr,
> @@ -2953,6 +2973,8 @@ sb_set_features(
>  		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
>  	if (fp->reflink)
>  		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
> +	if (fp->delattr)
> +		sbp->sb_features_log_incompat |= XFS_SB_FEAT_INCOMPAT_LOG_DELATTR;
>  
>  	/*
>  	 * Sparse inode chunk support has two main inode alignment requirements.
> -- 
> 2.7.4
> 
