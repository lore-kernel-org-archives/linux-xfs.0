Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E99BC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 21:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7D1922225
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 21:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgLCVWb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:22:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46984 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgLCVWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 16:22:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LLCQt117778;
        Thu, 3 Dec 2020 21:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cXUP3OclgXpdDxb42rLfK69wSRbaZ+B4fq9pjtOIxEw=;
 b=oEQ78i77mKv7ltDG22i88k58BSP4NHJjIuet5lyfYB6LNj7l8TGfyyKmY/t9fGKDS/YL
 vymoWUpIkq+zA1BEr3ilukwnE5RqhkAt2TwufqFQq7Dckq1OscooLQDrbHc2rlG63HOB
 ijKLSZw6l/B4dsulLKy5dM0wogOh37SLSY3WDFZO7EmacBQeT7g+Qqrl3nZzuuB5sWM5
 F5HeXsZvURsAhu0gy4nLfqGTj97mYA589RBkxpPor69TQqUy+2/hne8j/kUv5YmxlENH
 Q6FcRrDlSz2In7FqK78HXSuI2z7UzPI9ftjdCZQj8BQVKniYqqOozr2zChZ1O9hsD6U2 bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2b8ccu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 21:21:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LGCcG105951;
        Thu, 3 Dec 2020 21:21:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540f2ekdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 21:21:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3LLmah018987;
        Thu, 3 Dec 2020 21:21:48 GMT
Received: from localhost (/10.159.242.140) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Thu, 03 Dec 2020 13:20:29 -0800
MIME-Version: 1.0
Message-ID: <20201203212028.GO106272@magnolia>
Date:   Thu, 3 Dec 2020 13:20:28 -0800 (PST)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/3 V3] xfs_quota: document how the default quota is
 stored
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <2e9b1d0f-7ad8-b42a-ac2b-b1fdd9a9fb45@redhat.com>
 <e9c369a2-43d2-c8a0-6be6-1d8070e8cd77@redhat.com>
In-Reply-To: <e9c369a2-43d2-c8a0-6be6-1d8070e8cd77@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030123
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 02:46:10PM -0600, Eric Sandeen wrote:
> Nowhere in the man page is the default quota described; what it
> does or where it is stored.  Add some brief information about this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V3: stop trying, and just use Darrick's nice words.
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index dd0479cd..2a911969 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -178,6 +178,12 @@ to a file on
>  where the user's quota has not been exceeded.
>  Then after rectifying the quota situation, the file can be moved back to the
>  filesystem it belongs on.
> +.SS Default Quotas
> +The XFS quota subsystem allows a default quota to be enforced
> +for any user, group or project which does not have a quota limit
> +explicitly set.
> +These limits are stored in and displayed as ID 0's limits, although they
> +do not actually limit ID 0.
>  .SH USER COMMANDS
>  .TP
>  .B print
> 
> 
