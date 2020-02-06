Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F97C352A3
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AFD5218AC
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LnOdOHIe";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fV8EFM7k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFTiH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 14:38:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbgBFTiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 14:38:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016Jc4aY001897;
        Thu, 6 Feb 2020 19:38:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=H+PadwFD+pUFBPq67rmSOEisC2mS8BwPulOB1fnxIC8=;
 b=LnOdOHIefADGEawU8i5iBuFNncF8ta6I1mhFlGIR17CHAbyIjJEWXOM7ZNG/DLgMo1cw
 FQFb8R9El8QTXFILxxGg3Z/KNugFZ6nspB2cvE+d2fsTioIFGumOt+Kd0U/FitckzEmA
 zN6rXOQm72SbPk/urxPKaV8Y23h+5Be3UwCupsGmEOzcuFXb7CgpMXqaUbgwj4hO3bCx
 /UA/hrvB8YDim1Kki0AinIYieIRtL2T2hwkzOGawkE6GOjxSWUB8XS1TeaNY+mNAhh0J
 BQTJqzM+HvGcPkS+lpbyira5FPgv/axieMSfoRd5xgzYfD4kUi7tOtyz1oDxEFb4um30 iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=H+PadwFD+pUFBPq67rmSOEisC2mS8BwPulOB1fnxIC8=;
 b=fV8EFM7kp3X/0Ex6TTA36lVNBDX2wgBW33ktoYhxmmgt4CTzzs7l6CdUtM42KZDyzpO/
 oOZBq8iwew6MmX/jDKKSNNTGjuDjxCcpkJAOQNOUVHtuSsXrCi+2MNhrTtgYDKVeN1oE
 gg9YUnI6yA5qwfnvlEMVkjjqH4tSZMeE35Anly8UtSm2w4qrkYUYuSIQ+imdCfOah+Fx
 xDQJgnYC9S2uZgJ9mrPqEWkA2xc88OjT9EWEThLxFSQQzu4MKgyrMYE7i1jm9hEkLXef
 VtjUzlRkZzqCPrqJ9NXnAWhooaRWpKXKyP8k4oFpr7fZ3m2KXhtWHfuiEUr/k3N8l4Tz uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xykbpkxhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:38:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016JTDQA063916;
        Thu, 6 Feb 2020 19:38:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y080dxfku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:38:00 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 016JbxJj021940;
        Thu, 6 Feb 2020 19:37:59 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Feb 2020 11:37:59 -0800
Subject: Re: [PATCH 1/4] libxfs: libxfs_buf_delwri_submit should write buffers
 immediately
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086365123.2079905.12151913907904621987.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <15d22de3-79a2-2a6d-2453-c9ecb82fee92@oracle.com>
Date:   Thu, 6 Feb 2020 12:37:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158086365123.2079905.12151913907904621987.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002060143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002060144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/4/20 5:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The whole point of libxfs_buf_delwri_submit is to submit a bunch of
> buffers for write and wait for the response.  Unfortunately, while it
> does mark the buffers dirty, it doesn't actually flush them and lets the
> cache mru flusher do it.  This is inconsistent with the kernel API,
> which actually writes the buffers and returns any IO errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks ok to me:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libxfs/rdwr.c   |    3 ++-
>   mkfs/xfs_mkfs.c |   16 ++++++++++------
>   2 files changed, 12 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 0d9d7202..2e9f66cc 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1491,9 +1491,10 @@ xfs_buf_delwri_submit(
>   
>   	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
>   		list_del_init(&bp->b_list);
> -		error2 = libxfs_writebuf(bp, 0);
> +		error2 = libxfs_writebufr(bp);
>   		if (!error)
>   			error = error2;
> +		libxfs_putbuf(bp);
>   	}
>   
>   	return error;
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 5a042917..1f5d2105 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3685,6 +3685,7 @@ main(
>   	};
>   
>   	struct list_head	buffer_list;
> +	int			error;
>   
>   	platform_uuid_generate(&cli.uuid);
>   	progname = basename(argv[0]);
> @@ -3885,16 +3886,19 @@ main(
>   		if (agno % 16)
>   			continue;
>   
> -		if (libxfs_buf_delwri_submit(&buffer_list)) {
> -			fprintf(stderr, _("%s: writing AG headers failed\n"),
> -					progname);
> +		error = -libxfs_buf_delwri_submit(&buffer_list);
> +		if (error) {
> +			fprintf(stderr,
> +	_("%s: writing AG headers failed, err=%d\n"),
> +					progname, error);
>   			exit(1);
>   		}
>   	}
>   
> -	if (libxfs_buf_delwri_submit(&buffer_list)) {
> -		fprintf(stderr, _("%s: writing AG headers failed\n"),
> -				progname);
> +	error = -libxfs_buf_delwri_submit(&buffer_list);
> +	if (error) {
> +		fprintf(stderr, _("%s: writing AG headers failed, err=%d\n"),
> +				progname, error);
>   		exit(1);
>   	}
>   
> 
