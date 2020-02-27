Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C02C3F2C6
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2092469C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:36:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AncIhX8a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgB0XgE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 18:36:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58412 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbgB0XgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 18:36:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNXoKc021412;
        Thu, 27 Feb 2020 23:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dGxao21xyqU5kQSpA/r6djasx0GFZ3TqKtpRMdSVIjo=;
 b=AncIhX8aCD4BDjst5LvJyOrbHW5lCca1bAAl323ThWKQUjsxRp75PShkq+sIMAXijWeQ
 K4RAS9K2+7r0iG5OLufcNZXTgtlK3L2xN7ErxZF56AXDO24xMbeT90CcvRl7S5DMbFJW
 demX3RcFbMoJyidDeYgCOfK5LY1aKo3zb0Ray9kZjpgoTMPXaVduBIgaiO4CVLRZrClI
 T09qgV7pF+bu6gBF+pTxTRwo1goqWmYJRzEFAcvSe7gi3VKuMeip9eIGDoiaS0Sxjmyj
 41GEJAh3RtwWXbRQi0FLrmdBviLpD7prbK7Lx+Jmd4cbHgsXaMJSXo7Vti6nvEpKDRq8 LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yehxrst3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:36:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNWqaf120894;
        Thu, 27 Feb 2020 23:36:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ydcsdn5rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:36:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01RNZxqo027171;
        Thu, 27 Feb 2020 23:35:59 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 15:35:59 -0800
Subject: Re: [RFC v5 PATCH 8/9] xfs: create an error tag for random relog
 reservation
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-9-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <357287c8-420f-b854-33ae-c716eb6c138b@oracle.com>
Date:   Thu, 27 Feb 2020 16:35:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227134321.7238-9-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/27/20 6:43 AM, Brian Foster wrote:
> Create an errortag to randomly enable relogging on permanent
> transactions. This only stresses relog reservation management and
> does not enable relogging of any particular items. The tag will be
> reused in a subsequent patch to enable random item relogging.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Alrighty, looks ok:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>   fs/xfs/xfs_error.c           | 3 +++
>   fs/xfs/xfs_trans.c           | 6 ++++++
>   3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 79e6c4fb1d8a..ca7bcadb9455 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -55,7 +55,8 @@
>   #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
>   #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>   #define XFS_ERRTAG_IUNLINK_FALLBACK			34
> -#define XFS_ERRTAG_MAX					35
> +#define XFS_ERRTAG_RELOG				35
> +#define XFS_ERRTAG_MAX					36
>   
>   /*
>    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -95,5 +96,6 @@
>   #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
>   #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>   #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
> +#define XFS_RANDOM_RELOG				XFS_RANDOM_DEFAULT
>   
>   #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 331765afc53e..2838b909287e 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -53,6 +53,7 @@ static unsigned int xfs_errortag_random_default[] = {
>   	XFS_RANDOM_FORCE_SCRUB_REPAIR,
>   	XFS_RANDOM_FORCE_SUMMARY_RECALC,
>   	XFS_RANDOM_IUNLINK_FALLBACK,
> +	XFS_RANDOM_RELOG,
>   };
>   
>   struct xfs_errortag_attr {
> @@ -162,6 +163,7 @@ XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
>   XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>   XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>   XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> +XFS_ERRORTAG_ATTR_RW(relog,		XFS_ERRTAG_RELOG);
>   
>   static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -199,6 +201,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(force_repair),
>   	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>   	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
> +	XFS_ERRORTAG_ATTR_LIST(relog),
>   	NULL,
>   };
>   
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index f7f2411ead4e..24e0208b74b8 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -19,6 +19,7 @@
>   #include "xfs_trace.h"
>   #include "xfs_error.h"
>   #include "xfs_defer.h"
> +#include "xfs_errortag.h"
>   
>   kmem_zone_t	*xfs_trans_zone;
>   
> @@ -263,6 +264,11 @@ xfs_trans_alloc(
>   	struct xfs_trans	*tp;
>   	int			error;
>   
> +	/* relogging requires permanent transactions */
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RELOG) &&
> +	    resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
> +		flags |= XFS_TRANS_RELOG;
> +
>   	/*
>   	 * Allocate the handle before we do our freeze accounting and setting up
>   	 * GFP_NOFS allocation context so that we avoid lockdep false positives
> 
