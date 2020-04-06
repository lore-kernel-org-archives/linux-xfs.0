Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB69C2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6767208E4
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e/Z/pGjA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgDFWIJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 18:08:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41116 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFWIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 18:08:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M864b173522;
        Mon, 6 Apr 2020 22:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=M3W1O27JGNXImCVYmdJEdOxJj+xR+FLsQcgRPEbUn3g=;
 b=e/Z/pGjASC4LrU6QLYSRgo0gQ+m/n6vNhZA4D+ujGrKC3yjrofr14Xy22JszDEiwpvPB
 zNsq4bl0U504plt5FHe3FGP45cGiTpV6BCbe82MIeVIBQyUdVot14uAk0WBgJCda4wRD
 l8FQ7WAQWGS2wylnsqx54/u5gBrTQPy2XH7fiAPdzrTE0TcDU9AjB85Pmqm6GdeF7dul
 xrtHCkar9dTIUkVbBJ+i3LlN6I6fIenpe6nwf/Ep5psLknLGp0MRnj95ZmfaeHm4Y6ic
 wDjdHHaVkvBHWjfBOo5wWeKUlCMXWAj+J0Bu+2JUh5ND834Up71LfAXZAB8SytHhNiaH Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 306j6m9j8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:08:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M3FUB183251;
        Mon, 6 Apr 2020 22:06:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3073qe5xa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:06:05 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036M64HW012212;
        Mon, 6 Apr 2020 22:06:04 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 15:06:03 -0700
Subject: Re: [PATCH 1/5] libxfs: don't barf in libxfs_bwrite on a null buffer
 ops name
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
 <158619915000.469742.14620929774691026014.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a600df3f-8bc8-1216-8d42-7671736f4bdb@oracle.com>
Date:   Mon, 6 Apr 2020 15:06:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158619915000.469742.14620929774691026014.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/20 11:52 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't crash if we failed to write a buffer that had no buffer verifier.
> This should be rare in practice, but coverity found a valid bug.
> 
> Coverity-id: 1460462
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks ok:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libxfs/rdwr.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 3c43a4d0..8a690269 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1028,7 +1028,7 @@ libxfs_bwrite(
>   	if (bp->b_error) {
>   		fprintf(stderr,
>   	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
> -			__func__, bp->b_ops->name,
> +			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
>   			(long long)bp->b_bn, bp->b_bcount, -bp->b_error);
>   	} else {
>   		bp->b_flags |= LIBXFS_B_UPTODATE;
> 
