Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F331BC352A4
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 06:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B3120708
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 06:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgBJGmz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 01:42:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726118AbgBJGmz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Feb 2020 01:42:55 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01A6YPSB115630
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 01:42:54 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y1ufk0tm4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 01:42:54 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 10 Feb 2020 06:42:52 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 06:42:48 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01A6frcF45482410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 06:41:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FDB942041;
        Mon, 10 Feb 2020 06:42:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C808C4203F;
        Mon, 10 Feb 2020 06:42:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.35.21])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 06:42:46 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 26/30] xfs: improve xfs_forget_acl
Date:   Mon, 10 Feb 2020 12:15:34 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-27-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-27-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20021006-0012-0000-0000-0000038562C3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021006-0013-0000-0000-000021C1D8AF
Message-Id: <21965604.HEa247YntI@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_01:2020-02-07,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 spamscore=0 lowpriorityscore=0 suspectscore=1
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100055
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:33 PM Christoph Hellwig wrote: 
> Move the function to xfs_acl.c and provide a proper stub for the
> !CONFIG_XFS_POSIX_ACL case.  Lift the flags check to the caller as it
> nicely fits in there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_acl.c   | 16 ++++++++++++++++
>  fs/xfs/xfs_acl.h   |  4 ++--
>  fs/xfs/xfs_ioctl.c |  4 ++--
>  fs/xfs/xfs_xattr.c | 26 ++------------------------
>  4 files changed, 22 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index bc78b7c33401..e9a48d718c3a 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -264,3 +264,19 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> 
>  	return error;
>  }
> +
> +/*
> + * Invalidate any cached ACLs if the user has bypassed the ACL interface.
> + * We don't validate the content whatsoever so it is caller responsibility to
> + * provide data in valid format and ensure i_mode is consistent.
> + */
> +void
> +xfs_forget_acl(
> +	struct inode		*inode,
> +	const char		*name)
> +{
> +	if (!strcmp(name, SGI_ACL_FILE))
> +		forget_cached_acl(inode, ACL_TYPE_ACCESS);
> +	else if (!strcmp(name, SGI_ACL_DEFAULT))
> +		forget_cached_acl(inode, ACL_TYPE_DEFAULT);
> +}
> diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> index 94615e34bc86..bd8a306046a9 100644
> --- a/fs/xfs/xfs_acl.h
> +++ b/fs/xfs/xfs_acl.h
> @@ -13,14 +13,14 @@ struct posix_acl;
>  extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
>  extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  extern int __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
> +void xfs_forget_acl(struct inode *inode, const char *name);
>  #else
>  static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
>  {
>  	return NULL;
>  }
>  # define xfs_set_acl					NULL
> +# define xfs_forget_acl(inode, name)			0
>  #endif /* CONFIG_XFS_POSIX_ACL */
> 
> -extern void xfs_forget_acl(struct inode *inode, const char *name, int xflags);
> -
>  #endif	/* __XFS_ACL_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5d160e82778e..4f26c3962215 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -509,8 +509,8 @@ xfs_attrmulti_attr_set(
>  	}
> 
>  	error = xfs_attr_set(&args);
> -	if (!error)
> -		xfs_forget_acl(inode, name, flags);
> +	if (!error && (flags & ATTR_ROOT))
> +		xfs_forget_acl(inode, name);
>  	kfree(args.value);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index e1951d2b878e..863e9fdec162 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -37,28 +37,6 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  	return args.valuelen;
>  }
> 
> -void
> -xfs_forget_acl(
> -	struct inode		*inode,
> -	const char		*name,
> -	int			xflags)
> -{
> -	/*
> -	 * Invalidate any cached ACLs if the user has bypassed the ACL
> -	 * interface. We don't validate the content whatsoever so it is caller
> -	 * responsibility to provide data in valid format and ensure i_mode is
> -	 * consistent.
> -	 */
> -	if (xflags & ATTR_ROOT) {
> -#ifdef CONFIG_XFS_POSIX_ACL
> -		if (!strcmp(name, SGI_ACL_FILE))
> -			forget_cached_acl(inode, ACL_TYPE_ACCESS);
> -		else if (!strcmp(name, SGI_ACL_DEFAULT))
> -			forget_cached_acl(inode, ACL_TYPE_DEFAULT);
> -#endif
> -	}
> -}
> -
>  static int
>  xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  		struct inode *inode, const char *name, const void *value,
> @@ -81,8 +59,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  		args.flags |= ATTR_REPLACE;
> 
>  	error = xfs_attr_set(&args);
> -	if (!error)
> -		xfs_forget_acl(inode, name, args.flags);
> +	if (!error && (flags & ATTR_ROOT))

ATTR_ROOT should be checked against args.flags.

'flags' refers to argument passed to setxattr() syscall i.e. it can have
XATTR_CREATE or XATTR_REPLACE as its value.

The remaining changes look good to me,

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>


> +		xfs_forget_acl(inode, name);
>  	return error;
>  }
> 
> 

-- 
chandan



