Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1357C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 19:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FF9C24655
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 19:44:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p+KbAMFK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgAUTox (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 14:44:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58082 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgAUTox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 14:44:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LJcJl6035193;
        Tue, 21 Jan 2020 19:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+WWMImaDAmvRkvF33bIRJk3kqOgQHbhoytjolr+JQRY=;
 b=p+KbAMFKrQA7KZfJ9aRc0zy+k/xpwTpnEU5V5rHYnTqnpvq3vSJfIiH2Hr2tSmy0TjNH
 bxKi7+aYThy1CXK2tQt9xOMy1cl84WvFq1d1ybt0qeGsbn0wwrCm4Av5TWQXh7/cs66I
 qg/jojxKsm4cM4D493dZuOWJGMr9SF5CxdpPj+h07C05oKyaZ7W5zjRUxPiQcJwCNbm5
 OX5H+qunv2wsZ6D9ocIOLjhGJhrQjBgieEG4Q4Dem+rWE7VQiPlzfvj/VPxtqryPZimI
 9J9z/OpS/YvUCigi9pfIL4nkJYnj+9JMrMJbXYpQfQRBmwFErfy5RUgfix5xyDyAsd2h ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksyq7b4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 19:44:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LJcVLu159886;
        Tue, 21 Jan 2020 19:44:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xnpfpmvap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 19:44:41 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LJifZu019104;
        Tue, 21 Jan 2020 19:44:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 11:44:40 -0800
Date:   Tue, 21 Jan 2020 11:44:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 27/29] xfs: clean up the attr flag confusion
Message-ID: <20200121194440.GC8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-28-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-28-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Clean up?  This whole XATTR_/ATTR_/XFS_ATTR_/XFS_IOC_ATTR_ quadrality is
/still/ confusing to me.

On Tue, Jan 14, 2020 at 09:10:49AM +0100, Christoph Hellwig wrote:
> The ATTR_* flags have a long IRIX history, where they a userspace
> interface, the on-disk format and an internal interface.  We've split
> out the on-disk interface to the XFS_ATTR_* values, but despite (or
> because?) of that the flag have still been a mess.  Switch the
> internal interface to pass the on-disk XFS_ATTR_* flags for the
> namespace and the Linux XATTR_* flags for the actual flags instead.
> The ATTR_* values that are actually used are move to xfs_fs.h with a
> new XFS_IOC_* prefix to not conflict with the userspace version that
> has the same name and must have the same value.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 16 ++++++-------
>  fs/xfs/libxfs/xfs_attr.h      | 22 +-----------------
>  fs/xfs/libxfs/xfs_attr_leaf.c | 14 +++++------
>  fs/xfs/libxfs/xfs_da_format.h | 12 ----------
>  fs/xfs/libxfs/xfs_fs.h        | 29 ++++++++++++-----------
>  fs/xfs/libxfs/xfs_types.h     |  3 ++-
>  fs/xfs/scrub/attr.c           |  5 +---
>  fs/xfs/xfs_acl.c              |  5 ++--
>  fs/xfs/xfs_ioctl.c            | 44 ++++++++++++++++++++++++++---------
>  fs/xfs/xfs_iops.c             |  3 +--
>  fs/xfs/xfs_linux.h            |  1 +
>  fs/xfs/xfs_trace.h            | 35 +++++++++++++++++-----------
>  fs/xfs/xfs_xattr.c            | 18 +++++---------
>  13 files changed, 100 insertions(+), 107 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3b29cdeecb64..2b9c0aa5af4a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -291,7 +291,7 @@ xfs_attr_set(
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_trans_res	tres;
> -	int			rsvd = (args->flags & ATTR_ROOT) != 0;
> +	int			rsvd = (args->attr_namespace & XFS_ATTR_ROOT);

bool?

>  	int			error, local;
>  	unsigned int		total;
>  
> @@ -419,10 +419,10 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	trace_xfs_attr_sf_addname(args);
>  
>  	retval = xfs_attr_shortform_lookup(args);
> -	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
> +	if ((args->attr_flags & XATTR_REPLACE) && retval == -ENOATTR)
>  		return retval;
>  	if (retval == -EEXIST) {
> -		if (args->flags & ATTR_CREATE)
> +		if (args->attr_flags & XATTR_CREATE)
>  			return retval;
>  		retval = xfs_attr_shortform_remove(args);
>  		if (retval)
> @@ -432,7 +432,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  		 * that the leaf format add routine won't trip over the attr
>  		 * not being around.
>  		 */
> -		args->flags &= ~ATTR_REPLACE;
> +		args->attr_flags &= ~XATTR_REPLACE;
>  	}
>  
>  	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
> @@ -485,10 +485,10 @@ xfs_attr_leaf_addname(
>  	 * the given flags produce an error or call for an atomic rename.
>  	 */
>  	retval = xfs_attr3_leaf_lookup_int(bp, args);
> -	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
> +	if ((args->attr_flags & XATTR_REPLACE) && retval == -ENOATTR)
>  		goto out_brelse;
>  	if (retval == -EEXIST) {
> -		if (args->flags & ATTR_CREATE)	/* pure create op */
> +		if (args->attr_flags & XATTR_CREATE)	/* pure create op */
>  			goto out_brelse;
>  
>  		trace_xfs_attr_leaf_replace(args);
> @@ -759,10 +759,10 @@ xfs_attr_node_addname(
>  		goto out;
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
> +	if ((args->attr_flags & XATTR_REPLACE) && retval == -ENOATTR)
>  		goto out;
>  	if (retval == -EEXIST) {
> -		if (args->flags & ATTR_CREATE)
> +		if (args->attr_flags & XATTR_CREATE)
>  			goto out;
>  
>  		trace_xfs_attr_node_replace(args);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 8d42f5782ff7..2a379338d71b 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -21,26 +21,6 @@ struct xfs_attr_list_context;
>   * as possible so as to fit into the literal area of the inode.
>   */
>  
> -/*========================================================================
> - * External interfaces
> - *========================================================================*/
> -
> -
> -#define ATTR_DONTFOLLOW	0x0001	/* -- ignored, from IRIX -- */
> -#define ATTR_ROOT	0x0002	/* use attrs in root (trusted) namespace */
> -#define ATTR_TRUST	0x0004	/* -- unused, from IRIX -- */
> -#define ATTR_SECURE	0x0008	/* use attrs in security namespace */
> -#define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
> -#define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
> -
> -#define XFS_ATTR_FLAGS \
> -	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
> -	{ ATTR_ROOT,		"ROOT" }, \
> -	{ ATTR_TRUST,		"TRUST" }, \
> -	{ ATTR_SECURE,		"SECURE" }, \
> -	{ ATTR_CREATE,		"CREATE" }, \
> -	{ ATTR_REPLACE,		"REPLACE" }
> -
>  /*
>   * The maximum size (into the kernel or returned from the kernel) of an
>   * attribute value or the buffer used for an attr_list() call.  Larger
> @@ -87,7 +67,7 @@ struct xfs_attr_list_context {
>  	int			dupcnt;		/* count dup hashvals seen */
>  	int			bufsize;	/* total buffer size */
>  	int			firstu;		/* first used byte in buffer */
> -	int			flags;		/* from VOP call */
> +	unsigned int		attr_namespace;

What flags go with this attr_namespace field?  XFS_ATTR_{ROOT,SECURE}?

(Note: While I /think/ all the code changes work correctly, I'm mostly
going to complain about things in the hunks that change the header
files.)

>  	int			resynch;	/* T/F: resynch with cursor */
>  	put_listent_func_t	put_listent;	/* list output fmt function */
>  	int			index;		/* index into output buffer */
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8852754153ba..9081ba7af90a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -456,8 +456,7 @@ xfs_attr_match(
>  		return false;
>  	if (memcmp(args->name, name, namelen) != 0)
>  		return false;
> -	if (XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags) !=
> -	    XFS_ATTR_NSP_ONDISK(flags))
> +	if (args->attr_namespace != (flags & XFS_ATTR_NSP_ONDISK_MASK))
>  		return false;
>  	return true;
>  }
> @@ -697,7 +696,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>  
>  	sfe->namelen = args->namelen;
>  	sfe->valuelen = args->valuelen;
> -	sfe->flags = XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
> +	sfe->flags = args->attr_namespace;
>  	memcpy(sfe->nameval, args->name, args->namelen);
>  	memcpy(&sfe->nameval[args->namelen], args->value, args->valuelen);
>  	sf->hdr.count++;
> @@ -906,7 +905,7 @@ xfs_attr_shortform_to_leaf(
>  		nargs.valuelen = sfe->valuelen;
>  		nargs.hashval = xfs_da_hashname(sfe->nameval,
>  						sfe->namelen);
> -		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
> +		nargs.attr_namespace = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
>  		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
>  		ASSERT(error == -ENOATTR);
>  		error = xfs_attr3_leaf_add(bp, &nargs);
> @@ -1112,7 +1111,7 @@ xfs_attr3_leaf_to_shortform(
>  		nargs.value = &name_loc->nameval[nargs.namelen];
>  		nargs.valuelen = be16_to_cpu(name_loc->valuelen);
>  		nargs.hashval = be32_to_cpu(entry->hashval);
> -		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
> +		nargs.attr_namespace = entry->flags & XFS_ATTR_NSP_ONDISK_MASK;
>  		xfs_attr_shortform_add(&nargs, forkoff);
>  	}
>  	error = 0;
> @@ -1437,8 +1436,9 @@ xfs_attr3_leaf_add_work(
>  	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
>  				     ichdr->freemap[mapindex].size);
>  	entry->hashval = cpu_to_be32(args->hashval);
> -	entry->flags = tmp ? XFS_ATTR_LOCAL : 0;
> -	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
> +	entry->flags = args->attr_namespace;
> +	if (tmp)
> +		entry->flags |= XFS_ATTR_LOCAL;
>  	if (args->op_flags & XFS_DA_OP_RENAME) {
>  		entry->flags |= XFS_ATTR_INCOMPLETE;
>  		if ((args->blkno2 == args->blkno) &&
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 05615d1f4113..239b114932b8 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -692,19 +692,7 @@ struct xfs_attr3_leafblock {
>  #define XFS_ATTR_ROOT		(1 << XFS_ATTR_ROOT_BIT)
>  #define XFS_ATTR_SECURE		(1 << XFS_ATTR_SECURE_BIT)
>  #define XFS_ATTR_INCOMPLETE	(1 << XFS_ATTR_INCOMPLETE_BIT)
> -
> -/*
> - * Conversion macros for converting namespace bits from argument flags
> - * to ondisk flags.
> - */
> -#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE)
>  #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
> -#define XFS_ATTR_NSP_ONDISK(flags)	((flags) & XFS_ATTR_NSP_ONDISK_MASK)
> -#define XFS_ATTR_NSP_ARGS(flags)	((flags) & XFS_ATTR_NSP_ARGS_MASK)
> -#define XFS_ATTR_NSP_ARGS_TO_ONDISK(x)	(((x) & ATTR_ROOT ? XFS_ATTR_ROOT : 0) |\
> -					 ((x) & ATTR_SECURE ? XFS_ATTR_SECURE : 0))
> -#define XFS_ATTR_NSP_ONDISK_TO_ARGS(x)	(((x) & XFS_ATTR_ROOT ? ATTR_ROOT : 0) |\
> -					 ((x) & XFS_ATTR_SECURE ? ATTR_SECURE : 0))
>  
>  /*
>   * Alignment for namelist and valuelist entries (since they are mixed
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2c2b6e2b58f4..e79af058b1b3 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -568,17 +568,27 @@ typedef struct xfs_fsop_setdm_handlereq {
>  	struct fsdmidata		__user *data;	/* DMAPI data	*/
>  } xfs_fsop_setdm_handlereq_t;
>  
> +/*
> + * Flags for the attr ioctl interface.
> + * NOTE: Must match the values declared in libattr without the XFS_IOC_ prefix.
> + */
> +#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
> +#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
> +#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
> +#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */

I think it's worth nothing that these flags are supposed to be passed in
via am_flags in the attrmulti structure.

(Assuming I even got that right...)

>  typedef struct xfs_attrlist_cursor {
>  	__u32		opaque[4];
>  } xfs_attrlist_cursor_t;
>  
>  /*
> - * Define how lists of attribute names are returned to the user from
> - * the attr_list() call.  A large, 32bit aligned, buffer is passed in
> - * along with its size.  We put an array of offsets at the top that each
> - * reference an attrlist_ent_t and pack the attrlist_ent_t's at the bottom.
> + * Define how lists of attribute names are returned to userspace from the
> + * XFS_IOC_ATTRLIST_BY_HANDLE ioctl.  struct xfs_attrlist is the header at the
> + * beginning of the returned buffer, and a each entry in al_offset contains the
> + * relative offset of an xfs_attrlist_ent containing the actual entry.
>   *
> - * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr.
> + * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr, and
> + * struct xfs_attrlist_ent must match struct attrlist_ent defined in libattr.
>   */
>  struct xfs_attrlist {
>  	__s32	al_count;	/* number of entries in attrlist */
> @@ -586,13 +596,6 @@ struct xfs_attrlist {
>  	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
>  };
>  
> -/*
> - * Show the interesting info about one attribute.  This is what the
> - * al_offset[i] entry points to.
> - *
> - * NOTE: struct xfs_attrlist_ent must match struct attrlist_ent defined in
> - * libattr.
> - */
>  struct xfs_attrlist_ent {	/* data from attr_list() */
>  	__u32	a_valuelen;	/* number bytes in value of attr */
>  	char	a_name[1];	/* attr name (NULL terminated) */
> @@ -603,7 +606,7 @@ typedef struct xfs_fsop_attrlist_handlereq {
>  	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
>  	__u32				flags;	/* which namespace to use */
>  	__u32				buflen;	/* length of buffer supplied */
> -	void				__user *buffer;	/* returned names */
> +	struct xfs_attrlist __user	*buffer;/* returned names */
>  } xfs_fsop_attrlist_handlereq_t;
>  
>  typedef struct xfs_attr_multiop {
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 1594325d7742..1bf84488d34c 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -194,7 +194,8 @@ typedef struct xfs_da_args {
>  	uint8_t		filetype;	/* filetype of inode for directories */
>  	void		*value;		/* set of bytes (maybe contain NULLs) */
>  	int		valuelen;	/* length of value */
> -	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
> +	unsigned int	attr_namespace;
> +	unsigned int	attr_flags;

Please add comments to both of these fields explaining which flags go
with which field.

AFAICT, xfs_da_args.attr_namespace holds the two ondisk namespace flags?
Which are XFS_ATTR_{ROOT,SECURE}?  And ... I think the next patch makes
it so that people can pass XFS_ATTR_INCOMPLETE for lookups, too?

vs. xfs_da_args.attr_flags, which contains the XATTR_{CREATE,REPLACE}
flags, which are the attr operation flags that we got from userspace?

And what goes in xfs_attr_list_context.attr_namespace?  Same values as
xfs_da_args.attr_namespace?

>  	xfs_dahash_t	hashval;	/* hash value of name */
>  	xfs_ino_t	inumber;	/* input/output inode number */
>  	struct xfs_inode *dp;		/* directory inode to manipulate */
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 9e336d797616..d84237af5455 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -148,10 +148,7 @@ xchk_xattr_listent(
>  	}
>  
>  	args.op_flags = XFS_DA_OP_NOTIME;
> -	if (flags & XFS_ATTR_ROOT)
> -		args.flags |= ATTR_ROOT;
> -	else if (flags & XFS_ATTR_SECURE)
> -		args.flags |= ATTR_SECURE;
> +	args.attr_namespace = flags & XFS_ATTR_NSP_ONDISK_MASK;
>  	args.geo = context->dp->i_mount->m_attr_geo;
>  	args.whichfork = XFS_ATTR_FORK;
>  	args.dp = context->dp;
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index c993ffd9b767..dd54e3b8adb2 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -14,6 +14,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
>  #include "xfs_acl.h"
> +#include "xfs_da_format.h"
>  
>  #include <linux/posix_acl_xattr.h>
>  
> @@ -125,7 +126,7 @@ xfs_get_acl(struct inode *inode, int type)
>  	struct posix_acl	*acl = NULL;
>  	struct xfs_da_args	args = {
>  		.dp		= ip,
> -		.flags		= ATTR_ROOT,
> +		.attr_namespace	= XFS_ATTR_ROOT,
>  		.valuelen	= XFS_ACL_MAX_SIZE(mp),
>  	};
>  	int			error;
> @@ -166,7 +167,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_da_args	args = {
>  		.dp		= ip,
> -		.flags		= ATTR_ROOT,
> +		.attr_namespace	= XFS_ATTR_ROOT,
>  	};
>  	int			error;
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 7a1ff66b4786..063dc0d83453 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -293,6 +293,30 @@ xfs_readlink_by_handle(
>  	return error;
>  }
>  
> +static unsigned int
> +xfs_attr_namespace(
> +	u32			ioc_flags)
> +{
> +	unsigned int		namespace = 0;
> +
> +	if (ioc_flags & XFS_IOC_ATTR_ROOT)
> +		namespace |= XFS_ATTR_ROOT;
> +	if (ioc_flags & XFS_IOC_ATTR_SECURE)
> +		namespace |= XFS_ATTR_SECURE;

Seeing as these are mutually exclusive options, I'm a little surprised
there isn't more checking that both of these flags aren't set at the
same time.

(Or I've been reading this series too long and missed that it does...)

--D

> +	return namespace;
> +}
> +
> +static unsigned int
> +xfs_attr_flags(
> +	u32			ioc_flags)
> +{
> +	if (ioc_flags & XFS_IOC_ATTR_CREATE)
> +		return XATTR_CREATE;
> +	if (ioc_flags & XFS_IOC_ATTR_REPLACE)
> +		return XATTR_REPLACE;
> +	return 0;
> +}
> +
>  #define	ATTR_ENTSIZE(namelen)		/* actual bytes used by an attr */ \
>  	((offsetof(struct xfs_attrlist_ent, a_name) + \
>  	 (namelen) + 1 + sizeof(uint32_t) - 1) \
> @@ -324,11 +348,7 @@ xfs_ioc_attr_put_listent(
>  	/*
>  	 * Only list entries in the right namespace.
>  	 */
> -	if (((context->flags & ATTR_SECURE) == 0) !=
> -	    ((flags & XFS_ATTR_SECURE) == 0))
> -		return;
> -	if (((context->flags & ATTR_ROOT) == 0) !=
> -	    ((flags & XFS_ATTR_ROOT) == 0))
> +	if (context->attr_namespace != (flags & XFS_ATTR_NSP_ONDISK_MASK))
>  		return;
>  
>  	arraytop = sizeof(*alist) +
> @@ -371,7 +391,7 @@ xfs_ioc_attr_list(
>  	/*
>  	 * Reject flags, only allow namespaces.
>  	 */
> -	if (flags & ~(ATTR_ROOT | ATTR_SECURE))
> +	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
>  		return -EINVAL;
>  
>  	/*
> @@ -396,7 +416,7 @@ xfs_ioc_attr_list(
>  	context.dp = dp;
>  	context.cursor = &cursor;
>  	context.resynch = 1;
> -	context.flags = flags;
> +	context.attr_namespace = xfs_attr_namespace(flags);
>  	context.buffer = buffer;
>  	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
>  	context.firstu = context.bufsize;
> @@ -453,7 +473,8 @@ xfs_attrmulti_attr_get(
>  {
>  	struct xfs_da_args	args = {
>  		.dp		= XFS_I(inode),
> -		.flags		= flags,
> +		.attr_namespace	= xfs_attr_namespace(flags),
> +		.attr_flags	= xfs_attr_flags(flags),
>  		.name		= name,
>  		.namelen	= strlen(name),
>  		.valuelen	= *len,
> @@ -490,7 +511,8 @@ xfs_attrmulti_attr_set(
>  {
>  	struct xfs_da_args	args = {
>  		.dp		= XFS_I(inode),
> -		.flags		= flags,
> +		.attr_namespace	= xfs_attr_namespace(flags),
> +		.attr_flags	= xfs_attr_flags(flags),
>  		.name		= name,
>  		.namelen	= strlen(name),
>  	};
> @@ -509,7 +531,7 @@ xfs_attrmulti_attr_set(
>  	}
>  
>  	error = xfs_attr_set(&args);
> -	if (!error && (flags & ATTR_ROOT))
> +	if (!error && (flags & XFS_IOC_ATTR_ROOT))
>  		xfs_forget_acl(inode, name);
>  	kfree(args.value);
>  	return error;
> @@ -528,7 +550,7 @@ xfs_ioc_attrmulti_one(
>  	unsigned char		*name;
>  	int			error;
>  
> -	if ((flags & ATTR_ROOT) && (flags & ATTR_SECURE))
> +	if ((flags & XFS_IOC_ATTR_ROOT) && (flags & XFS_IOC_ATTR_SECURE))
>  		return -EINVAL;
>  
>  	name = strndup_user(uname, MAXNAMELEN);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 94cd4254656c..8b1a3e7d83e6 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -22,7 +22,6 @@
>  #include "xfs_iomap.h"
>  #include "xfs_error.h"
>  
> -#include <linux/xattr.h>
>  #include <linux/posix_acl.h>
>  #include <linux/security.h>
>  #include <linux/iversion.h>
> @@ -52,7 +51,7 @@ xfs_initxattrs(
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
>  		struct xfs_da_args	args = {
>  			.dp		= ip,
> -			.flags		= ATTR_SECURE,
> +			.attr_namespace	= XFS_ATTR_SECURE,
>  			.name		= xattr->name,
>  			.namelen	= strlen(xattr->name),
>  			.value		= xattr->value,
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 8738bb03f253..8c0070a797de 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -60,6 +60,7 @@ typedef __u32			xfs_nlink_t;
>  #include <linux/list_sort.h>
>  #include <linux/ratelimit.h>
>  #include <linux/rhashtable.h>
> +#include <linux/xattr.h>
>  
>  #include <asm/page.h>
>  #include <asm/div64.h>
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8358a92987f9..a064b1523fa5 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -36,6 +36,10 @@ struct xfs_owner_info;
>  struct xfs_trans_res;
>  struct xfs_inobt_rec_incore;
>  
> +#define XFS_ATTR_NSP_FLAGS \
> +	{ XFS_ATTR_ROOT,	"ROOT" }, \
> +	{ XFS_ATTR_SECURE,	"SECURE" }
> +
>  DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  	TP_PROTO(struct xfs_attr_list_context *ctx),
>  	TP_ARGS(ctx),
> @@ -50,7 +54,7 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  		__field(int, count)
>  		__field(int, firstu)
>  		__field(int, dupcnt)
> -		__field(int, flags)
> +		__field(int, attr_namespace)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
> @@ -62,10 +66,10 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  		__entry->bufsize = ctx->bufsize;
>  		__entry->count = ctx->count;
>  		__entry->firstu = ctx->firstu;
> -		__entry->flags = ctx->flags;
> +		__entry->attr_namespace = ctx->attr_namespace;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
> -		  "buffer %p size %u count %u firstu %u flags %d %s",
> +		  "buffer %p size %u count %u firstu %u namespace %d %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		   __entry->ino,
>  		   __entry->hashval,
> @@ -76,8 +80,9 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  		   __entry->bufsize,
>  		   __entry->count,
>  		   __entry->firstu,
> -		   __entry->flags,
> -		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS)
> +		   __entry->attr_namespace,
> +		   __print_flags(__entry->attr_namespace, "|",
> +				 XFS_ATTR_NSP_FLAGS)
>  	)
>  )
>  
> @@ -174,7 +179,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  		__field(int, count)
>  		__field(int, firstu)
>  		__field(int, dupcnt)
> -		__field(int, flags)
> +		__field(int, attr_namespace)
>  		__field(u32, bt_hashval)
>  		__field(u32, bt_before)
>  	),
> @@ -188,12 +193,12 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  		__entry->bufsize = ctx->bufsize;
>  		__entry->count = ctx->count;
>  		__entry->firstu = ctx->firstu;
> -		__entry->flags = ctx->flags;
> +		__entry->attr_namespace = ctx->attr_namespace;
>  		__entry->bt_hashval = be32_to_cpu(btree->hashval);
>  		__entry->bt_before = be32_to_cpu(btree->before);
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx cursor h/b/o 0x%x/0x%x/%u dupcnt %u "
> -		  "buffer %p size %u count %u firstu %u flags %d %s "
> +		  "buffer %p size %u count %u firstu %u namespae %d %s "
>  		  "node hashval %u, node before %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		   __entry->ino,
> @@ -205,8 +210,9 @@ TRACE_EVENT(xfs_attr_list_node_descend,
>  		   __entry->bufsize,
>  		   __entry->count,
>  		   __entry->firstu,
> -		   __entry->flags,
> -		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
> +		   __entry->attr_namespace,
> +		   __print_flags(__entry->attr_namespace, "|",
> +				 XFS_ATTR_NSP_FLAGS),
>  		   __entry->bt_hashval,
>  		   __entry->bt_before)
>  );
> @@ -1701,7 +1707,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  		__field(int, namelen)
>  		__field(int, valuelen)
>  		__field(xfs_dahash_t, hashval)
> -		__field(int, flags)
> +		__field(int, attr_namespace)
>  		__field(int, op_flags)
>  	),
>  	TP_fast_assign(
> @@ -1712,11 +1718,11 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  		__entry->namelen = args->namelen;
>  		__entry->valuelen = args->valuelen;
>  		__entry->hashval = args->hashval;
> -		__entry->flags = args->flags;
> +		__entry->attr_namespace = args->attr_namespace;
>  		__entry->op_flags = args->op_flags;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
> -		  "hashval 0x%x flags %s op_flags %s",
> +		  "hashval 0x%x namespace %s op_flags %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->namelen,
> @@ -1724,7 +1730,8 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  		  __entry->namelen,
>  		  __entry->valuelen,
>  		  __entry->hashval,
> -		  __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
> +		  __print_flags(__entry->attr_namespace, "|",
> +				XFS_ATTR_NSP_FLAGS),
>  		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
>  )
>  
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 863e9fdec162..1d2c8615b335 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -14,7 +14,6 @@
>  #include "xfs_acl.h"
>  
>  #include <linux/posix_acl_xattr.h>
> -#include <linux/xattr.h>
>  
>  
>  static int
> @@ -23,7 +22,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  {
>  	struct xfs_da_args	args = {
>  		.dp		= XFS_I(inode),
> -		.flags		= handler->flags,
> +		.attr_namespace	= handler->flags,
>  		.name		= name,
>  		.namelen	= strlen(name),
>  		.value		= value,
> @@ -44,7 +43,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  {
>  	struct xfs_da_args	args = {
>  		.dp		= XFS_I(inode),
> -		.flags		= handler->flags,
> +		.attr_namespace	= handler->flags,
> +		.attr_flags	= flags,
>  		.name		= name,
>  		.namelen	= strlen(name),
>  		.value		= (unsigned char *)value,
> @@ -52,14 +52,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  	};
>  	int			error;
>  
> -	/* Convert Linux syscall to XFS internal ATTR flags */
> -	if (flags & XATTR_CREATE)
> -		args.flags |= ATTR_CREATE;
> -	if (flags & XATTR_REPLACE)
> -		args.flags |= ATTR_REPLACE;
> -
>  	error = xfs_attr_set(&args);
> -	if (!error && (flags & ATTR_ROOT))
> +	if (!error && (handler->flags & XFS_ATTR_ROOT))
>  		xfs_forget_acl(inode, name);
>  	return error;
>  }
> @@ -73,14 +67,14 @@ static const struct xattr_handler xfs_xattr_user_handler = {
>  
>  static const struct xattr_handler xfs_xattr_trusted_handler = {
>  	.prefix	= XATTR_TRUSTED_PREFIX,
> -	.flags	= ATTR_ROOT,
> +	.flags	= XFS_ATTR_ROOT,
>  	.get	= xfs_xattr_get,
>  	.set	= xfs_xattr_set,
>  };
>  
>  static const struct xattr_handler xfs_xattr_security_handler = {
>  	.prefix	= XATTR_SECURITY_PREFIX,
> -	.flags	= ATTR_SECURE,
> +	.flags	= XFS_ATTR_SECURE,
>  	.get	= xfs_xattr_get,
>  	.set	= xfs_xattr_set,
>  };
> -- 
> 2.24.1
> 
