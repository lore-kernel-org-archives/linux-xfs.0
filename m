Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870DDC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 14:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5826220782
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 14:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DUE2vFD0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHYO4Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 10:56:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbgHYOzT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 10:55:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PEsVUN134209;
        Tue, 25 Aug 2020 14:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7YTQHdpfc+Vm+aJzshUCpefcRSb/gr8ORFfpNRqTimI=;
 b=DUE2vFD0hZX6HP6ubYbbfrsRvzA0QQjnfTII7S/ys3eROPDGV3aXweOqqiOnlj4IkxTS
 WDAmu4RX8H6DL3iQGtSOkgPjzzZZp3NpHxoA85gbzF5PAB0Z9TMNVlDzcDHv0RjsFZ5x
 RluaIFoz5rmNHevsCXcoRWkF9RLd4969miMToalQ6ZdHhAe0igiweAq6kOgnUHceImR7
 EtS2Q2neGwhy6AnD77qiZr9pPkC1a5bUkHB8yX2C62CAdoXN79BpxWvuyl8SyeWkr90o
 gHuL4d5EkYI/EJux/EBXIcst1lvroYtbElY5PFrYs8pVRQtaGEgvZXWbYtl5pn7gBS8d CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 333csj317g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 14:55:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PEepdk015128;
        Tue, 25 Aug 2020 14:55:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 333r9jys8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 14:55:01 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07PEt0HL012023;
        Tue, 25 Aug 2020 14:55:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Aug 2020 07:55:00 -0700
Date:   Tue, 25 Aug 2020 07:54:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: use log_incompat feature instead of speculate
 matching
Message-ID: <20200825145458.GC6096@magnolia>
References: <20200824154120.GA23868@xiangao.remote.csb>
 <20200825100601.2529-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825100601.2529-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008250112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 06:06:01PM +0800, Gao Xiang wrote:
> Add a log_incompat (v5) or sb_features2 (v4) feature
> of a single long iunlinked list just to be safe. Hence,
> older kernels will refuse to replay log for v5 images
> or mount entirely for v4 images.
> 
> If the current mount is in RO state, it will defer
> to the next RW (re)mount to add such flag instead.

This commit log needs to state /why/ we need a new feature flag in
addition to summarizing what is being added here.  For example,

"Introduce a new feature flag to collapse the unlinked hash to a single
bucket.  Doing so removes the need to lock the AGI in addition to the
previous and next items in the unlinked list.  Older kernels will think
that inodes are in the wrong unlinked hash bucket and declare the fs
corrupt, so the new feature is needed to prevent them from touching the
filesystem."

(or whatever the real reason is, I'm attending DebConf and LPC and
wasn't following 100%...)

Note that the above was a guess, because I actually can't tell if this
feature is needed to prevent old kernels from tripping over our new
strategy, or to prevent new kernels from running off the road if an old
kernel wrote all the hash buckets.  I would've thought both cases would
be fine...?

> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> Different combinations have been tested (v4/v5 and before/after patch).
> 
> Based on the top of
> `[PATCH 13/13] xfs: reorder iunlink remove operation in xfs_ifree`
> https://lore.kernel.org/r/20200812092556.2567285-14-david@fromorbit.com
> 
> Either folding or rearranging this patch would be okay.
> 
> Maybe xfsprogs could be also patched as well to change the default
> feature setting, but let me send out this first...
> 
> (It's possible that I'm still missing something...
>  Kindly point out any time.)
> 
>  fs/xfs/libxfs/xfs_format.h | 29 +++++++++++++++++++++++++++--
>  fs/xfs/xfs_inode.c         |  2 +-
>  fs/xfs/xfs_mount.c         |  6 ++++++
>  3 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 31b7ece985bb..a859fe601f6e 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -79,12 +79,14 @@ struct xfs_ifork;
>  #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
>  #define XFS_SB_VERSION2_CRCBIT		0x00000100	/* metadata CRCs */
>  #define XFS_SB_VERSION2_FTYPE		0x00000200	/* inode type in dir */
> +#define XFS_SB_VERSION2_NEW_IUNLINK	0x00000400	/* (v4) new iunlink */
>  
>  #define	XFS_SB_VERSION2_OKBITS		\
>  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
>  	 XFS_SB_VERSION2_ATTR2BIT	| \
>  	 XFS_SB_VERSION2_PROJID32BIT	| \
> -	 XFS_SB_VERSION2_FTYPE)
> +	 XFS_SB_VERSION2_FTYPE		| \
> +	 XFS_SB_VERSION2_NEW_IUNLINK)

NAK on this part; as I said earlier, don't add things to V4 filesystems.

If the rest of you have compelling reasons to want V4 support, now is
the time to speak up.

>  /* Maximum size of the xfs filesystem label, no terminating NULL */
>  #define XFSLABEL_MAX			12
> @@ -479,7 +481,9 @@ xfs_sb_has_incompat_feature(
>  	return (sbp->sb_features_incompat & feature) != 0;
>  }
>  
> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> +#define XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK	(1 << 0)
> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL	\
> +		(XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK)

There's a trick here: Define the feature flag at the very start of your
patchset, then make the last patch in the set add it to the _ALL macro
so that people bisecting their way through the git tree (with this
feature turned on) won't unwittingly build a kernel with the feature
half built and blow their filesystem to pieces.

>  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>  static inline bool
>  xfs_sb_has_incompat_log_feature(
> @@ -563,6 +567,27 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
>  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
>  }
>  
> +static inline bool xfs_sb_has_new_iunlink(struct xfs_sb *sbp)
> +{
> +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
> +		return sbp->sb_features_log_incompat &
> +			XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK;
> +
> +	return xfs_sb_version_hasmorebits(sbp) &&
> +		(sbp->sb_features2 & XFS_SB_VERSION2_NEW_IUNLINK);
> +}
> +
> +static inline void xfs_sb_add_new_iunlink(struct xfs_sb *sbp)
> +{
> +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
> +		sbp->sb_features_log_incompat |=
> +			XFS_SB_FEAT_INCOMPAT_LOG_NEW_IUNLINK;
> +		return;
> +	}
> +	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
> +	sbp->sb_features2 |= XFS_SB_VERSION2_NEW_IUNLINK;

All metadata updates need to be logged.  Dave just spent a bunch of time
heckling me for that in the y2038 patchset. ;)

Also, I don't think it's a good idea to enable new incompat features
automatically, since this makes the fs unmountable on old kernels.

> +}
> +
>  /*
>   * end of superblock version macros
>   */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7ee778bcde06..1656ed7dcadf 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1952,7 +1952,7 @@ xfs_iunlink_update_bucket(
>  	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
>  		ASSERT(cur_agino != NULLAGINO);
>  
> -		if (be32_to_cpu(agi->agi_unlinked[0]) != cur_agino)
> +		if (!xfs_sb_has_new_iunlink(&mp->m_sb))
>  			bucket_index = cur_agino % XFS_AGI_UNLINKED_BUCKETS;

Oh, is this the one change added by the feature? :)

>  	}
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index f28c969af272..a3b2e3c3d32f 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -836,6 +836,12 @@ xfs_mountfs(
>  		goto out_fail_wait;
>  	}
>  
> +	if (!xfs_sb_has_new_iunlink(sbp)) {
> +		xfs_warn(mp, "will switch to long iunlinked list on r/w");
> +		xfs_sb_add_new_iunlink(sbp);
> +		mp->m_update_sb = true;
> +	}
> +
>  	/* Make sure the summary counts are ok. */
>  	error = xfs_check_summary_counts(mp);
>  	if (error)
> -- 
> 2.18.1
> 
