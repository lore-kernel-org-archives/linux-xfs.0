Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CFDC4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E18E72220F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgLCUmx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:42:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42822 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgLCUmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:42:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KdDAl025966;
        Thu, 3 Dec 2020 20:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9SeIYDiFAQuPOEG4XxB/t67BOSwmFmeXcLhuwqwMH84=;
 b=CJwshgynuFOuzIAobDofEdzxWvLi8VGtRNV8589OjHwZ+OGAcwb9q+yQk+3Y3GkRIZe2
 PTlPM8MWiWaFBZyDHud7A8rq1W7iuOL0rLOnsWI0c+CRedREZk8IUWl4BowQjUNYww3P
 UY5X7rad/Ho8VeMyyoS3GzA0Q6YWiRgLjNv++7On86OLj0tn7yTKY3afTn4HipCznwff
 A5VzDJ7tYVgbqAof+roi1O0XQ0wws1g6GnjFU0bGKGlzzJLkUeuuz/saa74yMdzsZt4s
 IORXaEYrNUuclGlYbgnHUvaThWLCgwyKd38P+E8HRVRvw/Az3lciBwoImpofY/sxkD57 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2b87sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 20:42:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KdSwT029558;
        Thu, 3 Dec 2020 20:40:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540g2dkps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 20:40:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3Ke9Ps026737;
        Thu, 3 Dec 2020 20:40:09 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 12:40:08 -0800
Date:   Thu, 3 Dec 2020 12:40:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/3 V2] xfsprogs: make things non-gender-specific
Message-ID: <20201203204008.GN106272@magnolia>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <9fde98da-d221-87d0-a401-2c82cf1df35f@redhat.com>
 <7b81f21d-68b9-86e1-de7e-f9e82dd28195@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b81f21d-68b9-86e1-de7e-f9e82dd28195@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 02:33:26PM -0600, Eric Sandeen wrote:
> Users are not exclusively male, so fix that implication
> in the xfs_quota manpage and the configure.ac comments.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good now,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: Fix configure.ac comments too, and fix a missed "him" in the manpage
>     also "choses" is not a word :)
> 
> diff --git a/configure.ac b/configure.ac
> index 645e4572..48f3566d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -113,7 +113,7 @@ esac
>  # Some important tools should be installed into the root partitions.
>  #
>  # Check whether exec_prefix=/usr: and install them to /sbin in that
> -# case.  If the user choses a different prefix assume he just wants
> +# case.  If the user chooses a different prefix assume they just want
>  # a local install for testing and not a system install.
>  #
>  case $exec_prefix:$prefix in
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index 74c24916..cfb87621 100644
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
> +They can use the editor shell escape command to examine their file space
>  and remove surplus files.  Alternatively, using
>  .BR sh (1),
> -he can suspend
> +they can suspend
>  the editor, remove some files, then resume it.
>  A third possibility is to write the file to some other filesystem (perhaps
>  to a file on
> 
