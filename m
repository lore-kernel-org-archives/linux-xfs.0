Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74B0C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 15:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1CB20732
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 15:33:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BQPpTfUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgFVPdy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 11:33:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgFVPdx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 11:33:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MFHgVn134070;
        Mon, 22 Jun 2020 15:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vhdwrZxq0gMFzOpTPwfV3kU1iwmUd+pnFHQG4TFwHoA=;
 b=BQPpTfUux5toBtoWaJwsmCyoJ4NnoI8rRcsyI3VmAHw4qZ/Mts3pbSLTqGhb1KPyEy0v
 2AzOOB7OjS2mwqHdJqod0jBIV78NwRHc034f2svTGAxFrism09HPsaGcizLwzjHlNXKK
 qtpdG096LtYHsMKpL7+7f5bOL4zWE08F4JLqq/20XDzyAEl/mGoJB3Li8c1krpvGmU9F
 PFcsR8BN6zkbkbPlIycfsMG9kXeD1dRTVsEdgWnP5aZ7H4+IOAwqem7tBwgVTXKrUqzy
 NvI02uk70M1/qtZkQnvT14DwKAWeZ8cn1hQG3HtA2zW5jcwT5oCRBfKSxRMyYZT8kU88 jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31sebb84fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 15:33:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MFI6lA079022;
        Mon, 22 Jun 2020 15:33:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31sv7qaky5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 15:33:51 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05MFXofJ015238;
        Mon, 22 Jun 2020 15:33:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 15:33:50 +0000
Date:   Mon, 22 Jun 2020 08:33:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfsprogs: xfs_quota command error message improvement
Message-ID: <20200622153349.GE11245@magnolia>
References: <20200622131319.7717-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622131319.7717-1-billodo@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9659 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=1 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006220115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9659 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006220115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 08:13:19AM -0500, Bill O'Donnell wrote:
> Make the error messages for rudimentary xfs_quota commands
> (off, enable, disable) more user friendly, instead of the
> terse sys error outputs.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Yay, another sharp edge smoothed down,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> v2: enable internationalization and capitalize new message strings.
> 
>  quota/state.c | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/quota/state.c b/quota/state.c
> index 8f9718f1..7c9fe517 100644
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
> +			fprintf(stderr, _("Quota enforcement already enabled.\n"));
> +		else if (errno == EINVAL)
> +			fprintf(stderr,
> +				_("Can't enable when quotas are off.\n"));
> +		else
> +			perror("XFS_QUOTAON");
> +	}
>  	else if (flags & VERBOSE_FLAG)
>  		state_quotafile_mount(stdout, type, mount, flags);
>  }
> @@ -328,8 +335,16 @@ disable_enforcement(
>  		return;
>  	}
>  	dir = mount->fs_name;
> -	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
> -		perror("XFS_QUOTAOFF");
> +	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
> +		if (errno == EEXIST)
> +			fprintf(stderr,
> +				_("Quota enforcement already disabled.\n"));
> +		else if (errno == EINVAL)
> +			fprintf(stderr,
> +				_("Can't disable when quotas are off.\n"));
> +		else
> +			perror("XFS_QUOTAOFF");
> +	}
>  	else if (flags & VERBOSE_FLAG)
>  		state_quotafile_mount(stdout, type, mount, flags);
>  }
> @@ -350,8 +365,15 @@ quotaoff(
>  		return;
>  	}
>  	dir = mount->fs_name;
> -	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
> -		perror("XFS_QUOTAOFF");
> +	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
> +		if (errno == EEXIST)
> +			fprintf(stderr, _("Quota already off.\n"));
> +		else if (errno == EINVAL)
> +			fprintf(stderr,
> +				_("Can't disable when quotas are off.\n"));
> +		else
> +			perror("XFS_QUOTAOFF");
> +	}
>  	else if (flags & VERBOSE_FLAG)
>  		state_quotafile_mount(stdout, type, mount, flags);
>  }
> -- 
> 2.26.2
> 
