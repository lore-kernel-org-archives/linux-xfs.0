Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6D5C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 05:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AFC522838
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 05:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725290AbhAEFrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 00:47:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36734 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbhAEFrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 00:47:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1055cvma122771
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 05:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QGGziuk8tbgpc8n8H3kgdWP/Mnv+5BQcwrFPhG37LLY=;
 b=X2bexYYdfUJtxaqiBUwlYJzu2Rl2Z0Pebi3IVRTQ1NmYt7vISP0f+1soJPIwzmwrtGZg
 dkgHGK+iXd3yNfXgABApRgb3j4XRGY28O9Wxe6CMt6+MKWjOjAEnrvu+wQeWiotu8AlQ
 uZNK2NIM1vEf95PgvA6Pjy0S1K9IH1faZfnKBpCfLLWk/Z5MKKf17g4GTkskAAWNzl+h
 7+AsgNA9XAm79o/nIgcNqk/LvsQ5v8XMjdknSGENrxXtpye63j0S9VTHPBZnexLi9CbB
 AFnViNaVhUtKxwFkYKXN+WSlcTM05AYit1yuJzurJ5Bu51iHPVV26GbP2tq5lVBEDsQx Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35tgskq9hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 05:46:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1055iLLf055179
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 05:46:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1f86mms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 05:46:29 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1055kSat006181
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 05:46:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 05:46:28 +0000
Date:   Mon, 4 Jan 2021 21:46:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 14/15] xfs: Add delattr mount option
Message-ID: <20210105054626.GV6918@magnolia>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218072917.16805-15-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050035
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 18, 2020 at 12:29:16AM -0700, Allison Henderson wrote:
> This patch adds a mount option to enable delayed attributes. Eventually
> this can be removed when delayed attrs becomes permanent.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.h | 2 +-
>  fs/xfs/xfs_mount.h       | 1 +
>  fs/xfs/xfs_super.c       | 6 +++++-
>  fs/xfs/xfs_xattr.c       | 2 ++
>  4 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 4838094..edd008d 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -30,7 +30,7 @@ struct xfs_attr_list_context;
>  
>  static inline bool xfs_hasdelattr(struct xfs_mount *mp)

/me had a brain fart just now that ... since struct xfs_delattr_context
is ultimately going to be absorbed into struct xfs_attr_item, we really
should have called the control knob part of this 'logattr' instead of
'delattr', because that's (IMIO) a better explanation of what the mount
option actually does for users.

An even better name would have been "logged attributes replayable"
because then you could use the prefix XFS_LARP for things. :P

Comments? :)

--D


>  {
> -	return false;
> +	return mp->m_flags & XFS_MOUNT_DELATTR;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index dfa429b..4794f27 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -254,6 +254,7 @@ typedef struct xfs_mount {
>  #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
>  #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
>  #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
> +#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
>  
>  /*
>   * Max and min values for mount-option defined I/O
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 813be87..72169ee 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -92,7 +92,7 @@ enum {
>  	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>  	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
>  };
>  
>  static const struct fs_parameter_spec xfs_fs_parameters[] = {
> @@ -137,6 +137,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>  	fsparam_flag("nodiscard",	Opt_nodiscard),
>  	fsparam_flag("dax",		Opt_dax),
>  	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
> +	fsparam_flag("delattr",		Opt_delattr),
>  	{}
>  };
>  
> @@ -1292,6 +1293,9 @@ xfs_fs_parse_param(
>  		xfs_mount_set_dax_mode(mp, result.uint_32);
>  		return 0;
>  #endif
> +	case Opt_delattr:
> +		mp->m_flags |= XFS_MOUNT_DELATTR;
> +		return 0;
>  	/* Following mount options will be removed in September 2025 */
>  	case Opt_ikeep:
>  		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 9b0c790..8ec61df 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -8,6 +8,8 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
>  #include "xfs_da_format.h"
>  #include "xfs_inode.h"
>  #include "xfs_da_btree.h"
> -- 
> 2.7.4
> 
