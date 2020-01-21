Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED971C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACB1720678
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gkOzr0aK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgAUSlt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:41:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58594 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbgAUSlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:41:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISBJH186858;
        Tue, 21 Jan 2020 18:41:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=S9A0s4PPR8FIgTJN0sxV0oIkhoMJzUdaqZX0qNGFf4Y=;
 b=gkOzr0aKyD3wvBhapdKAWDRsaxAXajouuPZP783SXkzgw0mOlt07K9ZIixTTjWiCy3gj
 nSByIRiDY6jQfVeE/9RMXZho6NSc7zFXuBoLE3jSH7XrEOBoOOme7s9R5wUFzxDVtKwM
 yPZfBK7A+WjMKLEu4YnhEOFqEG6vuYRJCJn/CM9ON66lgWylQxb8OPRDHFOZkZmFDaqE
 p2x4ukubUyjF/EupTfkx3iULuECw65c/yXcI4nFbCAclskpdDSIhycDay7tk5Qpo19tn
 KAHxKekcRLwTG07HppT4VVut0wGqdaJbY4pKX0yVhVTyGinHaDHkJfkDsbo5YnC8GuD5 EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnr6vj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:41:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISxC0086699;
        Tue, 21 Jan 2020 18:41:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xnpefda1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:41:43 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIfgS5031971;
        Tue, 21 Jan 2020 18:41:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:41:42 -0800
Date:   Tue, 21 Jan 2020 10:41:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 20/29] xfs: move the legacy xfs_attr_list to xfs_ioctl.c
Message-ID: <20200121184140.GT8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-21-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-21-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:42AM +0100, Christoph Hellwig wrote:
> The old xfs_attr_list code is only used by the attrlist by handle
> ioctl.  Move it to xfs_ioctl.c with its user.  Also move the
> attrlist and attrlist_ent structure to xfs_fs.h, as they are exposed
> user ABIs.

They weren't there already? Gross....

> They are used through libattr headers with the same name
> by at least xfsdump.  Also document this relation so that it doesn't
> require a research project to figure out.

Shouldn't these two structures get a check in xfs_ondisk.h to make sure
that we don't accidentally break the structure size?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.h |  23 --------
>  fs/xfs/libxfs/xfs_fs.h   |  26 +++++++++
>  fs/xfs/xfs_attr_list.c   | 115 ---------------------------------------
>  fs/xfs/xfs_ioctl.c       | 112 +++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_ioctl.h       |  12 ++--
>  fs/xfs/xfs_ioctl32.c     |   4 +-
>  6 files changed, 146 insertions(+), 146 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 31c0ffde4f59..0e3c213f78ce 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -48,27 +48,6 @@ struct xfs_attr_list_context;
>   */
>  #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
>  
> -/*
> - * Define how lists of attribute names are returned to the user from
> - * the attr_list() call.  A large, 32bit aligned, buffer is passed in
> - * along with its size.  We put an array of offsets at the top that each
> - * reference an attrlist_ent_t and pack the attrlist_ent_t's at the bottom.
> - */
> -typedef struct attrlist {
> -	__s32	al_count;	/* number of entries in attrlist */
> -	__s32	al_more;	/* T/F: more attrs (do call again) */
> -	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
> -} attrlist_t;
> -
> -/*
> - * Show the interesting info about one attribute.  This is what the
> - * al_offset[i] entry points to.
> - */
> -typedef struct attrlist_ent {	/* data from attr_list() */
> -	__u32	a_valuelen;	/* number bytes in value of attr */
> -	char	a_name[1];	/* attr name (NULL terminated) */
> -} attrlist_ent_t;
> -
>  /*
>   * Kernel-internal version of the attrlist cursor.
>   */
> @@ -131,8 +110,6 @@ int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> -int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
> -		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index ef95ca07d084..2c2b6e2b58f4 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -572,6 +572,32 @@ typedef struct xfs_attrlist_cursor {
>  	__u32		opaque[4];
>  } xfs_attrlist_cursor_t;
>  
> +/*
> + * Define how lists of attribute names are returned to the user from
> + * the attr_list() call.  A large, 32bit aligned, buffer is passed in
> + * along with its size.  We put an array of offsets at the top that each
> + * reference an attrlist_ent_t and pack the attrlist_ent_t's at the bottom.
> + *
> + * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr.
> + */
> +struct xfs_attrlist {
> +	__s32	al_count;	/* number of entries in attrlist */
> +	__s32	al_more;	/* T/F: more attrs (do call again) */
> +	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
> +};
> +
> +/*
> + * Show the interesting info about one attribute.  This is what the
> + * al_offset[i] entry points to.
> + *
> + * NOTE: struct xfs_attrlist_ent must match struct attrlist_ent defined in
> + * libattr.
> + */
> +struct xfs_attrlist_ent {	/* data from attr_list() */
> +	__u32	a_valuelen;	/* number bytes in value of attr */
> +	char	a_name[1];	/* attr name (NULL terminated) */
> +};
> +
>  typedef struct xfs_fsop_attrlist_handlereq {
>  	struct xfs_fsop_handlereq	hreq; /* handle interface structure */
>  	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 7f08e417d131..369ce1d3dd45 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -544,118 +544,3 @@ xfs_attr_list_int(
>  	xfs_iunlock(dp, lock_mode);
>  	return error;
>  }
> -
> -#define	ATTR_ENTSIZE(namelen)		/* actual bytes used by an attr */ \
> -	((offsetof(struct attrlist_ent, a_name) + \
> -	 (namelen) + 1 + sizeof(uint32_t) - 1) \
> -	 & ~(sizeof(uint32_t)-1))
> -
> -/*
> - * Format an attribute and copy it out to the user's buffer.
> - * Take care to check values and protect against them changing later,
> - * we may be reading them directly out of a user buffer.
> - */
> -STATIC void
> -xfs_attr_put_listent(
> -	struct xfs_attr_list_context	*context,
> -	int			flags,
> -	unsigned char		*name,
> -	int			namelen,
> -	int			valuelen)
> -{
> -	struct attrlist		*alist = context->buffer;
> -	struct attrlist_ent	*aep;
> -	int			arraytop;
> -
> -	ASSERT(!context->seen_enough);
> -	ASSERT(context->count >= 0);
> -	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
> -	ASSERT(context->firstu >= sizeof(*alist));
> -	ASSERT(context->firstu <= context->bufsize);
> -
> -	/*
> -	 * Only list entries in the right namespace.
> -	 */
> -	if (((context->flags & ATTR_SECURE) == 0) !=
> -	    ((flags & XFS_ATTR_SECURE) == 0))
> -		return;
> -	if (((context->flags & ATTR_ROOT) == 0) !=
> -	    ((flags & XFS_ATTR_ROOT) == 0))
> -		return;
> -
> -	arraytop = sizeof(*alist) +
> -			context->count * sizeof(alist->al_offset[0]);
> -	context->firstu -= ATTR_ENTSIZE(namelen);
> -	if (context->firstu < arraytop) {
> -		trace_xfs_attr_list_full(context);
> -		alist->al_more = 1;
> -		context->seen_enough = 1;
> -		return;
> -	}
> -
> -	aep = context->buffer + context->firstu;
> -	aep->a_valuelen = valuelen;
> -	memcpy(aep->a_name, name, namelen);
> -	aep->a_name[namelen] = 0;
> -	alist->al_offset[context->count++] = context->firstu;
> -	alist->al_count = context->count;
> -	trace_xfs_attr_list_add(context);
> -	return;
> -}
> -
> -/*
> - * Generate a list of extended attribute names and optionally
> - * also value lengths.  Positive return value follows the XFS
> - * convention of being an error, zero or negative return code
> - * is the length of the buffer returned (negated), indicating
> - * success.
> - */
> -int
> -xfs_attr_list(
> -	struct xfs_inode		*dp,
> -	char				*buffer,
> -	int				bufsize,
> -	int				flags,
> -	struct attrlist_cursor_kern	*cursor)
> -{
> -	struct xfs_attr_list_context	context;
> -	struct attrlist			*alist;
> -	int				error;
> -
> -	/*
> -	 * Validate the cursor.
> -	 */
> -	if (cursor->pad1 || cursor->pad2)
> -		return -EINVAL;
> -	if ((cursor->initted == 0) &&
> -	    (cursor->hashval || cursor->blkno || cursor->offset))
> -		return -EINVAL;
> -
> -	/*
> -	 * Check for a properly aligned buffer.
> -	 */
> -	if (((long)buffer) & (sizeof(int)-1))
> -		return -EFAULT;
> -
> -	/*
> -	 * Initialize the output buffer.
> -	 */
> -	memset(&context, 0, sizeof(context));
> -	context.dp = dp;
> -	context.cursor = cursor;
> -	context.resynch = 1;
> -	context.flags = flags;
> -	context.buffer = buffer;
> -	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
> -	context.firstu = context.bufsize;
> -	context.put_listent = xfs_attr_put_listent;
> -
> -	alist = context.buffer;
> -	alist->al_count = 0;
> -	alist->al_more = 0;
> -	alist->al_offset[0] = context.bufsize;
> -
> -	error = xfs_attr_list_int(&context);
> -	ASSERT(error <= 0);
> -	return error;
> -}
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 9306cefa9e61..2e64dae3743f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -35,6 +35,7 @@
>  #include "xfs_health.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ioctl.h"
> +#include "xfs_da_format.h"
>  
>  #include <linux/mount.h>
>  #include <linux/namei.h>
> @@ -292,6 +293,113 @@ xfs_readlink_by_handle(
>  	return error;
>  }
>  
> +#define	ATTR_ENTSIZE(namelen)		/* actual bytes used by an attr */ \
> +	((offsetof(struct xfs_attrlist_ent, a_name) + \
> +	 (namelen) + 1 + sizeof(uint32_t) - 1) \
> +	 & ~(sizeof(uint32_t)-1))
> +
> +/*
> + * Format an attribute and copy it out to the user's buffer.
> + * Take care to check values and protect against them changing later,
> + * we may be reading them directly out of a user buffer.
> + */
> +static void
> +xfs_ioc_attr_put_listent(
> +	struct xfs_attr_list_context *context,
> +	int			flags,
> +	unsigned char		*name,
> +	int			namelen,
> +	int			valuelen)
> +{
> +	struct xfs_attrlist	*alist = context->buffer;
> +	struct xfs_attrlist_ent	*aep;
> +	int			arraytop;
> +
> +	ASSERT(!context->seen_enough);
> +	ASSERT(context->count >= 0);
> +	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
> +	ASSERT(context->firstu >= sizeof(*alist));
> +	ASSERT(context->firstu <= context->bufsize);
> +
> +	/*
> +	 * Only list entries in the right namespace.
> +	 */
> +	if (((context->flags & ATTR_SECURE) == 0) !=
> +	    ((flags & XFS_ATTR_SECURE) == 0))
> +		return;
> +	if (((context->flags & ATTR_ROOT) == 0) !=
> +	    ((flags & XFS_ATTR_ROOT) == 0))
> +		return;
> +
> +	arraytop = sizeof(*alist) +
> +			context->count * sizeof(alist->al_offset[0]);
> +	context->firstu -= ATTR_ENTSIZE(namelen);
> +	if (context->firstu < arraytop) {
> +		trace_xfs_attr_list_full(context);
> +		alist->al_more = 1;
> +		context->seen_enough = 1;
> +		return;
> +	}
> +
> +	aep = context->buffer + context->firstu;
> +	aep->a_valuelen = valuelen;
> +	memcpy(aep->a_name, name, namelen);
> +	aep->a_name[namelen] = 0;
> +	alist->al_offset[context->count++] = context->firstu;
> +	alist->al_count = context->count;
> +	trace_xfs_attr_list_add(context);
> +}
> +
> +int
> +xfs_ioc_attr_list(
> +	struct xfs_inode		*dp,
> +	char				*buffer,
> +	int				bufsize,
> +	int				flags,
> +	struct attrlist_cursor_kern	*cursor)
> +{
> +	struct xfs_attr_list_context	context;
> +	struct xfs_attrlist		*alist;
> +	int				error;
> +
> +	/*
> +	 * Validate the cursor.
> +	 */
> +	if (cursor->pad1 || cursor->pad2)
> +		return -EINVAL;
> +	if ((cursor->initted == 0) &&
> +	    (cursor->hashval || cursor->blkno || cursor->offset))
> +		return -EINVAL;
> +
> +	/*
> +	 * Check for a properly aligned buffer.
> +	 */
> +	if (((long)buffer) & (sizeof(int)-1))
> +		return -EFAULT;
> +
> +	/*
> +	 * Initialize the output buffer.
> +	 */
> +	memset(&context, 0, sizeof(context));
> +	context.dp = dp;
> +	context.cursor = cursor;
> +	context.resynch = 1;
> +	context.flags = flags;
> +	context.buffer = buffer;
> +	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
> +	context.firstu = context.bufsize;
> +	context.put_listent = xfs_ioc_attr_put_listent;
> +
> +	alist = context.buffer;
> +	alist->al_count = 0;
> +	alist->al_more = 0;
> +	alist->al_offset[0] = context.bufsize;
> +
> +	error = xfs_attr_list_int(&context);
> +	ASSERT(error <= 0);
> +	return error;
> +}
> +
>  STATIC int
>  xfs_attrlist_by_handle(
>  	struct file		*parfilp,
> @@ -308,7 +416,7 @@ xfs_attrlist_by_handle(
>  		return -EPERM;
>  	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
>  		return -EFAULT;
> -	if (al_hreq.buflen < sizeof(struct attrlist) ||
> +	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
>  	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
>  		return -EINVAL;
>  
> @@ -327,7 +435,7 @@ xfs_attrlist_by_handle(
>  		goto out_dput;
>  
>  	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
> -	error = xfs_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
> +	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
>  					al_hreq.flags, cursor);
>  	if (error)
>  		goto out_kfree;
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index bb50cb3dc61f..cb7b94c576a7 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -6,6 +6,12 @@
>  #ifndef __XFS_IOCTL_H__
>  #define __XFS_IOCTL_H__
>  
> +struct attrlist_cursor_kern;
> +struct xfs_bstat;
> +struct xfs_ibulk;
> +struct xfs_inogrp;
> +
> +
>  extern int
>  xfs_ioc_space(
>  	struct file		*filp,
> @@ -33,6 +39,8 @@ xfs_readlink_by_handle(
>  int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
>  		uint32_t opcode, void __user *uname, void __user *value,
>  		uint32_t *len, uint32_t flags);
> +int xfs_ioc_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
> +	int flags, struct attrlist_cursor_kern *cursor);
>  
>  extern struct dentry *
>  xfs_handle_to_dentry(
> @@ -52,10 +60,6 @@ xfs_file_compat_ioctl(
>  	unsigned int		cmd,
>  	unsigned long		arg);
>  
> -struct xfs_ibulk;
> -struct xfs_bstat;
> -struct xfs_inogrp;
> -
>  int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
>  			   const struct xfs_bulkstat *bstat);
>  int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inumbers *igrp);
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index ee428ddf51e5..feb7bf07f315 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -366,7 +366,7 @@ xfs_compat_attrlist_by_handle(
>  	if (copy_from_user(&al_hreq, arg,
>  			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
>  		return -EFAULT;
> -	if (al_hreq.buflen < sizeof(struct attrlist) ||
> +	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
>  	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
>  		return -EINVAL;
>  
> @@ -386,7 +386,7 @@ xfs_compat_attrlist_by_handle(
>  		goto out_dput;
>  
>  	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
> -	error = xfs_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
> +	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
>  					al_hreq.flags, cursor);
>  	if (error)
>  		goto out_kfree;
> -- 
> 2.24.1
> 
