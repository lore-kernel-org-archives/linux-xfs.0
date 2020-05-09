Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC743C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C89FE2184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:06:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eDacr80B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgEIRGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:06:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44842 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:06:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H4DMB128255;
        Sat, 9 May 2020 17:06:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Q1NdSwN/xaC+ji7BTDfYCCYcpI4VfbvL7pK3NKOvdYk=;
 b=eDacr80Bck1HRwY7gxYGUDQB5qkNUFfrptYR32OWaL1asMDbX3hXN/33O0a+D/9uCH1o
 3s3PARVAOF4Vd/yCrqumVuEVvQgU1abua6LkawN5qlluzZ7r3ncILZktDLNVJCLGHmkI
 DtduXLI6mTmvEaFZo1815mKkjdlPbztrI00JjqvBzd9R8VuvK6A/BTTxpZBPvw+/+zKh
 xLtLNMpV/c5wn1LxhjZm/WquNjkr2J8mhIyTfEdOCzRhEjkRfDEQqKsAUQ4jPVUKq2jk
 tJSP81FaB3pXAJ/LCZNyLaexz+HK/4O1oPoC54cnXXIACnKokR00dKRPwA+9z8SN2SLm /w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30x0gh80ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:06:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H5W5X162603;
        Sat, 9 May 2020 17:06:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30wx186aq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:06:25 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049H6JvZ003518;
        Sat, 9 May 2020 17:06:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 10:06:19 -0700
Date:   Sat, 9 May 2020 10:06:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] libxfs: use tabs instead of spaces in div_u64
Message-ID: <20200509170617.GO6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170125.952508-2-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 suspectscore=1 priorityscore=1501 malwarescore=0 clxscore=1015 mlxscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 07:01:18PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  libxfs/libxfs_priv.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 8d717d91..5688284d 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -263,8 +263,8 @@ div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
>   */
>  static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
>  {
> -        uint32_t remainder;
> -        return div_u64_rem(dividend, divisor, &remainder);
> +	uint32_t remainder;
> +	return div_u64_rem(dividend, divisor, &remainder);
>  }
>  
>  /**
> -- 
> 2.26.2
> 
