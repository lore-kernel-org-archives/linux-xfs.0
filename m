Return-Path: <SRS0=+eDc=35=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE872C35250
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 07:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9594720733
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 07:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgBIHlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 02:41:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgBIHll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Feb 2020 02:41:41 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0197dQ6V017073
        for <linux-xfs@vger.kernel.org>; Sun, 9 Feb 2020 02:41:39 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1u1gsbs7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 09 Feb 2020 02:41:39 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 9 Feb 2020 07:41:37 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 9 Feb 2020 07:41:34 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0197eePc46399778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Feb 2020 07:40:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0032A405B;
        Sun,  9 Feb 2020 07:41:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE551A405C;
        Sun,  9 Feb 2020 07:41:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.59.174])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Feb 2020 07:41:32 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 21/30] xfs: move the legacy xfs_attr_list to xfs_ioctl.c
Date:   Sun, 09 Feb 2020 13:14:18 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-22-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-22-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020907-0028-0000-0000-000003D8D9FF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020907-0029-0000-0000-0000249D423D
Message-Id: <1601688.7pIFPY2mFX@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-09_01:2020-02-07,2020-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002090064
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:33 PM Christoph Hellwig wrote:

One very trivial nit described below. Apart from that, the behavior of the
code is logically the same as before.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> The old xfs_attr_list code is only used by the attrlist by handle
> ioctl.  Move it to xfs_ioctl.c with its user.  Also move the
> attrlist and attrlist_ent structure to xfs_fs.h, as they are exposed
> user ABIs.  They are used through libattr headers with the same name
> by at least xfsdump.  Also document this relation so that it doesn't
> require a research project to figure out.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.h |  23 --------
>  fs/xfs/libxfs/xfs_fs.h   |  26 +++++++++
>  fs/xfs/xfs_attr_list.c   | 113 ---------------------------------------
>  fs/xfs/xfs_ioctl.c       | 110 ++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_ioctl.h       |  12 +++--
>  fs/xfs/xfs_ioctl32.c     |   4 +-
>  6 files changed, 144 insertions(+), 144 deletions(-)
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

In the above comment, 'attrlist_ent_t' should be replaced with 'struct
xfs_attrlist_ent'.

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
> index f1ca8ef8be22..369ce1d3dd45 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -544,116 +544,3 @@ xfs_attr_list_int(
>  	xfs_iunlock(dp, lock_mode);
>  	return error;
>  }
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
> -
> -	/* decrement by the actual bytes used by the attr */
> -	context->firstu -= round_up(offsetof(struct attrlist_ent, a_name) +
> -			namelen + 1, sizeof(uint32_t));
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
> index dd1cb8c50518..47c39895977b 100644
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
> @@ -292,6 +293,111 @@ xfs_readlink_by_handle(
>  	return error;
>  }
> 
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
> +
> +	/* decrement by the actual bytes used by the attr */
> +	context->firstu -= round_up(offsetof(struct xfs_attrlist_ent, a_name) +
> +			namelen + 1, sizeof(uint32_t));
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
> @@ -308,7 +414,7 @@ xfs_attrlist_by_handle(
>  		return -EPERM;
>  	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
>  		return -EFAULT;
> -	if (al_hreq.buflen < sizeof(struct attrlist) ||
> +	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
>  	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
>  		return -EINVAL;
> 
> @@ -329,7 +435,7 @@ xfs_attrlist_by_handle(
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
> index e1daf095c585..10ea0222954c 100644
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
> @@ -388,7 +388,7 @@ xfs_compat_attrlist_by_handle(
>  		goto out_dput;
> 
>  	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
> -	error = xfs_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
> +	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
>  					al_hreq.flags, cursor);
>  	if (error)
>  		goto out_kfree;
> 


-- 
chandan



