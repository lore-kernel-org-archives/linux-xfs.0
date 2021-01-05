Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28127C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 17:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE2D122D01
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 17:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbhAERiP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 12:38:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37512 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbhAERiP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 12:38:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105HTM7n048306;
        Tue, 5 Jan 2021 17:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=24us2t1JcqleclRlFUGnodGdDts/LRsqAjzij+iTvd4=;
 b=Z1bJevljOkwbq414Iu1VQr+4b+/j9zaQM//cegbpNt3alHNA9ij2L3JA8JrlO8P/iLrS
 0Hh1Hnd4R6+WDI74AnGLgTh4vdoH2J+T8TPGoN0h7QIMKM5UD7wDNGO2a3zVLpt2Ngcr
 pb99hwGfuLp38LXHDrJy3O8h7V8YXdGM2PLHHeCF2de/20aq8+57XyvB69OurMRfDtTb
 NthjT8vz5soLuzf6Eu0Gb/MdFPBieoNixMNE7oIcTWWjm48BYHLB9F9dz7WSEZji+h14
 JigTqQaDN7wU5+vbdA55Gp46QMuzWBwnrc/je1feUzojyjEYhl6Afnbz5nhi6xb9T7QH VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35tg8r1xct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 17:37:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105HZMlP154397;
        Tue, 5 Jan 2021 17:35:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35vct65e9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 17:35:30 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 105HZSuw009105;
        Tue, 5 Jan 2021 17:35:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 17:35:28 +0000
Date:   Tue, 5 Jan 2021 09:35:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: expose inobtcount in xfs geometry
Message-ID: <20210105173528.GZ6918@magnolia>
References: <20210105162254.706534-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105162254.706534-1-zlang@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050103
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:22:54AM +0800, Zorro Lang wrote:
> As xfs supports the feature of inode btree block counters now, expose
> this feature flag in xfs geometry, for userspace can check if the
> inobtcnt is enabled or not.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> The related userspace xfsprogs patch as this link:
> https://www.spinics.net/lists/linux-xfs/msg47853.html
> 
> Thanks,
> Zorro
> 
>  fs/xfs/libxfs/xfs_fs.h | 1 +
>  fs/xfs/libxfs/xfs_sb.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2a2e3cfd94f0..6fad140d4c8e 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
>  #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
>  #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
> +#define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index bbda117e5d85..60e6d255e5e2 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1138,6 +1138,8 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
>  	if (xfs_sb_version_hasbigtime(sbp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
> +	if (xfs_sb_version_hasinobtcounts(sbp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
>  	if (xfs_sb_version_hassector(sbp))
>  		geo->logsectsize = sbp->sb_logsectsize;
>  	else
> -- 
> 2.25.4
> 
