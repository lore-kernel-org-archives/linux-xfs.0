Return-Path: <SRS0=tPAf=52=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9677FC2BA2B
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 14:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C14120CC7
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 14:52:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aMQILwz0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgDJOwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 10:52:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51536 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgDJOwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Apr 2020 10:52:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AEn9ov188235;
        Fri, 10 Apr 2020 14:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GC3xg2ZtT93yTbL0+3VOcC6ZUoQltXfWvmCtgLlJln4=;
 b=aMQILwz0x3HEGpcSsIqijrojh8I6Csgk3X21Ef/QQQBDqHgK55UHQcIRny/9oX8G+P9X
 UluQwHIPrbPkW0BaNJSVKckBNgBTNjiFmqAHl2LVEGH/No7H8Jib/TSvjZW7zWTXXNO/
 KWKgAlkq3t0+c1gin5MsZ2A6HNiEMpi2i2d839nbsycaGBevF3l96sARQdlQbgLQzL/v
 fx8Q8WY2PYolv/lQEM85DgmAEhcbuceGagB7qXSJskGK3bklkeYoJ87tmD97de0/Gq52
 16cQhl7Qd8ZVhEwvPTJvV3SBu5ay/LbanbF+cqPqNjyYm6/BxKmluLOz8drU8VwgFcIJ MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 309gw4jm1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 14:51:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AEkpJW150923;
        Fri, 10 Apr 2020 14:51:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 309ag7uhx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 14:51:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03AEpdpL020183;
        Fri, 10 Apr 2020 14:51:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Apr 2020 07:51:38 -0700
Date:   Fri, 10 Apr 2020 07:51:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: simplify the flags setting in xfs_qm_scall_quotaon
Message-ID: <20200410145138.GP6742@magnolia>
References: <1586509024-5856-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586509024-5856-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=835 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004100124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=896 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 10, 2020 at 04:57:04PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Simplify the setting of the flags value, and only consider
> quota enforcement stuff here.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 5d5ac65..944486f 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -357,11 +357,11 @@

No idea which function this is.  diff -p, please.

Also, please consider putting all these minor cleanups into a single
patchset, it's a lot easier (for me) to track and land one series than
it is to handle a steady trickle of single patches.

--D

>  	int		error;
>  	uint		qf;
>  
> -	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>  	/*
> -	 * Switching on quota accounting must be done at mount time.
> +	 * Switching on quota accounting must be done at mount time,
> +	 * only consider quota enforcement stuff here.
>  	 */
> -	flags &= ~(XFS_ALL_QUOTA_ACCT);
> +	flags &= XFS_ALL_QUOTA_ENFD;
>  
>  	if (flags == 0) {
>  		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
> -- 
> 1.8.3.1
> 
