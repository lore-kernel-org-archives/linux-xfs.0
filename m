Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE00C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC5820828
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfH0MkV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 08:40:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbfH0MkV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 08:40:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E611B800DEC;
        Tue, 27 Aug 2019 12:40:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 288355D6B0;
        Tue, 27 Aug 2019 12:40:20 +0000 (UTC)
Date:   Tue, 27 Aug 2019 08:40:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 04/15] xfs: mount-api - refactor xfs_parseags()
Message-ID: <20190827124018.GC10636@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652197874.2607.4643054966916218220.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156652197874.2607.4643054966916218220.stgit@fedora-28>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Tue, 27 Aug 2019 12:40:21 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 08:59:38AM +0800, Ian Kent wrote:
> Refactor xfs_parseags(), move the entire token case block to a
> separate function in an attempt to highlight the code that
> actually changes in converting to use the new mount api.
> 
> The only changes are what's needed to communicate the variables
> dsunit, dswidth and iosizelog back to xfs_parseags().
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

Looks Ok:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c |  292 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 156 insertions(+), 136 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 49c87fb921f1..3ae29938dd89 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -198,6 +198,157 @@ match_kstrtoint(const substring_t *s, unsigned int base, int *res)
>  	return ret;
>  }
>  
> +STATIC int
> +xfs_parse_param(
> +	int 			token,
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
> +		break;
> +	case Opt_logbsize:
> +		if (match_kstrtoint(args, 10, &mp->m_logbsize))
> +			return -EINVAL;
> +		break;
> +	case Opt_logdev:
> +		kfree(mp->m_logname);
> +		mp->m_logname = match_strdup(args);
> +		if (!mp->m_logname)
> +			return -ENOMEM;
> +		break;
> +	case Opt_rtdev:
> +		kfree(mp->m_rtname);
> +		mp->m_rtname = match_strdup(args);
> +		if (!mp->m_rtname)
> +			return -ENOMEM;
> +		break;
> +	case Opt_allocsize:
> +	case Opt_biosize:
> +		if (match_kstrtoint(args, 10, &iosize))
> +			return -EINVAL;
> +		*iosizelog = ffs(iosize) - 1;
> +		break;
> +	case Opt_grpid:
> +	case Opt_bsdgroups:
> +		mp->m_flags |= XFS_MOUNT_GRPID;
> +		break;
> +	case Opt_nogrpid:
> +	case Opt_sysvgroups:
> +		mp->m_flags &= ~XFS_MOUNT_GRPID;
> +		break;
> +	case Opt_wsync:
> +		mp->m_flags |= XFS_MOUNT_WSYNC;
> +		break;
> +	case Opt_norecovery:
> +		mp->m_flags |= XFS_MOUNT_NORECOVERY;
> +		break;
> +	case Opt_noalign:
> +		mp->m_flags |= XFS_MOUNT_NOALIGN;
> +		break;
> +	case Opt_swalloc:
> +		mp->m_flags |= XFS_MOUNT_SWALLOC;
> +		break;
> +	case Opt_sunit:
> +		if (match_int(args, dsunit))
> +			return -EINVAL;
> +		break;
> +	case Opt_swidth:
> +		if (match_int(args, dswidth))
> +			return -EINVAL;
> +		break;
> +	case Opt_inode32:
> +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +		break;
> +	case Opt_inode64:
> +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +		break;
> +	case Opt_nouuid:
> +		mp->m_flags |= XFS_MOUNT_NOUUID;
> +		break;
> +	case Opt_ikeep:
> +		mp->m_flags |= XFS_MOUNT_IKEEP;
> +		break;
> +	case Opt_noikeep:
> +		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		break;
> +	case Opt_largeio:
> +		mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> +		break;
> +	case Opt_nolargeio:
> +		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +		break;
> +	case Opt_attr2:
> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> +		break;
> +	case Opt_noattr2:
> +		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> +		mp->m_flags |= XFS_MOUNT_NOATTR2;
> +		break;
> +	case Opt_filestreams:
> +		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> +		break;
> +	case Opt_noquota:
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> +		break;
> +	case Opt_quota:
> +	case Opt_uquota:
> +	case Opt_usrquota:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> +				 XFS_UQUOTA_ENFD);
> +		break;
> +	case Opt_qnoenforce:
> +	case Opt_uqnoenforce:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> +		break;
> +	case Opt_pquota:
> +	case Opt_prjquota:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> +				 XFS_PQUOTA_ENFD);
> +		break;
> +	case Opt_pqnoenforce:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> +		break;
> +	case Opt_gquota:
> +	case Opt_grpquota:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> +				 XFS_GQUOTA_ENFD);
> +		break;
> +	case Opt_gqnoenforce:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> +		break;
> +	case Opt_discard:
> +		mp->m_flags |= XFS_MOUNT_DISCARD;
> +		break;
> +	case Opt_nodiscard:
> +		mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		break;
> +#ifdef CONFIG_FS_DAX
> +	case Opt_dax:
> +		mp->m_flags |= XFS_MOUNT_DAX;
> +		break;
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
> @@ -219,7 +370,6 @@ xfs_parseargs(
>  	substring_t		args[MAX_OPT_ARGS];
>  	int			dsunit = 0;
>  	int			dswidth = 0;
> -	int			iosize = 0;
>  	uint8_t			iosizelog = 0;
>  
>  	/*
> @@ -258,146 +408,16 @@ xfs_parseargs(
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
> -		case Opt_biosize:
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
> +		ret = xfs_parse_param(token, p, args, mp,
> +				      &dsunit, &dswidth, &iosizelog);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	/*
> 
