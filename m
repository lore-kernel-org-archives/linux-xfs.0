Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9047AC4CEC7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 23:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 646A8206CD
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 23:42:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TlS1T+x5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfILXmn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 19:42:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44580 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfILXmm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 19:42:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CNdSuN067637;
        Thu, 12 Sep 2019 23:42:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=k/CFDnKqe4y4NsC0RWVLwlCc3B/bvXvBz1ZbA7LXbu8=;
 b=TlS1T+x5pNyl4EU6lvuyU1QmGY8QUxwlXQezWT8psZU/IoAN5ozfgJkNBMyXVTCAusjG
 XbxZF+Co01WqQYFpgSjHIFqwWyYsWOONePU73SjlZ3OCHScW+MgOzFqsSz3YOdMHoKqG
 0jhOn+wlAcpLI9lXHDVzhn86ujjLCFY8l6kHTWPWxWB+vGY0Tw2TzKGiSxQ+i8UMaIaZ
 WH1aMVB0NoyZdlhu61XnrjsnCSC3hCFOFUHZc/z0YQLGS57mh16reLg1G3f6UJsbwsAT
 /9LB+u4kGk8KQyzQx9kuLNGr6IYP34QD3DW+tKdRSU+rJlerwro5rtDgxpUBbDh4zNEb /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uytd31g9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 23:42:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CNcGjV120399;
        Thu, 12 Sep 2019 23:42:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uytdw2f7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 23:42:38 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8CNgbFo003164;
        Thu, 12 Sep 2019 23:42:37 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Sep 2019 16:42:37 -0700
Subject: Re: [PATCH 3/3] xfs_scrub: relabel verified data block counts in
 output
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <156774123336.2646704.1827381294403838403.stgit@magnolia>
 <156774125207.2646704.16836517557282368220.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <adf29487-d3d9-4f84-3af2-2934dfb0a6c4@oracle.com>
Date:   Thu, 12 Sep 2019 16:42:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156774125207.2646704.16836517557282368220.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909120242
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909120242
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ok, you can add my review:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

On 9/5/19 8:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Relabel the count of verified data blocks to make it more obvious that
> we were only looking for file data.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   scrub/phase7.c    |   13 ++++++++-----
>   scrub/xfs_scrub.c |    2 ++
>   2 files changed, 10 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/scrub/phase7.c b/scrub/phase7.c
> index 570ceb3f..2622bc45 100644
> --- a/scrub/phase7.c
> +++ b/scrub/phase7.c
> @@ -116,6 +116,7 @@ xfs_scan_summary(
>   	unsigned long long	f_free;
>   	bool			moveon;
>   	bool			complain;
> +	bool			scrub_all = scrub_data > 1;
>   	int			ip;
>   	int			error;
>   
> @@ -244,14 +245,15 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
>   	}
>   
>   	/*
> -	 * Complain if the checked block counts are off, which
> +	 * Complain if the data file verification block counts are off, which
>   	 * implies an incomplete check.
>   	 */
> -	if (ctx->bytes_checked &&
> +	if (scrub_data &&
>   	    (verbose ||
>   	     !within_range(ctx, used_data + used_rt,
>   			ctx->bytes_checked, absdiff, 1, 10,
> -			_("verified blocks")))) {
> +			scrub_all ? _("verified blocks") :
> +				    _("verified file data blocks")))) {
>   		double		b1, b2;
>   		char		*b1u, *b2u;
>   
> @@ -262,8 +264,9 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
>   
>   		b1 = auto_space_units(used_data + used_rt, &b1u);
>   		b2 = auto_space_units(ctx->bytes_checked, &b2u);
> -		fprintf(stdout,
> -_("%.1f%s data counted; %.1f%s data verified.\n"),
> +		fprintf(stdout, scrub_all ?
> +_("%.1f%s data counted; %.1f%s disk media verified.\n") :
> +_("%.1f%s data counted; %.1f%s file data media verified.\n"),
>   				b1, b1u, b2, b2u);
>   		fflush(stdout);
>   	}
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 46876522..89f6c96a 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -432,6 +432,8 @@ run_scrub_phases(
>   		/* Turn on certain phases if user said to. */
>   		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
>   			sp->fn = xfs_scan_blocks;
> +			if (scrub_data > 1)
> +				sp->descr = _("Verify disk integrity.");
>   		} else if (sp->fn == REPAIR_DUMMY_FN &&
>   			   ctx->mode == SCRUB_MODE_REPAIR) {
>   			sp->descr = _("Repair filesystem.");
> 
