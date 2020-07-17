Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA897C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 21:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B274F20717
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 21:11:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bUA57Cjs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGQVLC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:11:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37060 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgGQVLC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jul 2020 17:11:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HL80P1049403;
        Fri, 17 Jul 2020 21:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0ezoTqrj/+A4z45ALo41WcrhsJwk+rl9/3LPswYVGXs=;
 b=bUA57CjssI2q36h5ZNWDHB+or4Z8j1hhddrsNkLIc+/GqL5sDbO657rrgw+A8hKTCqdR
 Z+YnzQUqvP84Y49NpkZiYs0UqNzRXkjFH9ic+ite0XMbyN6jCQXdc4W6CYdHLy9/9aAi
 FGH/OJSGeQtBMFEGRctGwzfqoo9LkGomJXbD9RbQx2xopgwduLDImWuSeVASxvhm1AiZ
 cHKlvdVjbDYOkvCNm5qGCurbY7sqG/XvRKA1785cFWe6m5eSG39+NtUZuRautN0FrNjq
 PuCW1GtHlDpWmg1v9sYrhfeAgnu+8j/OxfIfdeqwWZeVd11MFTO1f6fBsDhl7ao6JbtE NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 327s65yu7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 21:10:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HL8oZ2143687;
        Fri, 17 Jul 2020 21:10:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32bjd3ke26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 21:10:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06HLAu0e019324;
        Fri, 17 Jul 2020 21:10:56 GMT
Received: from localhost (/10.159.159.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 14:10:56 -0700
Date:   Fri, 17 Jul 2020 14:10:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH 1/3] xfsprogs: xfs_quota command error message improvement
Message-ID: <20200717211055.GR3151642@magnolia>
References: <20200715201253.171356-1-billodo@redhat.com>
 <20200715201253.171356-2-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715201253.171356-2-billodo@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 03:12:51PM -0500, Bill O'Donnell wrote:
> Make the error messages for rudimentary xfs_quota commands
> (off, enable, disable) more user friendly, instead of the
> terse sys error outputs.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Hmmm... where are the underlying ioctls documented, anyways?
Can we please get that done?

(Note that ENOSYS can also mean that the fs didn't register any quota
operations, but xfs always does so meh.)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  quota/state.c | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/quota/state.c b/quota/state.c
> index 8f9718f1..7a595fc6 100644
> --- a/quota/state.c
> +++ b/quota/state.c
> @@ -306,8 +306,16 @@ enable_enforcement(
>  		return;
>  	}
>  	dir = mount->fs_name;
> -	if (xfsquotactl(XFS_QUOTAON, dir, type, 0, (void *)&qflags) < 0)
> -		perror("XFS_QUOTAON");
> +	if (xfsquotactl(XFS_QUOTAON, dir, type, 0, (void *)&qflags) < 0) {
> +		if (errno == EEXIST)
> +			fprintf(stderr,
> +				_("Quota enforcement already enabled.\n"));
> +		else if (errno == EINVAL || errno == ENOSYS)
> +			fprintf(stderr,
> +				_("Can't enable enforcement when quota off.\n"));
> +		else
> +			perror("XFS_QUOTAON");
> +	}
>  	else if (flags & VERBOSE_FLAG)
>  		state_quotafile_mount(stdout, type, mount, flags);
>  }
> @@ -328,8 +336,16 @@ disable_enforcement(
>  		return;
>  	}
>  	dir = mount->fs_name;
> -	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
> -		perror("XFS_QUOTAOFF");
> +	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
> +		if (errno == EEXIST)
> +			fprintf(stderr,
> +				_("Quota enforcement already disabled.\n"));
> +		else if (errno == EINVAL || errno == ENOSYS)
> +			fprintf(stderr,
> +				_("Can't disable enforcement when quota off.\n"));
> +		else
> +			perror("XFS_QUOTAOFF");
> +	}
>  	else if (flags & VERBOSE_FLAG)
>  		state_quotafile_mount(stdout, type, mount, flags);
>  }
> @@ -350,8 +366,12 @@ quotaoff(
>  		return;
>  	}
>  	dir = mount->fs_name;
> -	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0)
> -		perror("XFS_QUOTAOFF");
> +	if (xfsquotactl(XFS_QUOTAOFF, dir, type, 0, (void *)&qflags) < 0) {
> +		if (errno == EEXIST || errno == ENOSYS)
> +			fprintf(stderr, _("Quota already off.\n"));
> +		else
> +			perror("XFS_QUOTAOFF");
> +	}
>  	else if (flags & VERBOSE_FLAG)
>  		state_quotafile_mount(stdout, type, mount, flags);
>  }
> -- 
> 2.26.2
> 
