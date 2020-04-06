Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1E1C2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4A3120787
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d44LeXb5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgDFWJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 18:09:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42446 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgDFWJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 18:09:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M9obd174906;
        Mon, 6 Apr 2020 22:09:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0bvhh75EkdE1BG6rmlrKA+pMpuN4LGHy4hIZeDuBz6Y=;
 b=d44LeXb5ZaZvzv5ckjnTV8sM/9gvzwpzBU5zdDIlN6Tc9yubh6mmsvtgDfNZcIhLW/zB
 XrHjwzTKoHcIF9UL1CN0cnpe9dC3wncNUBuOqYnZT95EPV3AX2Kk21wgMUMPidSTXnQX
 thIdycpJnomW1tumbQn+HahSrV5no8celrVs3j/TAdVNeuY4aYavGgGaMWKDX1KAXp6U
 g0muyQkxrWFF6gx3KxC4eIdvBTpjQ7blvsZWCOUz0qF6V1IWx7q7IxTgsqbCJyum8Nou
 VOGs47N1Gez3f/QEA5Lh3ZEg3b//ISUn4SdcRR9NGjXcSQPYoLtKL/Mxz40RTEvtH4PS kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 306j6m9je9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:09:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M8i1t140420;
        Mon, 6 Apr 2020 22:09:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3073sqr62k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:09:46 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036M9kx9013742;
        Mon, 6 Apr 2020 22:09:46 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 15:09:45 -0700
Subject: Re: [PATCH 5/5] xfs_scrub: fix type error in render_ino_from_handle
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
 <158619917550.469742.14501955862263559558.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <ebc400f3-73ca-6b20-2260-90e7635c2d16@oracle.com>
Date:   Mon, 6 Apr 2020 15:09:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158619917550.469742.14501955862263559558.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060167
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
> render_ino_from_handle is passed a struct xfs_bulkstat, not xfs_bstat.
> Fix this.
> 
> Fixes: 4cca629d6ae3807 ("misc: convert xfrog_bulkstat functions to have v5 semantics")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, looks good
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   scrub/phase5.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 540b840d..fcd5ba27 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -242,7 +242,7 @@ render_ino_from_handle(
>   	size_t			buflen,
>   	void			*data)
>   {
> -	struct xfs_bstat	*bstat = data;
> +	struct xfs_bulkstat	*bstat = data;
>   
>   	return scrub_render_ino_descr(ctx, buf, buflen, bstat->bs_ino,
>   			bstat->bs_gen, NULL);
> 
