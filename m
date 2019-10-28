Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D744DCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9B3F208C0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="POCAV+Pf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfJ1QuZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:50:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58130 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfJ1QuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:50:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGnAT3061576;
        Mon, 28 Oct 2019 16:50:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WpTDUesl4bWS36mjQriY78Jxv2yo6AUIHJKlLsugrlQ=;
 b=POCAV+PfKYz1JbxEO0n3VBUm3Q/WRlKwsLewQY9Z9MsvvTY/CGS1ivfq3NL2rSY5ClUo
 px+urlB0p8PvyXszcx+cGqaBtUOwJAViCS91qSRSRuwHy4+WGxAqrR5fcJTr6nvQ0wce
 16SUAxdxsIWS6KnsgmXuFYAgfp8X6aBlgCwTNXIUodUl0NO2wr2smU00+YtDOFwVhqBt
 ooeVkh4IYPoKwCxxFta0tVXfctgvbXYzhBfqsSufTbq3LvroXKLNGfLDqWPUsUyjQz+W
 JyNkPqK+IGPCgyeJSOlFFzhde94o9KkE4WX2G7jUM/Ua1tg6E5NHgPnk8H+SHQ4Ulw71 WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vve3q396u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:50:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGnB4r190712;
        Mon, 28 Oct 2019 16:50:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vw09g2hnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:50:17 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SGoGjt000870;
        Mon, 28 Oct 2019 16:50:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:50:15 -0700
Date:   Mon, 28 Oct 2019 09:50:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 02/12] xfs: remove the dsunit and dswidth variables in
 xfs_parseargs
Message-ID: <20191028165015.GL15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 27, 2019 at 03:55:37PM +0100, Christoph Hellwig wrote:
> There is no real need for the local variables here - either they
> are applied to the mount structure, or if the noalign mount option
> is set the mount will fail entirely if either is set.  Removing
> them helps cleaning up the mount API conversion.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c | 27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 589c080cabfe..4089de3daded 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -159,8 +159,6 @@ xfs_parseargs(
>  	const struct super_block *sb = mp->m_super;
>  	char			*p;
>  	substring_t		args[MAX_OPT_ARGS];
> -	int			dsunit = 0;
> -	int			dswidth = 0;
>  	int			iosize = 0;
>  	uint8_t			iosizelog = 0;
>  
> @@ -252,11 +250,11 @@ xfs_parseargs(
>  			mp->m_flags |= XFS_MOUNT_SWALLOC;
>  			break;
>  		case Opt_sunit:
> -			if (match_int(args, &dsunit))
> +			if (match_int(args, &mp->m_dalign))
>  				return -EINVAL;
>  			break;
>  		case Opt_swidth:
> -			if (match_int(args, &dswidth))
> +			if (match_int(args, &mp->m_swidth))
>  				return -EINVAL;
>  			break;
>  		case Opt_inode32:
> @@ -350,7 +348,8 @@ xfs_parseargs(
>  		return -EINVAL;
>  	}
>  
> -	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
> +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> +	    (mp->m_dalign || mp->m_swidth)) {
>  		xfs_warn(mp,
>  	"sunit and swidth options incompatible with the noalign option");
>  		return -EINVAL;
> @@ -363,30 +362,20 @@ xfs_parseargs(
>  	}
>  #endif
>  
> -	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
> +	if ((mp->m_dalign && !mp->m_swidth) ||
> +	    (!mp->m_dalign && mp->m_swidth)) {
>  		xfs_warn(mp, "sunit and swidth must be specified together");
>  		return -EINVAL;
>  	}
>  
> -	if (dsunit && (dswidth % dsunit != 0)) {
> +	if (mp->m_dalign && (mp->m_swidth % mp->m_dalign != 0)) {
>  		xfs_warn(mp,
>  	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> -			dswidth, dsunit);
> +			mp->m_swidth, mp->m_dalign);
>  		return -EINVAL;
>  	}
>  
>  done:
> -	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> -		/*
> -		 * At this point the superblock has not been read
> -		 * in, therefore we do not know the block size.
> -		 * Before the mount call ends we will convert
> -		 * these to FSBs.
> -		 */
> -		mp->m_dalign = dsunit;
> -		mp->m_swidth = dswidth;
> -	}
> -
>  	if (mp->m_logbufs != -1 &&
>  	    mp->m_logbufs != 0 &&
>  	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> -- 
> 2.20.1
> 
