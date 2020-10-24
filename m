Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78458C2D0A3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 22:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24DB220936
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 22:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IUfms1Qb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762277AbgJXWVX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 18:21:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56000 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733077AbgJXWVX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 18:21:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OMLGCp191332;
        Sat, 24 Oct 2020 22:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=K69bEUFGwhIF14ql+icjGNamhS2PxsstAtwJEBmCKt0=;
 b=IUfms1Qbx6czU1aPuaAJWkhLXZaefPI8C/WPvNx2+F0/mGxlszGNiR2xMYx8FqOWYcE1
 25Jc66QiU+9489Usgt6Ur1oT37mVYNtjwCFhFseyc9IbEnqAGveO2K8boApfK05FcYoH
 N6G+S9xxhPo8aSuRnY+8jpfi2Zkh1RrY5pN77Aa5Xav1/Lg5mirMTVj4MT/r0jRhIVPp
 izRiuzOazdab1J5SoI+mPQIK4U+RfGk4Ps9gUKUjNn5SQqoPhVPdpTt4J3pd4XCsna+j
 jjPo0gbnWIFZWyuirr5ATBIxLiJh6UO0pU2w5XXp2t+aVMGE94XLA3P3uIhlp3GJEtT4 og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kh50p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 22:21:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OMK7qb117373;
        Sat, 24 Oct 2020 22:21:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34cbkhq59n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 22:21:15 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09OMLFtd010645;
        Sat, 24 Oct 2020 22:21:15 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 15:21:14 -0700
Subject: Re: [PATCH V7 11/14] xfs: Remove duplicate assert statement in
 xfs_bmap_btalloc()
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-12-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <1d1be92c-9264-e7a5-e18d-f2ecc846b5dd@oracle.com>
Date:   Sat, 24 Oct 2020 15:21:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-12-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240171
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> The check for verifying if the allocated extent is from an AG whose
> index is greater than or equal to that of tp->t_firstblock is already
> done a couple of statements earlier in the same function. Hence this
> commit removes the redundant assert statement.
> 
Ok, I see the extra check
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_bmap.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 505358839d2f..64c4d0e384a5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3699,7 +3699,6 @@ xfs_bmap_btalloc(
>   		ap->blkno = args.fsbno;
>   		if (ap->tp->t_firstblock == NULLFSBLOCK)
>   			ap->tp->t_firstblock = args.fsbno;
> -		ASSERT(nullfb || fb_agno <= args.agno);
>   		ap->length = args.len;
>   		/*
>   		 * If the extent size hint is active, we tried to round the
> 
