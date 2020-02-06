Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A621C35247
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EDFB20838
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:38:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cbjz5W9p";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aj8iEnYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgBFTiM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 14:38:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgBFTiL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 14:38:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016Jc9UA189522;
        Thu, 6 Feb 2020 19:38:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2tDAdQttFoAnuhNDWpQF8UI4bwnStbbO2BzrRi01exI=;
 b=cbjz5W9pYfa/9e8/Iqd/BIZ8evou5ZVmugXdlblZLxmR/E6ZEBgoNGfyvv99rk7LNHY3
 jKETZCrQopxR8/nE8bm+1ZXZAaWwqDSyRRcBFl4imJ2AQ/Hmcr0oUS2Ibz7ToKzcMmd5
 75RwUx0JnegCDIJ/Nwnlux8sutfryB397HE1i4WFm3VbL8G3GuiHOpJ4ugzCSRG6/978
 /sNErfNrhyxNPExLePpqrj7CBLrZUOe3zh2WvNzBI6u0ieYYZ0RC5tBtG9qeAJWW6nUx
 WQumzrcWDZpVpUbY2f1y+I7Fw86fQDgxU6ExmmCogDUIT76Xu/Ns/3Pdq7FRnYty8xcD ow== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=2tDAdQttFoAnuhNDWpQF8UI4bwnStbbO2BzrRi01exI=;
 b=aj8iEnYz+phBAogoybfZTeG8AYOIRJ75ySMnYyy5eHn8J/dx/u2DuP4jhtEDzJlIR6ce
 ubt0TGeGmlXIpBY8rbJ2VgdvYrxdSPx04z6NI7HSxwT5p2F1eMKs8fOP6crwHkQ8qGme
 SsrRp3+nEnEXaceXZOcv3yfkGyBwshXP49dxft7/LBHvC0M8A1ffg4kH2TMQxziG1oHh
 xDwMt0euxe2qo4Lav8EPZ7EvAQHCYFcd/ZuU230MuonD1zGJgDt7sGojwjbtrciQt4QP
 nsAdFcHVXDo45/jTwC93ot0YP8BxYSR4oYc8A/ANFWBEHW0Xh0NYPYe08PHLq8qIn1iN Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xykbpbxgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:38:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016JSqH9144706;
        Thu, 6 Feb 2020 19:38:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y0jfyf023-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:38:08 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 016Jc71x029218;
        Thu, 6 Feb 2020 19:38:07 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Feb 2020 11:38:07 -0800
Subject: Re: [PATCH 3/4] libxfs: return flush failures
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086366333.2079905.16346740147118345650.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d98bdc0b-e3f1-2c00-90df-8a38388a2651@oracle.com>
Date:   Thu, 6 Feb 2020 12:38:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158086366333.2079905.16346740147118345650.stgit@magnolia>
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
> Modify platform_flush_device so that we can return error status when
> device flushes fail.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
I think there's one other place in init.c where platform_flush_device is 
called, but I suppose it didn't need the return code before?  Other than 
that it looks ok.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libfrog/linux.c    |   25 +++++++++++++++++--------
>   libfrog/platform.h |    2 +-
>   2 files changed, 18 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/libfrog/linux.c b/libfrog/linux.c
> index 41a168b4..60bc1dc4 100644
> --- a/libfrog/linux.c
> +++ b/libfrog/linux.c
> @@ -140,20 +140,29 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
>   	return error;
>   }
>   
> -void
> -platform_flush_device(int fd, dev_t device)
> +/*
> + * Flush dirty pagecache and disk write cache to stable media.  Returns 0 for
> + * success or -1 (with errno set) for failure.
> + */
> +int
> +platform_flush_device(
> +	int		fd,
> +	dev_t		device)
>   {
>   	struct stat	st;
> +	int		ret;
> +
>   	if (major(device) == RAMDISK_MAJOR)
> -		return;
> +		return 0;
>   
> -	if (fstat(fd, &st) < 0)
> -		return;
> +	ret = fstat(fd, &st);
> +	if (ret)
> +		return ret;
>   
>   	if (S_ISREG(st.st_mode))
> -		fsync(fd);
> -	else
> -		ioctl(fd, BLKFLSBUF, 0);
> +		return fsync(fd);
> +
> +	return ioctl(fd, BLKFLSBUF, 0);
>   }
>   
>   void
> diff --git a/libfrog/platform.h b/libfrog/platform.h
> index 76887e5e..0aef318a 100644
> --- a/libfrog/platform.h
> +++ b/libfrog/platform.h
> @@ -12,7 +12,7 @@ int platform_check_ismounted(char *path, char *block, struct stat *sptr,
>   int platform_check_iswritable(char *path, char *block, struct stat *sptr);
>   int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
>   		int fatal);
> -void platform_flush_device(int fd, dev_t device);
> +int platform_flush_device(int fd, dev_t device);
>   char *platform_findrawpath(char *path);
>   char *platform_findblockpath(char *path);
>   int platform_direct_blockdev(void);
> 
