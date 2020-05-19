Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E07C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26232207C4
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SC3U+ouU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgESQlO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 12:41:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgESQlO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 12:41:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGVUKQ023475;
        Tue, 19 May 2020 16:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aZfHdSN9s5RLJylsZ8QNJ6zP0ukTd3g1xzvsgKgrfuE=;
 b=SC3U+ouUPsTE5/FeotlFo+/YIoVD+7Lm31Io7DhlRKKR1pHCRr6wKbG6O3f2EGymYsEW
 PI6BhYvlXlkisCb8MB7pLQW09nmEzCRv+pcnVpmtRLvgF4XGLtTCfQdfn8i1b8ijgSKM
 RvuLz0hrFG0MRMTp7NsJoV13d+ukMHVQrR+FPgx25X5GGa1pIzVi/7hcELGiVUj+hHbm
 LBEjLUc2RoVY8iM+7HmsHPQCcYuFMIyZv3aMhO6gEidLqHqNlE1qcsa+geISA0dpD5Ph
 rSRFnIyTsHl8Kpn/3x2QEmCFiP61wY0JhORj6ojT5irf2gEe0mbgLUxzOfyd2LOOIWmz CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tnee7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 16:41:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGYPZJ035433;
        Tue, 19 May 2020 16:39:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gm5av8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 16:39:10 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04JGd9qq007601;
        Tue, 19 May 2020 16:39:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 09:39:09 -0700
Date:   Tue, 19 May 2020 09:39:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 6/6] xfs: allow individual quota grace period extension
Message-ID: <20200519163908.GQ17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
 <868cac51-800e-2051-1322-aa77302a65c2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868cac51-800e-2051-1322-aa77302a65c2@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 01:52:16PM -0500, Eric Sandeen wrote:
> The only grace period which can be set in the kernel today is for id 0,
> i.e. the default grace period for all users.  However, setting an
> individual grace period is useful; for example:
> 
>  Alice has a soft quota of 100 inodes, and a hard quota of 200 inodes
>  Alice uses 150 inodes, and enters a short grace period
>  Alice really needs to use those 150 inodes past the grace period
>  The administrator extends Alice's grace period until next Monday
> 
> vfs quota users such as ext4 can do this today, with setquota -T

Does setquota -T work on an XFS filesystem?  If so, does that mean that
xfs had a functionality gap where the admin could extend someone's grace
period on ext4 but trying the exact same command on xfs would do
nothing?  Or would it at least error out?

> To enable this for XFS, we simply move the timelimit assignment out
> from under the (id == 0) test.  Default setting remains under (id == 0).
> Note that this now is consistent with how we set warnings.
> 
> (Userspace requires updates to enable this as well; xfs_quota needs to
> parse new options, and setquota needs to set appropriate field flags.)

So ... xfs_quota simply never had the ability to do this, but what does
"setquota needs to set appropriate field flags" mean exactly?

--D

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c | 48 +++++++++++++++++++++++-----------------
>  1 file changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 29c1d5d4104d..94d374820c7e 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -555,32 +555,40 @@ xfs_qm_scall_setqlim(
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
> +	if (newlim->d_fieldmask & QC_SPC_TIMER)
> +		ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
> +	if (newlim->d_fieldmask & QC_INO_TIMER)
> +		ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
> +	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> +		ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
> +
> +	if (id == 0) {
> +		if (newlim->d_fieldmask & QC_SPC_TIMER)
> +			defq->btimelimit = newlim->d_spc_timer;
> +		if (newlim->d_fieldmask & QC_INO_TIMER)
> +			defq->itimelimit = newlim->d_ino_timer;
> +		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> +			defq->rtbtimelimit = newlim->d_rt_spc_timer;
> +	}
> +
> +	if (id != 0) {
>  		/*
>  		 * If the user is now over quota, start the timelimit.
>  		 * The user will not be 'warned'.
> -- 
> 2.17.0
> 
> 
