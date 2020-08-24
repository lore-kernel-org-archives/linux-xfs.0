Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2371EC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 17:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F168D206F0
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 17:04:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nhJqlShO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgHXRED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 13:04:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgHXREA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 13:04:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07OGwjSq013047;
        Mon, 24 Aug 2020 17:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nllmSIfT+yc4mSYH5cFlTmUNdm8kVmOMI9MVDg21BTw=;
 b=nhJqlShOF9JEGPRVII9a7cKqOtGv1Pz43fiYC0k3UdSidjKNDNesozLzR+8vJ6WrBBSb
 R/oUE02wQx3ku+//7Hq9f2B16wPdHmEJkyRLCSe+q0Uxjdo6AMAXIQRDungL7xDa6wyy
 i8iljIt6mshk2nTgueFMvkIEsdx9j145ekFSeIn4nyEtNIZgaapTG8yPPwnJ8SrrAzg9
 p5EINpFKxBT4GnVvEz9+BWKggJAjkEb0SxC9SnNLKLTv80MdeRjBqReWdnpi6fO7sat/
 Y2JVwgaZsayasBkAGA7AwucwfhsimlGC2Ksebo5UsYoZyKFH//FUFLXVEQVKPvBULj8N Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 333cshwtcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 17:03:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07OH0kgf145295;
        Mon, 24 Aug 2020 17:03:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 333r9hx5ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 17:03:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07OH3r4v024670;
        Mon, 24 Aug 2020 17:03:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Aug 2020 10:03:53 -0700
Date:   Mon, 24 Aug 2020 10:03:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2 V2] xfs_db: consolidate set_iocur_type() behavior
Message-ID: <20200824170352.GY6096@magnolia>
References: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
 <8062b2d0-3fbb-0240-d5dd-c7bfb452f0b3@redhat.com>
 <bf4a939b-d02b-a916-62e0-e24b967eff38@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf4a939b-d02b-a916-62e0-e24b967eff38@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008240138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=1 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 11:51:56AM -0500, Eric Sandeen wrote:
> Right now there are 3 cases to type_f(): inode type, type with fields,
> and a default. The first two were added to address issues with handling
> V5 metadata.
> 
> The first two already use some version of set_cur(), which handles all
> of the validation etc. There's no reason to leave the open-coded bits
> at the end, just send every non-inode type through set_cur() and be
> done with it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Drop unused *bp var declaration
>     un-indent/un-else the non-inode code
> 
> diff --git a/db/io.c b/db/io.c
> index 884da599..b8cb767e 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -586,7 +586,7 @@ void
>  set_iocur_type(
>  	const typ_t	*type)
>  {
> -	struct xfs_buf	*bp = iocur_top->bp;
> +	int 		bb_count = 1;	/* type's size in basic blocks */

Space after 'int' and before tabs.

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  	/*
>  	 * Inodes are special; verifier checks all inodes in the chunk, the
> @@ -607,29 +607,10 @@ set_iocur_type(
>  	}
>  
>  	/* adjust buffer size for types with fields & hence fsize() */
> -	if (type->fields) {
> -		int bb_count;	/* type's size in basic blocks */
> -
> +	if (type->fields)
>  		bb_count = BTOBB(byteize(fsize(type->fields,
> -					       iocur_top->data, 0, 0)));
> -		set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
> -	}
> -	iocur_top->typ = type;
> -
> -	/* verify the buffer if the type has one. */
> -	if (!bp)
> -		return;
> -	if (!type->bops) {
> -		bp->b_ops = NULL;
> -		bp->b_flags |= LIBXFS_B_UNCHECKED;
> -		return;
> -	}
> -	if (!(bp->b_flags & LIBXFS_B_UPTODATE))
> -		return;
> -	bp->b_error = 0;
> -	bp->b_ops = type->bops;
> -	bp->b_ops->verify_read(bp);
> -	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
> +				       iocur_top->data, 0, 0)));
> +	set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
>  }
>  
>  static void
> 
> 
