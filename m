Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C0DC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6BEA2054F
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0OvusWPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgHaUnq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 16:43:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55324 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgHaUnp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 16:43:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKhe60119393;
        Mon, 31 Aug 2020 20:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=B0v+OtjCsynzXKIE9JRbXedNX06HQTxOyQOlPPSGkqg=;
 b=0OvusWPa5AW1WktRdbW0K4JXmqQaBbdjQ/yj4pXJrjVjxYjqpCLKJEC1CGr8DFNgYSJt
 Idf46nVCFW/CTck+CjIWy1MSGLOpSfSnuPr8b8hc8U/CitPdK/xPHWVcTiBbdEo+DAeE
 W6BTO6i1kTGgBajSS6xgE/dA+7uVfBWCOX/BFmb4q3Hq6OScNh5j8llh07ePeBLuOqlF
 E6zUhH8XQQoS+tsWmWxgi/mCXpG5tbtDMr4qsUloKVVO7dZsKL3SwD7SvpU1e6B8zmih
 HA/maZz/GWhaRJi0Wjawd7ijGFBawZYT+YzJ55VZT29IKAg0LrMveDLF6ghGQPGWDBiX Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 337qrhfhts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 20:43:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKL8DN032497;
        Mon, 31 Aug 2020 20:43:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380km704w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 20:43:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VKhbWr007334;
        Mon, 31 Aug 2020 20:43:38 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 13:43:37 -0700
Date:   Mon, 31 Aug 2020 13:43:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 1/3] xfs: Introduce xfs_iext_max() helper
Message-ID: <20200831204340.GV6096@magnolia>
References: <20200831130010.454-1-chandanrlinux@gmail.com>
 <20200831130010.454-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831130010.454-2-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 06:30:08PM +0530, Chandan Babu R wrote:
> xfs_iext_max() returns the maximum number of extents possible for either
> data fork or attribute fork. This helper will be extended further in a
> future commit when maximum extent counts associated with data/attribute
> forks are increased.
> 
> No functional changes have been made.

Hmm....

> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
>  fs/xfs/libxfs/xfs_inode_buf.c  |  8 +++-----
>  fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
>  3 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index dcc8eeecd571..16b983b8977d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -74,13 +74,12 @@ xfs_bmap_compute_maxlevels(
>  	 * for both ATTR1 and ATTR2 we have to assume the worst case scenario
>  	 * of a minimum size available.
>  	 */
> -	if (whichfork == XFS_DATA_FORK) {
> -		maxleafents = MAXEXTNUM;
> +	maxleafents = xfs_iext_max(&mp->m_sb, whichfork);
> +	if (whichfork == XFS_DATA_FORK)
>  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
> -	} else {
> -		maxleafents = MAXAEXTNUM;
> +	else
>  		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
> -	}
> +
>  	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
>  	minleafrecs = mp->m_bmap_dmnr[0];
>  	minnoderecs = mp->m_bmap_dmnr[1];
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 8d5dd08eab75..5dcd71bfab2e 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -369,6 +369,7 @@ xfs_dinode_verify_fork(
>  	int			whichfork)
>  {
>  	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		max_extents;
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
> @@ -390,12 +391,9 @@ xfs_dinode_verify_fork(
>  			return __this_address;
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		if (whichfork == XFS_ATTR_FORK) {
> -			if (di_nextents > MAXAEXTNUM)
> -				return __this_address;
> -		} else if (di_nextents > MAXEXTNUM) {
> +		max_extents = xfs_iext_max(&mp->m_sb, whichfork);
> +		if (di_nextents > max_extents)
>  			return __this_address;
> -		}
>  		break;
>  	default:
>  		return __this_address;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 4219b01f1034..75e07078967e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -153,6 +153,16 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>  	return ifp->if_format;
>  }
>  
> +static inline xfs_extnum_t xfs_iext_max(struct xfs_sb *sbp, int whichfork)
> +{
> +	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
> +
> +	if (whichfork == XFS_DATA_FORK)
> +		return MAXEXTNUM;
> +	else
> +		return MAXAEXTNUM;

...I kinda wish you /had/ made the functional change to make this return
MAXEXTNUM for cow forks, even if none of the callers actually care. :)

--D

> +}
> +
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>  
>  int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> -- 
> 2.28.0
> 
