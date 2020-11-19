Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94F6C5519F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 02:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB41246B0
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 02:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nciKbo2j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgKSCgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 21:36:43 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49544 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgKSCgn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Nov 2020 21:36:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ2YP0W100389
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 02:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tgLl6bXT4JKpp5/1JSZP4V9TtsebvXv9GQL36M1Pypk=;
 b=nciKbo2jbNnYUvp/zZlh/a4OjppAB1KkgFDo/fRab2dtGIYCH6iBcIN+reauTXFYzrKK
 xLlx0nxhTSOO3M3Ba4EEIH80NHJ0dPO5zaT4NmeN2tq2MoU/EhEpeEuNuoP8TJZHbgKM
 uUKxOmD3JCwCbuu0k+OpOl0md98BLsaQXIZmoD3yS4A1QBohWuHHwId3kHK5+zjfodN1
 ba5B7A22iK5CEp/mbD57FWiJ8NauZopn0khOw4lhC9zlb5BV23QggjnlD/PnM+1qWywz
 8SsD0kUnuz9Y2yZVCUvGXbZiz/5zKM+H6mh6YxQUaCcJ41U6F7LaAg3CVHp00WaEgOWd cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34t4rb39wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 02:36:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ2ZXPj032942
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 02:36:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ts0t47ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 02:36:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AJ2aeL5007301
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 02:36:40 GMT
Received: from localhost (/10.159.238.222)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Nov 2020 18:36:39 -0800
Date:   Wed, 18 Nov 2020 18:36:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 07/10] xfs: Add feature bit
 XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
Message-ID: <20201119023639.GD9695@magnolia>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023063435.7510-8-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9809 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190017
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

Soooo, something Dave pointed out on IRC this evening --

Log incompat flags exist /only/ to protect the contents of a dirty
journal.  They're supposed to get set when you save something to the log
(like the delayed xattr log items) and cleared when the log is replayed
or unmounted cleanly or goes idle.  If a new feature changes the disk
format then you'll have to protect that with a new rocompat / compat /
incompat flag, but never a log incompat flag.

Therefore, you can't use log incompat flags to gate higher level
functionality.  I don't think delayed attrs themselves have any user
visible effect on the ondisk format outside of the log, right?  So I
guess the good news is that's one less hurdle to getting people to use
this feature.

(Aside: in another part of this patchset review I asked if this means we
could drop the INCOMPLETE flag from attr keys.  I think you could do
that without needing to add a rocompat / compat / incompat flag, since
an old kernel works fine if it never sees an incomplete flag; and
presumably the new kernel will continue to know how to delete those
things.)

The downside is that no code exists to support log incompat flags.  I
guess every time you want to use them you'd potentially have to check
the superblock and log a new superblock to disk with the feature turned
on.  I'll have to think about that more later.

I guess for now we'd want to retain the predicate function so that we
could enable it via a seeecret mount option while we stabilize the
feature.  Later if we add a new ondisk feature flag that uses the log
item we can change the predicate to return true if that feature flag is
set (e.g. xfs_sb_version_hasdelattr always returns true if parent
pointers are enabled).

Atomic file range swapping falls into the same category, so I guess we
both have things to rework.  On the plus side it means that both of our
new features aren't going to require people to upgrade or reformat. :)

--D

>  {
> -	return false;
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_log_incompat &
> +		XFS_SB_FEAT_INCOMPAT_LOG_DELATTR));
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
