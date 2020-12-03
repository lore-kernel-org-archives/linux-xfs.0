Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01262C4167B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4B48221F4
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbgLCULR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:11:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45412 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgLCULR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:11:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3K9Adf157129;
        Thu, 3 Dec 2020 20:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=io/lUN5UjVtoi45ox3nkO7709EzT8dfWB+QmJlPzg04=;
 b=u4EcAfbm+EpE2avTyiACFwRj+G4ziC9hjeaYJPiiSt6zpp5KDBw5yD06f+sdvc93nxfH
 62zcuOvzkdaV2naorV5wUHtg+77PAyKTWM1fsGueRo8NfrXxqW9RgtMQV/gsUgJwpzeJ
 Iv7TXMtbQTN7Xh5RlierHkFI89ko/6eWdh0TzFXlYqbcF026391cQcpUflFu/GX80Pnu
 JKI+RkhVd1eZ4BsiSh5tr+mv3Z0WZ4XVnikWF4wbv0ML3OuLaBlWBVvmbTjqwInjaumn
 ZUJVjVf1K+Z5b7cuKHZkhZJ26APSdIEGby+0uHuU33XnK+1GI6iKWVyAW+MEhQaKdGuL Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2b83se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 20:10:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KAVhn087972;
        Thu, 3 Dec 2020 20:10:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35404rbgsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 20:10:34 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3KAXOM023075;
        Thu, 3 Dec 2020 20:10:33 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 12:10:33 -0800
Date:   Thu, 3 Dec 2020 12:10:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs_quota: make manpage non-male-specific
Message-ID: <20201203201032.GL106272@magnolia>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <9fde98da-d221-87d0-a401-2c82cf1df35f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fde98da-d221-87d0-a401-2c82cf1df35f@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030117
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 02:01:24PM -0600, Eric Sandeen wrote:
> Users are not exclusively male, so fix that implication.

Why not fix configure.ac too?  Surely ./configure users are not also
exclusively male? ;)

"If the user choses a different prefix assume he just wants..."

--D

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  man/man8/xfs_quota.8 | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index bfdc2e4f..beb6da13 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -128,7 +128,7 @@ To most users, disk quotas are either of no concern or a fact of life
>  that cannot be avoided.
>  There are two possible quotas that can be imposed \- a limit can be set
>  on the amount of space a user can occupy, and there may be a limit on
> -the number of files (inodes) he can own.
> +the number of files (inodes) they can own.
>  .PP
>  The
>  .B quota
> @@ -167,10 +167,10 @@ the file, not only are the recent changes lost, but possibly much, or even
>  all, of the contents that previously existed.
>  .br
>  There are several possible safe exits for a user caught in this situation.
> -He can use the editor shell escape command to examine his file space
> +They can use the editor shell escape command to examine his file space
>  and remove surplus files.  Alternatively, using
>  .BR sh (1),
> -he can suspend
> +they can suspend
>  the editor, remove some files, then resume it.
>  A third possibility is to write the file to some other filesystem (perhaps
>  to a file on
> -- 
> 2.17.0
> 
