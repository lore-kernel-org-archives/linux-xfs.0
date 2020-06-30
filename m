Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B598EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9215120724
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:52:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hx9SFQmk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390503AbgF3RwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:52:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34462 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388339AbgF3RwS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:52:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqC5D045800;
        Tue, 30 Jun 2020 17:52:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=r61wpe8aCPuz8NP1zeyOubWAOBhG/+i/DUrFQQ39EpQ=;
 b=Hx9SFQmkpXH0gHuMVW4y8T8s4fXC2KrkR00PkYQDnHtf759pbkp8NKcPktenC7Rh00Y2
 Iizota/xdzbwJ9QI9Bsyv/7craf0AEppYxchRrnh+Jbl3SvLcjz2JTJrJDBYYo+NQ8QD
 LsBVbF2EVCdLXEy4Qv6KxiMt613uj/YaSS1oL1UcwCU+tHgMtWBq3CXv4qEAekXBvoHs
 qPfm1lv5eCPhwYHywYJgCTNPKR7xCNUEgb7vUcrvAEPV7RPkyhLDvd9ofR9gbizOeovq
 4TkKGmlopsNJR7qTQcwmJymaZ1DIpLmUVFcEwwuiQipOXx4UNhtgBqSr+3d593yK65wE hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrn613t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:52:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHmYcO087537;
        Tue, 30 Jun 2020 17:52:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31xfvst5us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:52:14 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UHqDou014721;
        Tue, 30 Jun 2020 17:52:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:52:13 +0000
Date:   Tue, 30 Jun 2020 10:52:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/15] xfs: cleanup xfs_fill_fsxattr
Message-ID: <20200630175212.GF7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-10-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:10:56AM +0200, Christoph Hellwig wrote:
> Add a local xfs_mount variable, and use the XFS_FSB_TO_B helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes thank you!

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 60544dd0f875b8..cabc86ed6756bc 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1104,15 +1104,14 @@ xfs_fill_fsxattr(
>  	bool			attr,
>  	struct fsxattr		*fa)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = attr ? ip->i_afp : &ip->i_df;
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
> -	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
> -	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) &&
> -	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)) {
> -		fa->fsx_cowextsize =
> -			ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
> -	}
> +	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> +	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> +		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> -- 
> 2.26.2
> 
