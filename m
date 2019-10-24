Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1715ECA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D515920650
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="goPbTzwc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409736AbfJXPof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:44:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48090 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406101AbfJXPof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 11:44:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFdPCE045894;
        Thu, 24 Oct 2019 15:44:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=84fa34J8S9moehGNC8zNXqgGpSgJC6RK+Y0+GZDddYE=;
 b=goPbTzwc/mCnf02UgjFSCcjqipZ0eNAIovGZ/4DgFzwpLYaabB4mLMfR8sjO+BzFh6Zn
 COzTUYnRxRFvrNkGFgB61V6l48ZESAqk3X9fE/tSq4vn/F7kjHgERSpdccjKFIbPt4N/
 RNef7MDaeqv3lFvWHOmImBwrdZEnBhfDLtNpoYKjh5xIVWHzv2FJ8S+ca9lL6ngNl50o
 HzfDiX25+bo0KEccZmK5heV+nTbF+xB0BWAXZLzlqQk3pDJdvrllFh7I5G36o0aAx7PJ
 Je2P3vX+Wh8LAYdNHDgdEiqgOusC4vgwSO5bvOHBzDbSRhQxOlS+tVg38xjRB+AWzLpH UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vqu4r4bjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:44:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFefXU025140;
        Thu, 24 Oct 2019 15:42:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vtsk53p8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:42:02 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9OFfaa6022802;
        Thu, 24 Oct 2019 15:41:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 15:41:36 +0000
Date:   Thu, 24 Oct 2019 08:41:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 13/17] xfs: refactor xfs_parseags()
Message-ID: <20191024154135.GW913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190350372.27074.1238120877796190411.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190350372.27074.1238120877796190411.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:43PM +0800, Ian Kent wrote:
> Refactor xfs_parseags(), move the entire token case block to a separate
> function in an attempt to highlight the code that actually changes in
> converting to use the new mount api.
> 
> The only changes are what's needed to communicate the variables dsunit,
> dswidth and iosizelog back to xfs_parseags().
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |  290 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 155 insertions(+), 135 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 92a37ac0b907..de0ab79536b3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -164,6 +164,156 @@ match_kstrtoint(
>  	return ret;
>  }
>  
> +static int
> +xfs_fc_parse_param(
> +	int			token,
> +	char			*p,
> +	substring_t		*args,
> +	struct xfs_mount	*mp,
> +	int			*dsunit,
> +	int			*dswidth,
> +	uint8_t			*iosizelog)
> +{
> +	int			iosize = 0;
> +
> +	switch (token) {
> +	case Opt_logbufs:
> +		if (match_int(args, &mp->m_logbufs))
> +			return -EINVAL;
> +		return 0;
> +	case Opt_logbsize:
> +		if (match_kstrtoint(args, 10, &mp->m_logbsize))
> +			return -EINVAL;
> +		return 0;
> +	case Opt_logdev:
> +		kfree(mp->m_logname);
> +		mp->m_logname = match_strdup(args);
> +		if (!mp->m_logname)
> +			return -ENOMEM;
> +		return 0;
> +	case Opt_rtdev:
> +		kfree(mp->m_rtname);
> +		mp->m_rtname = match_strdup(args);
> +		if (!mp->m_rtname)
> +			return -ENOMEM;
> +		return 0;
> +	case Opt_allocsize:
> +		if (match_kstrtoint(args, 10, &iosize))
> +			return -EINVAL;
> +		*iosizelog = ffs(iosize) - 1;
> +		return 0;
> +	case Opt_grpid:
> +	case Opt_bsdgroups:
> +		mp->m_flags |= XFS_MOUNT_GRPID;
> +		return 0;
> +	case Opt_nogrpid:
> +	case Opt_sysvgroups:
> +		mp->m_flags &= ~XFS_MOUNT_GRPID;
> +		return 0;
> +	case Opt_wsync:
> +		mp->m_flags |= XFS_MOUNT_WSYNC;
> +		return 0;
> +	case Opt_norecovery:
> +		mp->m_flags |= XFS_MOUNT_NORECOVERY;
> +		return 0;
> +	case Opt_noalign:
> +		mp->m_flags |= XFS_MOUNT_NOALIGN;
> +		return 0;
> +	case Opt_swalloc:
> +		mp->m_flags |= XFS_MOUNT_SWALLOC;
> +		return 0;
> +	case Opt_sunit:
> +		if (match_int(args, dsunit))
> +			return -EINVAL;
> +		return 0;
> +	case Opt_swidth:
> +		if (match_int(args, dswidth))
> +			return -EINVAL;
> +		return 0;
> +	case Opt_inode32:
> +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +		return 0;
> +	case Opt_inode64:
> +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +		return 0;
> +	case Opt_nouuid:
> +		mp->m_flags |= XFS_MOUNT_NOUUID;
> +		return 0;
> +	case Opt_ikeep:
> +		mp->m_flags |= XFS_MOUNT_IKEEP;
> +		return 0;
> +	case Opt_noikeep:
> +		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		return 0;
> +	case Opt_largeio:
> +		mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> +		return 0;
> +	case Opt_nolargeio:
> +		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +		return 0;
> +	case Opt_attr2:
> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> +		return 0;
> +	case Opt_noattr2:
> +		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> +		mp->m_flags |= XFS_MOUNT_NOATTR2;
> +		return 0;
> +	case Opt_filestreams:
> +		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> +		return 0;
> +	case Opt_noquota:
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> +		return 0;
> +	case Opt_quota:
> +	case Opt_uquota:
> +	case Opt_usrquota:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> +				 XFS_UQUOTA_ENFD);
> +		return 0;
> +	case Opt_qnoenforce:
> +	case Opt_uqnoenforce:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> +		return 0;
> +	case Opt_pquota:
> +	case Opt_prjquota:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> +				 XFS_PQUOTA_ENFD);
> +		return 0;
> +	case Opt_pqnoenforce:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> +		return 0;
> +	case Opt_gquota:
> +	case Opt_grpquota:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> +				 XFS_GQUOTA_ENFD);
> +		return 0;
> +	case Opt_gqnoenforce:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> +		return 0;
> +	case Opt_discard:
> +		mp->m_flags |= XFS_MOUNT_DISCARD;
> +		return 0;
> +	case Opt_nodiscard:
> +		mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		return 0;
> +#ifdef CONFIG_FS_DAX
> +	case Opt_dax:
> +		mp->m_flags |= XFS_MOUNT_DAX;
> +		return 0;
> +#endif
> +	default:
> +		xfs_warn(mp, "unknown mount option [%s].", p);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * This function fills in xfs_mount_t fields based on mount args.
>   * Note: the superblock has _not_ yet been read in.
> @@ -185,7 +335,6 @@ xfs_parseargs(
>  	substring_t		args[MAX_OPT_ARGS];
>  	int			dsunit = 0;
>  	int			dswidth = 0;
> -	int			iosize = 0;
>  	uint8_t			iosizelog = 0;
>  
>  	/*
> @@ -215,145 +364,16 @@ xfs_parseargs(
>  
>  	while ((p = strsep(&options, ",")) != NULL) {
>  		int		token;
> +		int		ret;
>  
>  		if (!*p)
>  			continue;
>  
>  		token = match_token(p, tokens, args);
> -		switch (token) {
> -		case Opt_logbufs:
> -			if (match_int(args, &mp->m_logbufs))
> -				return -EINVAL;
> -			break;
> -		case Opt_logbsize:
> -			if (match_kstrtoint(args, 10, &mp->m_logbsize))
> -				return -EINVAL;
> -			break;
> -		case Opt_logdev:
> -			kfree(mp->m_logname);
> -			mp->m_logname = match_strdup(args);
> -			if (!mp->m_logname)
> -				return -ENOMEM;
> -			break;
> -		case Opt_rtdev:
> -			kfree(mp->m_rtname);
> -			mp->m_rtname = match_strdup(args);
> -			if (!mp->m_rtname)
> -				return -ENOMEM;
> -			break;
> -		case Opt_allocsize:
> -			if (match_kstrtoint(args, 10, &iosize))
> -				return -EINVAL;
> -			iosizelog = ffs(iosize) - 1;
> -			break;
> -		case Opt_grpid:
> -		case Opt_bsdgroups:
> -			mp->m_flags |= XFS_MOUNT_GRPID;
> -			break;
> -		case Opt_nogrpid:
> -		case Opt_sysvgroups:
> -			mp->m_flags &= ~XFS_MOUNT_GRPID;
> -			break;
> -		case Opt_wsync:
> -			mp->m_flags |= XFS_MOUNT_WSYNC;
> -			break;
> -		case Opt_norecovery:
> -			mp->m_flags |= XFS_MOUNT_NORECOVERY;
> -			break;
> -		case Opt_noalign:
> -			mp->m_flags |= XFS_MOUNT_NOALIGN;
> -			break;
> -		case Opt_swalloc:
> -			mp->m_flags |= XFS_MOUNT_SWALLOC;
> -			break;
> -		case Opt_sunit:
> -			if (match_int(args, &dsunit))
> -				return -EINVAL;
> -			break;
> -		case Opt_swidth:
> -			if (match_int(args, &dswidth))
> -				return -EINVAL;
> -			break;
> -		case Opt_inode32:
> -			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> -			break;
> -		case Opt_inode64:
> -			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> -			break;
> -		case Opt_nouuid:
> -			mp->m_flags |= XFS_MOUNT_NOUUID;
> -			break;
> -		case Opt_ikeep:
> -			mp->m_flags |= XFS_MOUNT_IKEEP;
> -			break;
> -		case Opt_noikeep:
> -			mp->m_flags &= ~XFS_MOUNT_IKEEP;
> -			break;
> -		case Opt_largeio:
> -			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> -			break;
> -		case Opt_nolargeio:
> -			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> -			break;
> -		case Opt_attr2:
> -			mp->m_flags |= XFS_MOUNT_ATTR2;
> -			break;
> -		case Opt_noattr2:
> -			mp->m_flags &= ~XFS_MOUNT_ATTR2;
> -			mp->m_flags |= XFS_MOUNT_NOATTR2;
> -			break;
> -		case Opt_filestreams:
> -			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> -			break;
> -		case Opt_noquota:
> -			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> -			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> -			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> -			break;
> -		case Opt_quota:
> -		case Opt_uquota:
> -		case Opt_usrquota:
> -			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> -					 XFS_UQUOTA_ENFD);
> -			break;
> -		case Opt_qnoenforce:
> -		case Opt_uqnoenforce:
> -			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> -			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> -			break;
> -		case Opt_pquota:
> -		case Opt_prjquota:
> -			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> -					 XFS_PQUOTA_ENFD);
> -			break;
> -		case Opt_pqnoenforce:
> -			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> -			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> -			break;
> -		case Opt_gquota:
> -		case Opt_grpquota:
> -			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> -					 XFS_GQUOTA_ENFD);
> -			break;
> -		case Opt_gqnoenforce:
> -			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> -			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> -			break;
> -		case Opt_discard:
> -			mp->m_flags |= XFS_MOUNT_DISCARD;
> -			break;
> -		case Opt_nodiscard:
> -			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> -			break;
> -#ifdef CONFIG_FS_DAX
> -		case Opt_dax:
> -			mp->m_flags |= XFS_MOUNT_DAX;
> -			break;
> -#endif
> -		default:
> -			xfs_warn(mp, "unknown mount option [%s].", p);
> -			return -EINVAL;
> -		}
> +		ret = xfs_fc_parse_param(token, p, args, mp, &dsunit, &dswidth,
> +					 &iosizelog);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	/*
> 
