Return-Path: <SRS0=IS9S=2E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B91C43603
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 20:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5F412073D
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 20:21:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cU5LDUjL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfLNUVt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Dec 2019 15:21:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37910 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfLNUVs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Dec 2019 15:21:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBEKLhPB165896;
        Sat, 14 Dec 2019 20:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=dEjtibkkviECxs0ZjvRYHQTAf9+A0g/0ymE7aajPyeI=;
 b=cU5LDUjLVP312SJ8ht1y5VXWDMm0mdFvZoD3j3NrBVvUKhHa4ta2liayrUNMlvE1H7uO
 6r5Zo7YrvH7ZqCwfiQ+5S7CxxEn9j1BNPjN0g8wL9pYSkinjSGJch1TgF4CPMPy+MKin
 7kkl7mmzRxbaMCQ8vVy2EXW4wDxRE3rUoit0Zke05or966of/iv1HTAB2ncVDKpuLIoj
 C0X0UDYO6M4os9yll4RjE9Y5n23Ijn3wIg2rZGKFWTAK5q1awSnYhgXoMVc5oG4yVHz0
 l05WGw7OQyvd68T+bJ7jvkAIF/XM9Y34OhxLOGG0MbRSvaibci0P1M70EEgrwUrihjaY 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wvqppsq9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 20:21:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBEKLXwQ019555;
        Sat, 14 Dec 2019 20:21:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wvq2q8waa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 20:21:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBEKLfd5029960;
        Sat, 14 Dec 2019 20:21:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 14 Dec 2019 20:21:41 +0000
Date:   Sat, 14 Dec 2019 12:21:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] mkfs: tidy up discard notifications
Message-ID: <20191214202140.GD99884@magnolia>
References: <20191214180559.GN99875@magnolia>
 <03236390-ea33-3da7-e2a2-a33ff651bfe8@sandeen.net>
 <371216cf-4e6b-ec5f-c147-6ebd545818d1@sandeen.net>
 <c4d20fc5-150b-7afc-e2fd-2358e52acb9c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4d20fc5-150b-7afc-e2fd-2358e52acb9c@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9471 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912140156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9471 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912140156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 14, 2019 at 12:53:56PM -0600, Eric Sandeen wrote:
> Only notify user of discard operations if the first one succeeds,
> and be sure to print a trailing newline if we stop early.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Logic is hard.  ;)  If I messed this one up, take it back Darrick.  :)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4bfdebf6..606f79da 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1251,10 +1251,6 @@ discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
>  	fd = libxfs_device_to_fd(dev);
>  	if (fd <= 0)
>  		return;
> -	if (!quiet) {
> -		printf("Discarding blocks...");
> -		fflush(stdout);
> -	}
>  
>  	/* The block discarding happens in smaller batches so it can be
>  	 * interrupted prematurely
> @@ -1267,12 +1263,20 @@ discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
>  		 * not necessary for the mkfs functionality but just an
>  		 * optimization. However we should stop on error.
>  		 */
> -		if (platform_discard_blocks(fd, offset, tmp_step))
> +		if (platform_discard_blocks(fd, offset, tmp_step) == 0) {
> +			if (offset == 0 && !quiet) {
> +				printf("Discarding blocks...");
> +				fflush(stdout);
> +			}
> +		} else {
> +			if (offset > 0 && !quiet)
> +				printf("\n");

Maybe we should say failed?  Or ... eh... whatever, the format happens
regardless.

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  			return;
> +		}
>  
>  		offset += tmp_step;
>  	}
> -	if (!quiet)
> +	if (offset > 0 && !quiet)
>  		printf("Done.\n");
>  }
>  
> 
> 
