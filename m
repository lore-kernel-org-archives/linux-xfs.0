Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED74C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F2042068E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:57:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q4lEfDyg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfKUV5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 16:57:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfKUV5G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 16:57:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALLnRDO148096;
        Thu, 21 Nov 2019 21:57:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Er66O70RaOHqJbTm1bn4Jvw0VjdFoKG1kbVogVwBjBE=;
 b=Q4lEfDyggX/JPBJ98F47BuK94biKV25qQsKNznAh9WyiMRTFbVDEA1MinAajXNtKQWrI
 7qg4IRVDHEDFj2mQidxjQ+6LqDzcHEsxELVcHvPdAvB7YjsxI9WGCksMv26Nmnh82znV
 84DvlKMrTOAWGA3xb+9vuo6oyAcvah0BHm+Cl/i0Go1/WINLN2s1d2KmZEl4YF1tHY7M
 cbQ9FJs1NGo2m4e+t5WLca0JUT10oNLxl/axLysGvHGCtTkh8oKpOtyEeKYTSAlhV9+b
 GCFThXMsWvNstsvzqkHkUKJJd0zi++VsLoxQq1xfuo5ILEeGVCzbz2zjnLOw5lgQoQJS 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92q753k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 21:57:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALLrxmC116497;
        Thu, 21 Nov 2019 21:55:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wdfrv6y88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 21:55:02 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xALLt2bo009222;
        Thu, 21 Nov 2019 21:55:02 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 13:55:02 -0800
Date:   Thu, 21 Nov 2019 13:55:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191121215501.GZ6219@magnolia>
References: <20191121214445.282160-1-preichl@redhat.com>
 <20191121214445.282160-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121214445.282160-2-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 10:44:44PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 32 +++++++++++++++++++++++++-------
>  1 file changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 18338a61..a02d6f66 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1242,15 +1242,33 @@ done:
>  static void
>  discard_blocks(dev_t dev, uint64_t nsectors)
>  {
> -	int fd;
> +	int		fd;
> +	uint64_t	offset		= 0;
> +	/* Maximal chunk of bytes to discard is 2GB */
> +	const uint64_t	step		= (uint64_t)2<<30;

You don't need the tabs after the variable name, e.g.

	/* Maximal chunk of bytes to discard is 2GB */
	const uint64_t	step = 2ULL << 30;

> +	/* Sector size is 512 bytes */
> +	const uint64_t	count		= nsectors << 9;

count = BBTOB(nsectors)?

>  
> -	/*
> -	 * We intentionally ignore errors from the discard ioctl.  It is
> -	 * not necessary for the mkfs functionality but just an optimization.
> -	 */
>  	fd = libxfs_device_to_fd(dev);
> -	if (fd > 0)
> -		platform_discard_blocks(fd, 0, nsectors << 9);
> +	if (fd <= 0)
> +		return;
> +
> +	while (offset < count) {
> +		uint64_t	tmp_step = step;

tmp_step = min(step, count - offset); ?

Otherwise seems reasonable to me, if nothing else to avoid the problem
where you ask mkfs to discard and can't cancel it....

--D

> +
> +		if ((offset + step) > count)
> +			tmp_step = count - offset;
> +
> +		/*
> +		 * We intentionally ignore errors from the discard ioctl. It is
> +		 * not necessary for the mkfs functionality but just an
> +		 * optimization. However we should stop on error.
> +		 */
> +		if (platform_discard_blocks(fd, offset, tmp_step))
> +			return;
> +
> +		offset += tmp_step;
> +	}
>  }
>  
>  static __attribute__((noreturn)) void
> -- 
> 2.23.0
> 
