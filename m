Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F18C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 21:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84DF520717
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 21:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MZSAJWOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgGQVNx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:13:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54366 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQVNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jul 2020 17:13:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HLBdLv036944;
        Fri, 17 Jul 2020 21:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=E1AyqijCirj1Rsfwf0LsssmMgcrabsMYJJspjDbCx9E=;
 b=MZSAJWOxdfDejzrqWeDT/q7gGeQLT0CsFb+5ZNn6dKAw4Pd/S21CYenasU8lvtAWFtdr
 7WKx6ZUIjhzoektaVOKn0u/30TjvFvAIn0z+GFip79cCJpmuLZWnR2LdChJAVxW+VAB9
 j4GXwW05RjHTf44EPqOv0OcjKLjj1TCd0bzik+Z7qUEUgXktHg/e5CLBri8wOWGizGSi
 MYuOjXjfz3MLVOjSooi3RvpJgZ+1vilLQuF8a9c0adSq6SsTY+M5u/HBSonecB33xjQL
 1xTpMeQTcbOET4TMWvjSYychjjMkcTzAlsh9qLj8ZYS3AiBrpZL/HNldxwtkLvpfQWhk DQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cmsgvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Jul 2020 21:13:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06HLDmC7043854;
        Fri, 17 Jul 2020 21:13:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32bj7guyby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 21:13:48 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06HLDlvp007151;
        Fri, 17 Jul 2020 21:13:47 GMT
Received: from localhost (/10.159.159.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 14:13:46 -0700
Date:   Fri, 17 Jul 2020 14:13:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH v2 3/3] xfsprogs: xfs_quota state command should report
 ugp grace times
Message-ID: <20200717211345.GS3151642@magnolia>
References: <20200715201253.171356-4-billodo@redhat.com>
 <20200717204314.309873-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717204314.309873-1-billodo@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 17, 2020 at 03:43:14PM -0500, Bill O'Donnell wrote:
> Since grace periods are now supported for three quota types (ugp),
> modify xfs_quota state command to report times for all three.
> Add a helper function for stat reporting.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
> v2: load-up helper function more, further reducing redundant LoC
> 
>  quota/state.c | 96 +++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 67 insertions(+), 29 deletions(-)
> 
> diff --git a/quota/state.c b/quota/state.c
> index 1627181d..19d34ed0 100644
> --- a/quota/state.c
> +++ b/quota/state.c
> @@ -191,49 +191,87 @@ state_stat_to_statv(
>  }
>  
>  static void
> -state_quotafile_mount(
> +state_quotafile_stat(
>  	FILE			*fp,
>  	uint			type,
> -	struct fs_path		*mount,
> +	struct fs_path          *mount,
> +	struct fs_quota_statv	*sv,
> +	struct fs_quota_stat	*s,
>  	uint			flags)
>  {
> -	struct fs_quota_stat	s;
> -	struct fs_quota_statv	sv;
> +	bool			accounting, enforcing;
> +	struct fs_qfilestatv	*qsv;
>  	char			*dev = mount->fs_name;
>  
> -	sv.qs_version = FS_QSTATV_VERSION1;
> -
> -	if (xfsquotactl(XFS_GETQSTATV, dev, type, 0, (void *)&sv) < 0) {
> -		if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)&s) < 0) {
> +	if (xfsquotactl(XFS_GETQSTATV, dev, type, 0, (void *)sv) < 0) {

At some point I'd love to refactor all these ioctl-like xfsquotactl
calls into a set of real functions with type checking and whatnot, but
this looks fine to me on its own:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +		if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)s) < 0) {
>  			if (flags & VERBOSE_FLAG)
>  				fprintf(fp,
>  					_("%s quota are not enabled on %s\n"),
>  					type_to_string(type), dev);
>  			return;
>  		}
> -		state_stat_to_statv(&s, &sv);
> +		state_stat_to_statv(s, sv);
> +	}
> +
> +	switch(type) {
> +	case XFS_USER_QUOTA:
> +		qsv = &sv->qs_uquota;
> +		accounting = sv->qs_flags & XFS_QUOTA_UDQ_ACCT;
> +		enforcing = sv->qs_flags & XFS_QUOTA_UDQ_ENFD;
> +		break;
> +	case XFS_GROUP_QUOTA:
> +		qsv = &sv->qs_gquota;
> +		accounting = sv->qs_flags & XFS_QUOTA_GDQ_ACCT;
> +		enforcing = sv->qs_flags & XFS_QUOTA_GDQ_ENFD;
> +		break;
> +	case XFS_PROJ_QUOTA:
> +		qsv = &sv->qs_pquota;
> +		accounting = sv->qs_flags & XFS_QUOTA_PDQ_ACCT;
> +		enforcing = sv->qs_flags & XFS_QUOTA_PDQ_ENFD;
> +		break;
> +	default:
> +		return;
>  	}
>  
> -	if (type & XFS_USER_QUOTA)
> -		state_qfilestat(fp, mount, XFS_USER_QUOTA, &sv.qs_uquota,
> -				sv.qs_flags & XFS_QUOTA_UDQ_ACCT,
> -				sv.qs_flags & XFS_QUOTA_UDQ_ENFD);
> -	if (type & XFS_GROUP_QUOTA)
> -		state_qfilestat(fp, mount, XFS_GROUP_QUOTA, &sv.qs_gquota,
> -				sv.qs_flags & XFS_QUOTA_GDQ_ACCT,
> -				sv.qs_flags & XFS_QUOTA_GDQ_ENFD);
> -	if (type & XFS_PROJ_QUOTA)
> -		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, &sv.qs_pquota,
> -				sv.qs_flags & XFS_QUOTA_PDQ_ACCT,
> -				sv.qs_flags & XFS_QUOTA_PDQ_ENFD);
> -
> -	state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
> -	state_warnlimit(fp, XFS_BLOCK_QUOTA, sv.qs_bwarnlimit);
> -
> -	state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
> -	state_warnlimit(fp, XFS_INODE_QUOTA, sv.qs_iwarnlimit);
> -
> -	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
> +
> +	state_qfilestat(fp, mount, type, qsv, accounting, enforcing);
> +
> +	state_timelimit(fp, XFS_BLOCK_QUOTA, sv->qs_btimelimit);
> +	state_warnlimit(fp, XFS_BLOCK_QUOTA, sv->qs_bwarnlimit);
> +
> +	state_timelimit(fp, XFS_INODE_QUOTA, sv->qs_itimelimit);
> +	state_warnlimit(fp, XFS_INODE_QUOTA, sv->qs_iwarnlimit);
> +
> +	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbtimelimit);
> +}
> +
> +static void
> +state_quotafile_mount(
> +	FILE			*fp,
> +	uint			type,
> +	struct fs_path		*mount,
> +	uint			flags)
> +{
> +	struct fs_quota_stat	s;
> +	struct fs_quota_statv	sv;
> +
> +	sv.qs_version = FS_QSTATV_VERSION1;
> +
> +	if (type & XFS_USER_QUOTA) {
> +		state_quotafile_stat(fp, XFS_USER_QUOTA, mount,
> +				     &sv, &s, flags);
> +	}
> +
> +	if (type & XFS_GROUP_QUOTA) {
> +		state_quotafile_stat(fp, XFS_GROUP_QUOTA, mount,
> +				     &sv, &s, flags);
> +	}
> +
> +	if (type & XFS_PROJ_QUOTA) {
> +		state_quotafile_stat(fp, XFS_PROJ_QUOTA, mount,
> +				     &sv, &s, flags);
> +	}
>  }
>  
>  static void
> -- 
> 2.26.2
> 
