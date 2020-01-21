Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F4FC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C16702465A
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fVOLDSSm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAUS4s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:56:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUS4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:56:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImeOO009238;
        Tue, 21 Jan 2020 18:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=JwmugQQVYWL11CQ6COzAOlzVcn8LHUYt2fsFcsZuswI=;
 b=fVOLDSSmSxqK6HRjU4P+4KVBmYGVYEs1LuhYFFfEPoeo689Damy43Q59euEFXNL5QpT2
 +OjAx0Avz9HMxKwlzDfZUf3jQ2BGOShOcigtn0zpWDy8RKEg0M3YlIJMVP0O8sjtVeQs
 WHTEmty+eRFTUPBzFBCV56Cdi7OS0M4bvcP5E5EHvmff+U8SFXTMjo/p07OtsOoL83X6
 HcXW2o4+Rq7I4vEfwgJiGhgmM1MlZFzsl2BGZzQpNVvteP2I8ouk4nqI9J565snaC1vb
 lmGwhqI0EQyXnkIy/TCUoRvjST1TOf9DUWnw7STkImDW9SWkgwURXkuNK9TkdrIzx6a1 DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnr6y7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:56:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImm2U139907;
        Tue, 21 Jan 2020 18:56:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xnpeffkbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:56:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIuhX9014966;
        Tue, 21 Jan 2020 18:56:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:56:43 -0800
Date:   Tue, 21 Jan 2020 10:56:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 25/29] xfs: improve xfs_forget_acl
Message-ID: <20200121185641.GZ8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-26-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-26-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:47AM +0100, Christoph Hellwig wrote:
> Move the function to xfs_acl.c and provide a proper stub for the
> !CONFIG_XFS_POSIX_ACL case.  Lift the flags check to the caller as it
> nicely fits in there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_acl.c   | 16 ++++++++++++++++
>  fs/xfs/xfs_acl.h   |  4 ++--
>  fs/xfs/xfs_ioctl.c |  4 ++--
>  fs/xfs/xfs_xattr.c | 26 ++------------------------
>  4 files changed, 22 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 89f076e2ed7d..c993ffd9b767 100644
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

Hm, won't that make gcc cough up "warning: statement with no effect"
warnings when posix acls are disabled?

I think the way we usually do this is to define it to ((void) 0)...

--D

>  #endif /* CONFIG_XFS_POSIX_ACL */
>  
> -extern void xfs_forget_acl(struct inode *inode, const char *name, int xflags);
> -
>  #endif	/* __XFS_ACL_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 899a3b41fa91..7a1ff66b4786 100644
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
> +		xfs_forget_acl(inode, name);
>  	return error;
>  }
>  
> -- 
> 2.24.1
> 
