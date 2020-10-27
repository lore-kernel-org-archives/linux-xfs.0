Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F387C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06CA521D41
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WTWYRuOi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505916AbgJ0Fhx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 01:37:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505912AbgJ0Fhx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 01:37:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5YdGD172192;
        Tue, 27 Oct 2020 05:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8cEwqoh0SBYUHs3x4uZS5newn4CIknMPoHi4yWIDQCc=;
 b=WTWYRuOiyP1Z08QDR3x9nXM70wm3II7yMd7UIrBVDFKd+O9DqlRYyBtv2TSNACQadAOF
 RFakmAaH6KkjmpnfkXC5HD/6kvQLmeHZfT0bZ138PybRGlFFlpCjvXYQ5IMXt4J78ND4
 ETU0yL9EfSzBANt9tgDfq9wtTPvbWOkEDJhvRNoa/afcoGBIu4NHOVKuwKzyqA1/wisP
 KvbGZX93+wvwogMfv6xT1gVTDCxQEmdeetWWsDdH3ZH+iajMN8yVj7RVzgE1f/ODjv6I
 9u5iiRjwtO7XMRwWoosDVrbprTq33jArDLkqqYzFslEqKnFFGStvjd8f0a/ogAO/k3Qz /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm3whbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 05:37:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5QGvW152803;
        Tue, 27 Oct 2020 05:35:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1qa682-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 05:35:50 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09R5ZoPj014449;
        Tue, 27 Oct 2020 05:35:50 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 22:35:49 -0700
Subject: Re: [PATCH 3/5] xfs_db: report ranges of invalid rt blocks
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375513208.879169.14762082637245127153.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <95238dbb-af53-ce70-8827-7bd1fe7bf725@oracle.com>
Date:   Mon, 26 Oct 2020 22:35:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160375513208.879169.14762082637245127153.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270037
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/26/20 4:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Copy-pasta the block range reporting code from check_range into
> check_rrange so that we don't flood stdout with a ton of low value
> messages when a bit flips somewhere in rt metadata.
> 
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   db/check.c |   33 ++++++++++++++++++++++++++++++---
>   1 file changed, 30 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index 553249dc9a41..5aede6cca15c 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -1569,19 +1569,46 @@ check_rootdir(void)
>   	}
>   }
>   
> +static inline void
> +report_rrange(
> +	xfs_rfsblock_t	low,
> +	xfs_rfsblock_t	high)
> +{
> +	if (low == high)
> +		dbprintf(_("rtblock %llu out of range\n"), low);
> +	else
> +		dbprintf(_("rtblocks %llu..%llu out of range\n"), low, high);
> +}
> +
>   static int
>   check_rrange(
>   	xfs_rfsblock_t	bno,
>   	xfs_extlen_t	len)
>   {
>   	xfs_extlen_t	i;
> +	xfs_rfsblock_t	low = 0;
> +	xfs_rfsblock_t	high = 0;
> +	bool		valid_range = false;
> +	int		cur, prev = 0;
>   
>   	if (bno + len - 1 >= mp->m_sb.sb_rblocks) {
>   		for (i = 0; i < len; i++) {
> -			if (!sflag || CHECK_BLIST(bno + i))
> -				dbprintf(_("rtblock %llu out of range\n"),
> -					bno + i);
> +			cur = !sflag || CHECK_BLIST(bno + i) ? 1 : 0;
> +			if (cur == 1 && prev == 0) {
> +				low = high = bno + i;
> +				valid_range = true;
> +			} else if (cur == 0 && prev == 0) {
> +				/* Do nothing */
> +			} else if (cur == 0 && prev == 1) {
> +				report_rrange(low, high);
> +				valid_range = false;
> +			} else if (cur == 1 && prev == 1) {
> +				high = bno + i;
> +			}
> +			prev = cur;
>   		}
> +		if (valid_range)
> +			report_rrange(low, high);
>   		error++;
>   		return 0;
>   	}
> 
