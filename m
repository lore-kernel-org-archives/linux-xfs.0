Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AD9C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34AA2206F7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oEKdZLEI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgFRPQp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:16:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48632 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgFRPQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 11:16:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IF759a039268;
        Thu, 18 Jun 2020 15:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KlAY3mX+vOUw8phEmv0WYiY/aXBYhcxVhclJmlMfGYk=;
 b=oEKdZLEIRCjUiP+LcraDOo40TS8IZc4yH/FR7VPSA1ZhOezwMyjYFYFTsRSpyb8ervOc
 fP1+wNJnVW8ROmUpNiHRiskwA1xkiQztuHSnNY0PYdSkjjkr1kZwmmEW0ismQpq2sNZe
 e8tMTwJp1He7PMkXh0FofJCp43644L37S93ohzYdQ9Bjr1+UuoRG91TUSmjihUutJXXi
 uJRfUhoXJQUugGR4iBGSa+3eg1YbZ2Yv5Dg0u2osHRsiQI5S26DNu8QY6dpHm+8Rcmau
 mXT7cqah4zor6HrLm4vHDrcy56NCFBb3O2vfP8NyhyAG0bRkveEQZubltHTRuiZ/kgZo mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31qecm0cja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 15:16:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IF9DlO159976;
        Thu, 18 Jun 2020 15:14:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31q66px2fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 15:14:42 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05IFEf2w014199;
        Thu, 18 Jun 2020 15:14:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 08:14:40 -0700
Date:   Thu, 18 Jun 2020 08:14:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: xfs_quota command error message improvement
Message-ID: <20200618151440.GT11245@magnolia>
References: <20200618144549.192547-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618144549.192547-1-billodo@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9655 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9655 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 malwarescore=0
 clxscore=1015 adultscore=0 suspectscore=1 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 09:45:49AM -0500, Bill O'Donnell wrote:
> Make the error messages for rudimentary xfs_quota commands
> (off, enable, disable) more user friendly, instead of the
> terse sys error outputs.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  quota/state.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/quota/state.c b/quota/state.c
> index 8f9718f1..90406251 100644
> --- a/quota/state.c
> +++ b/quota/state.c
> @@ -306,8 +306,15 @@ enable_enforcement(
>  		return;
>  	}
>  	dir = mount->fs_name;
> -	if (xfsquotactl(XFS_QUOTAON, dir, type, 0, (void *)&qflags) < 0)
> -		perror("XFS_QUOTAON");
> +	if (xfsquotactl(XFS_QUOTAON, dir, type, 0, (void *)&qflags) < 0) {
> +		if (errno == EEXIST)
> +			fprintf(stderr, "quota enforcement already enabled.\n");

All of the strings you've added ought to be wrapped in _() so that they
can be added to the internationalization catalog, e.g.

	fprintf(stderr, _("Quota enforcement already enabled.\n"));

Please capitalize the sentences too. :)

--D

> +		else if (errno == EINVAL)
> +			fprintf(stderr,
> +				"can't enable when quotas are off.\n");
> +		else
> +			perror("XFS_QUOTAON");
> +	}
>  	else if (flags & VERBOSE_FLAG)
>  		state_quotafile_mount(stdout, type, mount, flags);
>  }
> @@ -328,8 +335,15 @@ disable_enforcement(
>  		return;
>  	}
>  	dir = mount->fs_name;
> -	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
> -		perror("XFS_QUOTAOFF");
> +	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
> +		if (errno == EEXIST)
> +			fprintf(stderr, "quota enforcement already disabled.\n");
> +		else if (errno == EINVAL)
> +			fprintf(stderr,
> +				"can't disable when quotas are off.\n");
> +		else
> +			perror("XFS_QUOTAOFF");
> +	}
>  	else if (flags & VERBOSE_FLAG)
>  		state_quotafile_mount(stdout, type, mount, flags);
>  }
> @@ -350,8 +364,15 @@ quotaoff(
>  		return;
>  	}
>  	dir = mount->fs_name;
> -	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
> -		perror("XFS_QUOTAOFF");
> +	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
> +		if (errno == EEXIST)
> +			fprintf(stderr, "quota already off.\n");
> +		else if (errno == EINVAL)
> +			fprintf(stderr,
> +				"can't disable when quotas are off.\n");
> +		else
> +			perror("XFS_QUOTAOFF");
> +	}
>  	else if (flags & VERBOSE_FLAG)
>  		state_quotafile_mount(stdout, type, mount, flags);
>  }
> -- 
> 2.26.2
> 
