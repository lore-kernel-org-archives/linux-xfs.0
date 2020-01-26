Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DF4C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB73D206F0
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:20:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WjmbNEK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgAZWUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 17:20:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44042 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZWUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:20:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMIKcb069894;
        Sun, 26 Jan 2020 22:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6Dx4MfmGn00HziNWzT2AUuQUP/RjMTLdAw8K13tjDLQ=;
 b=WjmbNEK9uzWwlOMu8RT+iU3JIPYWFSPtOAtQUL3lmxZoZM37tYV0JUmEA/DVxKttMMLV
 PTGWNUP1CB80mlWW7bQxOJUHBRAvhK1yrc+WxO8ps8CIl1D5uYRlc4Ik3gE369aDM2F0
 ed96DoxG7g6+t9MKOgkIwsVTbjxndpzlAQR/Uknl6x37X5lJ53SRZb1dIbh5wPyM9jap
 x6eenIRh48vz/TDGrF/bYqqBrG17RGTZxU1BrdJNUVASoz1xYOl7h1zniBz+yoRzFq5x
 sCk0QQKADiqXrBm/J0cfd/rPnaWWaNeAwuaCPBJnaL3fOuMzHkZ43sIb9SLeDSafiHvA jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xrd3tvh5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:20:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMJa8I175728;
        Sun, 26 Jan 2020 22:20:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xry6nby8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:20:27 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00QMKQjB017210;
        Sun, 26 Jan 2020 22:20:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:20:25 -0800
Date:   Sun, 26 Jan 2020 14:20:25 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfsprogs: remove the SIZEOF_LONG substitution in
 platform_defs.h.in
Message-ID: <20200126222025.GH3447196@magnolia>
References: <20200126113541.787884-1-hch@lst.de>
 <20200126113541.787884-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126113541.787884-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260194
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 26, 2020 at 12:35:40PM +0100, Christoph Hellwig wrote:
> BITS_PER_LONG is now only checked in C expressions, so we can simply
> define it based on sizeof(long).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  include/platform_defs.h.in | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
> index ff0a6a4e..36006cbf 100644
> --- a/include/platform_defs.h.in
> +++ b/include/platform_defs.h.in
> @@ -26,9 +26,7 @@
>  
>  typedef struct filldir		filldir_t;
>  
> -/* long and pointer must be either 32 bit or 64 bit */
> -#undef SIZEOF_LONG
> -#define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
> +#define BITS_PER_LONG (sizeof(long) * CHAR_BIT)
>  
>  /* Check whether to define umode_t ourselves. */
>  #ifndef HAVE_UMODE_T
> -- 
> 2.24.1
> 
