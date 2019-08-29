Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA03C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52979233FF
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:31:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZY6PoTZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfH2Vbf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:31:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38502 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfH2Vbe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 17:31:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLO3sm156659;
        Thu, 29 Aug 2019 21:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=O+jsYaqlBMmU4IG9co5JLK7NywGHZHnPA6ePfoKSXjQ=;
 b=ZY6PoTZF1TsQl7iu7WF03myyrNrjGNFn5qdyB1mg4Jqqe02LMvlXSbAxSwb4AvRBevDI
 GKKOo9AdDnkESLCg0dmz9JBAyXxDibT4ByijxDerOGe9Fd9P9+OYj4tk8fOingWXuf+Z
 gMEsI1zshUL7DT6jbyEEjqZGvsoHDlJp7GJBODWFSqqUp8YTsvYhNRbIeZ41fyNr+pyz
 xFUiAtEBYtpiqJbJ9r2nTYnEULFc1DoEW/wxgNyCfOV81YU11JZD1zUe4UBtib/jKHfd
 aC4uUKfm2sA3xzBbpAhBgs8hI3aEd20apqnrezmD0oTbV3pd39RawJaj1r9guv8l37WU 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2upphkg1yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:31:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE4Ns187079;
        Thu, 29 Aug 2019 21:26:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2upkrfftxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:26:31 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TLQVQ3000578;
        Thu, 29 Aug 2019 21:26:31 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:26:31 -0700
Date:   Thu, 29 Aug 2019 14:26:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: consolidate attribute value copying
Message-ID: <20190829212630.GQ5354@magnolia>
References: <20190829113505.27223-1-david@fromorbit.com>
 <20190829113505.27223-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829113505.27223-5-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290215
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:35:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The same code is used to copy do the attribute copying in three
> different places. Consolidate them into a single function in
> preparation from on-demand buffer allocation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 88 +++++++++++++++++++----------------
>  1 file changed, 49 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8085c4f0e5a0..f6a595e76343 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -393,6 +393,44 @@ xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
>  	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
>  }
>  
> +static int
> +xfs_attr_copy_value(
> +	struct xfs_da_args	*args,
> +	unsigned char		*value,
> +	int			valuelen)
> +{
> +	/*
> +	 * No copy if all we have to do is get the length
> +	 */
> +	if (args->flags & ATTR_KERNOVAL) {
> +		args->valuelen = valuelen;
> +		return 0;
> +	}
> +
> +	/*
> +	 * No copy if the length of the existing buffer is too small
> +	 */
> +	if (args->valuelen < valuelen) {
> +		args->valuelen = valuelen;
> +		return -ERANGE;
> +	}
> +	args->valuelen = valuelen;
> +
> +	/* remote block xattr requires IO for copy-in */
> +	if (args->rmtblkno)
> +		return xfs_attr_rmtval_get(args);
> +
> +	/*
> +	 * This is to prevent a GCC warning because the remote xattr case
> +	 * doesn't have a value to pass in. In that case, we never reach here,
> +	 * but GCC can't work that out and so throws a "passing NULL to
> +	 * memcpy" warning.
> +	 */
> +	if (!value)
> +		return -EINVAL;
> +	memcpy(args->value, value, valuelen);
> +	return 0;
> +}
>  
>  /*========================================================================
>   * External routines when attribute fork size < XFS_LITINO(mp).
> @@ -727,11 +765,12 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>   * exist or we can't retrieve the value.
>   */
>  int
> -xfs_attr_shortform_getvalue(xfs_da_args_t *args)
> +xfs_attr_shortform_getvalue(
> +	struct xfs_da_args	*args)
>  {
> -	xfs_attr_shortform_t *sf;
> -	xfs_attr_sf_entry_t *sfe;
> -	int i;
> +	struct xfs_attr_shortform *sf;
> +	struct xfs_attr_sf_entry *sfe;
> +	int			i;
>  
>  	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
>  	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
> @@ -744,18 +783,8 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>  			continue;
>  		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
>  			continue;
> -		if (args->flags & ATTR_KERNOVAL) {
> -			args->valuelen = sfe->valuelen;
> -			return 0;
> -		}
> -		if (args->valuelen < sfe->valuelen) {
> -			args->valuelen = sfe->valuelen;
> -			return -ERANGE;
> -		}
> -		args->valuelen = sfe->valuelen;
> -		memcpy(args->value, &sfe->nameval[args->namelen],
> -						    args->valuelen);
> -		return 0;
> +		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
> +						sfe->valuelen);
>  	}
>  	return -ENOATTR;
>  }
> @@ -2368,7 +2397,6 @@ xfs_attr3_leaf_getvalue(
>  	struct xfs_attr_leaf_entry *entry;
>  	struct xfs_attr_leaf_name_local *name_loc;
>  	struct xfs_attr_leaf_name_remote *name_rmt;
> -	int			valuelen;
>  
>  	leaf = bp->b_addr;
>  	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
> @@ -2380,18 +2408,9 @@ xfs_attr3_leaf_getvalue(
>  		name_loc = xfs_attr3_leaf_name_local(leaf, args->index);
>  		ASSERT(name_loc->namelen == args->namelen);
>  		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
> -		valuelen = be16_to_cpu(name_loc->valuelen);
> -		if (args->flags & ATTR_KERNOVAL) {
> -			args->valuelen = valuelen;
> -			return 0;
> -		}
> -		if (args->valuelen < valuelen) {
> -			args->valuelen = valuelen;
> -			return -ERANGE;
> -		}
> -		args->valuelen = valuelen;
> -		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
> -		return 0;
> +		return xfs_attr_copy_value(args,
> +					&name_loc->nameval[args->namelen],
> +					be16_to_cpu(name_loc->valuelen));
>  	}
>  
>  	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
> @@ -2401,16 +2420,7 @@ xfs_attr3_leaf_getvalue(
>  	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
>  	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
>  					       args->rmtvaluelen);
> -	if (args->flags & ATTR_KERNOVAL) {
> -		args->valuelen = args->rmtvaluelen;
> -		return 0;
> -	}
> -	if (args->valuelen < args->rmtvaluelen) {
> -		args->valuelen = args->rmtvaluelen;
> -		return -ERANGE;
> -	}
> -	args->valuelen = args->rmtvaluelen;
> -	return xfs_attr_rmtval_get(args);
> +	return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);
>  }
>  
>  /*========================================================================
> -- 
> 2.23.0.rc1
> 
