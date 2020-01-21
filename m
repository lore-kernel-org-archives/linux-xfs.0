Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BE4C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CC0524655
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JyUCpokd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAUS1t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:27:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUS1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:27:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI8Fxw153865;
        Tue, 21 Jan 2020 18:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=BPmsP+IDqWFWXZQMlhakvGWJ23v+H2ne1Z5/RKb4/l8=;
 b=JyUCpokdEPJy+y+8OWiCDjz/cgGYDpn0sdmHw6eu0lrAUf7TGIqenvFPXVZ0YjMVVdjK
 Cg+WmQvjpFZtKYmYMQFNgdh7KovftBDjqo2xq+yjv9fwUcPSAlG8twIfZkW222+IFGD0
 Z+vBPiwQRW0D5s3wE85Kt70g6IZ8aWCcPVzJYA1Lqfcvqdn44iuJPJnrZDVo2C2RQ6l0
 tx3zU4qNvvkTBpSIlZL2hRf7lJOmKm8KYWkDUqttk3J8OVPfB2CRLdsXr2kyEsTCztFe
 RR6AYDMdhcYTzq3iT2lnTvjA/GRJjdmGHmgPt84IV1DUDBy1uhhjjprr/3Bx1jmgn63J WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksyq6w7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:27:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI7wg1113173;
        Tue, 21 Jan 2020 18:27:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xnpfph0y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:27:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LIRiTg006869;
        Tue, 21 Jan 2020 18:27:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:27:44 -0800
Date:   Tue, 21 Jan 2020 10:27:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 16/29] xfs: factor out a xfs_attr_match helper
Message-ID: <20200121182743.GP8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-17-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-17-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:38AM +0100, Christoph Hellwig wrote:
> Factor out a helper that compares an on-disk attr vs the name, length and
> flags specified in struct xfs_da_args.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 80 +++++++++++++----------------------
>  1 file changed, 30 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b0658eb8fbcc..8852754153ba 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -445,14 +445,21 @@ xfs_attr3_leaf_read(
>   * Namespace helper routines
>   *========================================================================*/
>  
> -/*
> - * If namespace bits don't match return 0.
> - * If all match then return 1.
> - */
> -STATIC int
> -xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
> +static bool

/me wonders if this ought to be static inline but otherwise,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +xfs_attr_match(
> +	struct xfs_da_args	*args,
> +	uint8_t			namelen,
> +	unsigned char		*name,
> +	int			flags)
>  {
> -	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
> +	if (args->namelen != namelen)
> +		return false;
> +	if (memcmp(args->name, name, namelen) != 0)
> +		return false;
> +	if (XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags) !=
> +	    XFS_ATTR_NSP_ONDISK(flags))
> +		return false;
> +	return true;
>  }
>  
>  static int
> @@ -678,15 +685,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -#ifdef DEBUG
> -		if (sfe->namelen != args->namelen)
> -			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> -			continue;
> -		ASSERT(0);
> -#endif
> +		ASSERT(!xfs_attr_match(args, sfe->namelen, sfe->nameval,
> +			sfe->flags));
>  	}
>  
>  	offset = (char *)sfe - (char *)sf;
> @@ -749,13 +749,9 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
>  	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
>  					base += size, i++) {
>  		size = XFS_ATTR_SF_ENTSIZE(sfe);
> -		if (sfe->namelen != args->namelen)
> -			continue;
> -		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> -			continue;
> -		break;
> +		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> +				sfe->flags))
> +			break;
>  	}
>  	if (i == end)
>  		return -ENOATTR;
> @@ -816,13 +812,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
>  				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -		if (sfe->namelen != args->namelen)
> -			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> -			continue;
> -		return -EEXIST;
> +		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> +				sfe->flags))
> +			return -EEXIST;
>  	}
>  	return -ENOATTR;
>  }
> @@ -847,14 +839,10 @@ xfs_attr_shortform_getvalue(
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count;
>  				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -		if (sfe->namelen != args->namelen)
> -			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> -			continue;
> -		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
> -						sfe->valuelen);
> +		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> +				sfe->flags))
> +			return xfs_attr_copy_value(args,
> +				&sfe->nameval[args->namelen], sfe->valuelen);
>  	}
>  	return -ENOATTR;
>  }
> @@ -2409,23 +2397,15 @@ xfs_attr3_leaf_lookup_int(
>  		}
>  		if (entry->flags & XFS_ATTR_LOCAL) {
>  			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
> -			if (name_loc->namelen != args->namelen)
> -				continue;
> -			if (memcmp(args->name, name_loc->nameval,
> -							args->namelen) != 0)
> -				continue;
> -			if (!xfs_attr_namesp_match(args->flags, entry->flags))
> +			if (!xfs_attr_match(args, name_loc->namelen,
> +					name_loc->nameval, entry->flags))
>  				continue;
>  			args->index = probe;
>  			return -EEXIST;
>  		} else {
>  			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
> -			if (name_rmt->namelen != args->namelen)
> -				continue;
> -			if (memcmp(args->name, name_rmt->name,
> -							args->namelen) != 0)
> -				continue;
> -			if (!xfs_attr_namesp_match(args->flags, entry->flags))
> +			if (!xfs_attr_match(args, name_rmt->namelen,
> +					name_rmt->name, entry->flags))
>  				continue;
>  			args->index = probe;
>  			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
> -- 
> 2.24.1
> 
