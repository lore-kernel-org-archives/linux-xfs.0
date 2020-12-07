Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D2BC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59D272388E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgLGRCo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:02:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46278 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgLGRCn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:02:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7GxFJw196346;
        Mon, 7 Dec 2020 17:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qoyp8AMENxhlhZkzKH4xkNFruJ3riTejOLmVfMSJdPk=;
 b=Rc5dghWvvBnSPXM2KfO+0VbSsJu74E9OK3KhEgKfBotTCgOYOFPANdZj1OGuQhy/+Rd2
 rqez0wc7j8uMddNo/ZZf1GiaI741a+c/N5QlW4Wyk5aVFgO7Z/Qx4zuxvtAx2jULQzBB
 uvcUug1oOYb2ZW6XTnWBu2J7z1tZkLWpgr+JjO+k/T7NtQQB6JPvCLf7uTkZ2dOlvCTE
 VoN7iefFpRgCGmKOuwz/1F9hguAIyUniM6GklC+YNM9RarKzJfVqKrrfK37BgaFiTcfk
 +2YE3iytb4zrd9+o/lpNqd0sDEVFaCNKAAegvH6TnCSHPwM/Nr1O5fNCUMqhIeHG+bzE iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35825kxdv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 17:01:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7Gxfvt120557;
        Mon, 7 Dec 2020 17:01:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 358m4wh0re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 17:01:09 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7H16OG019433;
        Mon, 7 Dec 2020 17:01:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 09:01:05 -0800
Date:   Mon, 7 Dec 2020 09:01:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     fstests@vger.kernel.org, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs/513: fix the regression caused by mount option
 uqnoenforce
Message-ID: <20201207170104.GO629293@magnolia>
References: <1607341265-24200-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607341265-24200-1-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=3
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070109
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 07:41:05PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The mount options uqnoenforce and qnoenforce no longer cause 'usrquota'
> to be emitted in /proc/mounts, so there is a regression in xfs/513. Fix
> it by using proper output option uqnoenforce.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Seems reasonable once the upstream change gets a commit id so that we
can point people at how to fix this new regression.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/xfs/513     | 4 ++--
>  tests/xfs/513.out | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/xfs/513 b/tests/xfs/513
> index dfb25a8b..9045dbb5 100755
> --- a/tests/xfs/513
> +++ b/tests/xfs/513
> @@ -302,8 +302,8 @@ do_test "" pass "usrquota" "false"
>  do_test "-o uquota" pass "usrquota" "true"
>  do_test "-o usrquota" pass "usrquota" "true"
>  do_test "-o quota" pass "usrquota" "true"
> -do_test "-o uqnoenforce" pass "usrquota" "true"
> -do_test "-o qnoenforce" pass "usrquota" "true"
> +do_test "-o uqnoenforce" pass "uqnoenforce" "true"
> +do_test "-o qnoenforce" pass "uqnoenforce" "true"
>  
>  # Test gquota/grpquota/gqnoenforce
>  do_test "" pass "grpquota" "false"
> diff --git a/tests/xfs/513.out b/tests/xfs/513.out
> index 6681a7e8..eec8155d 100644
> --- a/tests/xfs/513.out
> +++ b/tests/xfs/513.out
> @@ -76,8 +76,8 @@ TEST: "" "pass" "usrquota" "false"
>  TEST: "-o uquota" "pass" "usrquota" "true"
>  TEST: "-o usrquota" "pass" "usrquota" "true"
>  TEST: "-o quota" "pass" "usrquota" "true"
> -TEST: "-o uqnoenforce" "pass" "usrquota" "true"
> -TEST: "-o qnoenforce" "pass" "usrquota" "true"
> +TEST: "-o uqnoenforce" "pass" "uqnoenforce" "true"
> +TEST: "-o qnoenforce" "pass" "uqnoenforce" "true"
>  TEST: "" "pass" "grpquota" "false"
>  TEST: "-o gquota" "pass" "grpquota" "true"
>  TEST: "-o grpquota" "pass" "grpquota" "true"
> -- 
> 2.20.0
> 
