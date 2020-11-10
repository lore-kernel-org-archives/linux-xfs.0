Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE838C55ABD
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 20:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73D0520809
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 20:12:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0If+5/o/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgKJUMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 15:12:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45822 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731644AbgKJUMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 15:12:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAK9r5G104497
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=27Ab1QZbo+1l18kEn75E/sSojYC1c7rg99nWN26VLFo=;
 b=0If+5/o/Bj/NqIfuaULB+/vepgT+5CHDK7X0D+VXomuw3hc5k8T+MAv6FjC7fK18Qw5Q
 PHNBPEH9x+xsC54u96lL+z4xBgtXSnL1B2WymUNlZmw/xwQCUq08ZeIUwJQtgSHAJeDc
 5NJoMqDTPE5Es8JXIKMLbXzGx1jsDpNq8qeHOTo6shOtaiUq4Ym7RE2xahe2ZevW6ZpN
 WjdR9OYZ/b5TyBirw1O7BCxtfA3CtFPtjFiW0n/FbmeHdMvfXrqbjLxrTQlcsvQcAGBK
 r4me3ppSX0emfLy7lpo+HvzXUjVhVmukZJfY1PIJ9heaJWGA3tJYK9Brjtd0jznkqZdU kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34nh3awv7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:12:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAKA9sK073263
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:10:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34p5gxf15c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:10:12 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AAKA3uG012816
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:10:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 12:10:03 -0800
Date:   Tue, 10 Nov 2020 12:10:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 07/10] xfs: Add feature bit
 XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
Message-ID: <20201110201002.GE9695@magnolia>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023063435.7510-8-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100137
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 11:34:32PM -0700, Allison Henderson wrote:
> This patch adds a new feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR which
> can be used to control turning on/off delayed attributes
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 8 ++++++--
>  fs/xfs/libxfs/xfs_fs.h     | 1 +
>  fs/xfs/libxfs/xfs_sb.c     | 2 ++
>  fs/xfs/xfs_super.c         | 3 +++
>  4 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d419c34..18b41a7 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -483,7 +483,9 @@ xfs_sb_has_incompat_feature(
>  	return (sbp->sb_features_incompat & feature) != 0;
>  }
>  
> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> +#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> +	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
>  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>  static inline bool
>  xfs_sb_has_incompat_log_feature(
> @@ -586,7 +588,9 @@ static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
>  
>  static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
>  {
> -	return false;
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_log_incompat &
> +		XFS_SB_FEAT_INCOMPAT_LOG_DELATTR));

This change and the EXPERIMENTAL warning should go in whichever patch
defines xfs_sb_version_hasdelattr.

>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2a2e3cf..f703d95 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
>  #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
>  #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
> +#define XFS_FSOP_GEOM_FLAGS_DELATTR	(1 << 22) /* delayed attributes	    */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 5aeafa5..a0ec327 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1168,6 +1168,8 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
>  	if (xfs_sb_version_hasbigtime(sbp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
> +	if (xfs_sb_version_hasdelattr(sbp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_DELATTR;

These changes to the geometry ioctl should be a separate patch.

IOWs, the only change in this patch should be adding
XFS_SB_FEAT_INCOMPAT_LOG_DELATTR to the _ALL #define.

--D

>  	if (xfs_sb_version_hassector(sbp))
>  		geo->logsectsize = sbp->sb_logsectsize;
>  	else
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d1b5f2d..bb85884 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1580,6 +1580,9 @@ xfs_fc_fill_super(
>  	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
>  		xfs_warn(mp,
>   "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
> +	if (xfs_sb_version_hasdelattr(&mp->m_sb))
> +		xfs_alert(mp,
> +	"EXPERIMENTAL delayed attrs feature enabled. Use at your own risk!");
>  
>  	error = xfs_mountfs(mp);
>  	if (error)
> -- 
> 2.7.4
> 
