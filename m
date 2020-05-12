Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2326AC2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFE1F206F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W9AicR1o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgELX3g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 19:29:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELX3g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 19:29:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNR7K7014538;
        Tue, 12 May 2020 23:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=89Z8A0M9WAAh677l0herdgQeCfOeDA8kkSn4C9s1A+U=;
 b=W9AicR1oap5pZeIt8Qh0T71aI8toRCvkE/85Od1kl6eWeydrX0Kze4h+RxN+UVQLJSRD
 yGpqWE90TDTS9hBCed8tQguioYmaSImdtqT6C/cd9MkvBij03fj3zGC945tDiCI66iw/
 CpiN/w8N+IzigGYgzTEKE6ivNIu5vGedKpVudyP1QawdmC01zwqRR18Lc9dT/hX07iBO
 H3nrV7fo0CyEAydjX4N1emyexcCymc76oZqRNnS5HIs97/u7YUYMLf/p5Y9chomVIpQ/
 nXdHEAI+8qR+Xnz40iMwBdoh5S8FZEuMTX+FCPtCDvT4y+CD6rA7Fv1NOAgQnmc2okSw ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3100xw97jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 23:29:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNSYu8043203;
        Tue, 12 May 2020 23:29:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3100ypadw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 23:29:30 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CNTTWd001738;
        Tue, 12 May 2020 23:29:29 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 16:29:29 -0700
Date:   Tue, 12 May 2020 16:29:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] xfs: allow adjusting individual quota grace times
Message-ID: <20200512232928.GO6714@magnolia>
References: <ca1d2bb6-6f37-255c-1015-a20c6060d81c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca1d2bb6-6f37-255c-1015-a20c6060d81c@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005120174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 02:47:02PM -0500, Eric Sandeen wrote:
> vfs/ext3/4 quota allows the administrator to push out the grace time
> for soft quota with the setquota -T command:
> 
> setquota -T [ -u | -g ] [ -F quotaformat ] name block-grace inode-grace -a | filesystem...
> 
>        -T, --edit-times
>               Alter times for individual user/group when softlimit is enforced.
>               Times block-grace and inode-grace are specified in seconds or can
>               be string 'unset'.
> 
> Essentially, if you do "setquota -T -u username 1d 1d" and "username" is
> over their soft quotas and into their grace time, it will extend the
> grace time expiry to 1d from now.
> 
> xfs can't do this, today.  The patch below is a first cut at allowing us
> to do this, and userspace updates are needed as well (I have those in a
> patch stack.)
> 
> I'm not looking so much for patch review right now, though, what I'm
> wondering is if this is a change we can make from the ABI perspective?
> 
> Because today, if you try to pass in a UID other than 0 (i.e. the
> default grace period) it just gets ignored by the kernel, not rejected.
> 
> So there's no real way to know that the grace period adjustment failed
> on an older kernel.  We could consider that a bug and fix it, or
> consider it a change in behavior that we can't just make without
> at least some form of versioning.  Thoughts?
> 
> Anyway, the patch below moves the disk quota grace period adjustment out
> from "if id == 0" and allows the change for any ID; it only sets the
> default grace value in the "id == 0" case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index f48561b7e947..e58ee98f938c 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -555,32 +555,41 @@ xfs_qm_scall_setqlim(
>  		ddq->d_rtbwarns = cpu_to_be16(newlim->d_rt_spc_warns);
>  
>  	if (id == 0) {
> -		/*
> -		 * Timelimits for the super user set the relative time
> -		 * the other users can be over quota for this file system.
> -		 * If it is zero a default is used.  Ditto for the default
> -		 * soft and hard limit values (already done, above), and
> -		 * for warnings.
> -		 */
> -		if (newlim->d_fieldmask & QC_SPC_TIMER) {
> -			defq->btimelimit = newlim->d_spc_timer;
> -			ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
> -		}
> -		if (newlim->d_fieldmask & QC_INO_TIMER) {
> -			defq->itimelimit = newlim->d_ino_timer;
> -			ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
> -		}
> -		if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
> -			defq->rtbtimelimit = newlim->d_rt_spc_timer;
> -			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
> -		}
>  		if (newlim->d_fieldmask & QC_SPC_WARNS)
>  			defq->bwarnlimit = newlim->d_spc_warns;
>  		if (newlim->d_fieldmask & QC_INO_WARNS)
>  			defq->iwarnlimit = newlim->d_ino_warns;
>  		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
>  			defq->rtbwarnlimit = newlim->d_rt_spc_warns;
> -	} else {
> +	}
> +
> +	/*
> +	 * Timelimits for the super user set the relative time the other users
> +	 * can be over quota for this file system. If it is zero a default is
> +	 * used.  Ditto for the default soft and hard limit values (already
> +	 * done, above), and for warnings.
> +	 *
> +	 * For other IDs, userspace can bump out the grace period if over
> +	 * the soft limit.
> +	 */
> +	if (newlim->d_fieldmask & QC_SPC_TIMER) {
> +		if (!id)
> +			defq->btimelimit = newlim->d_spc_timer;
> +		ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
> +	}
> +	if (newlim->d_fieldmask & QC_INO_TIMER) {
> +		printk("setting inode timer to %d\n", newlim->d_ino_timer);

Stray printk here.

> +		if (!id)
> +			defq->itimelimit = newlim->d_ino_timer;
> +		ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
> +	}
> +	if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
> +		if (!id)
> +			defq->rtbtimelimit = newlim->d_rt_spc_timer;
> +		ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
> +	}

Otherwise I guess this looks reasonable.  It might help to patchbomb all
the kernel/userspace/fstests changes together so I don't have to go
scurrying around to find the pieces(?)

--D

> +
> +	if (id != 0) {
>  		/*
>  		 * If the user is now over quota, start the timelimit.
>  		 * The user will not be 'warned'.
> 
> 
