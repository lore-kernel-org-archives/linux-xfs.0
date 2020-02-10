Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3344EC35250
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 06:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06C2C20715
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 06:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgBJGAA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 01:00:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726061AbgBJGAA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Feb 2020 01:00:00 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01A5x2b1042252
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 00:59:59 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1umr75mc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 00:59:59 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 10 Feb 2020 05:59:57 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 05:59:54 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01A5xrRO55181396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 05:59:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E2A011C04C;
        Mon, 10 Feb 2020 05:59:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B131011C058;
        Mon, 10 Feb 2020 05:59:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.35.21])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 05:59:52 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 25/30] xfs: lift cursor copy in/out into xfs_ioc_attr_list
Date:   Mon, 10 Feb 2020 11:32:39 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-26-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-26-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20021005-0020-0000-0000-000003A8A963
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021005-0021-0000-0000-00002200826B
Message-Id: <3888160.J6lqWWilKB@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_01:2020-02-07,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 malwarescore=0 phishscore=0 suspectscore=5 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:33 PM Christoph Hellwig wrote: 
> Lift the common code to copy the cursor from and to user space into
> xfs_ioc_attr_list.  Note that this means we copy in twice now as
> the cursor is in the middle of the conaining structure, but we never
> touch the memory for the original copy.  Doing so keeps the cursor
> handling isolated in the common helper.
>

Logically, code flow remains the same.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c   | 36 +++++++++++++++---------------------
>  fs/xfs/xfs_ioctl.h   |  2 +-
>  fs/xfs/xfs_ioctl32.c | 19 ++++---------------
>  3 files changed, 20 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index cdb3800dfcef..5d160e82778e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -354,9 +354,10 @@ xfs_ioc_attr_list(
>  	void __user			*ubuf,
>  	int				bufsize,
>  	int				flags,
> -	struct attrlist_cursor_kern	*cursor)
> +	struct xfs_attrlist_cursor __user *ucursor)
>  {
>  	struct xfs_attr_list_context	context;
> +	struct attrlist_cursor_kern	cursor;
>  	struct xfs_attrlist		*alist;
>  	void				*buffer;
>  	int				error;
> @@ -376,10 +377,12 @@ xfs_ioc_attr_list(
>  	/*
>  	 * Validate the cursor.
>  	 */
> -	if (cursor->pad1 || cursor->pad2)
> +	if (copy_from_user(&cursor, ucursor, sizeof(cursor)))
> +		return -EFAULT;
> +	if (cursor.pad1 || cursor.pad2)
>  		return -EINVAL;
> -	if ((cursor->initted == 0) &&
> -	    (cursor->hashval || cursor->blkno || cursor->offset))
> +	if ((cursor.initted == 0) &&
> +	    (cursor.hashval || cursor.blkno || cursor.offset))
>  		return -EINVAL;
> 
>  	buffer = kmem_zalloc_large(bufsize, 0);
> @@ -391,7 +394,7 @@ xfs_ioc_attr_list(
>  	 */
>  	memset(&context, 0, sizeof(context));
>  	context.dp = dp;
> -	context.cursor = cursor;
> +	context.cursor = &cursor;
>  	context.resynch = 1;
>  	context.flags = flags;
>  	context.buffer = buffer;
> @@ -408,7 +411,8 @@ xfs_ioc_attr_list(
>  	if (error)
>  		goto out_free;
> 
> -	if (copy_to_user(ubuf, buffer, bufsize))
> +	if (copy_to_user(ubuf, buffer, bufsize) ||
> +	    copy_to_user(ucursor, &cursor, sizeof(cursor)))
>  		error = -EFAULT;
>  out_free:
>  	kmem_free(buffer);
> @@ -418,33 +422,23 @@ xfs_ioc_attr_list(
>  STATIC int
>  xfs_attrlist_by_handle(
>  	struct file		*parfilp,
> -	void			__user *arg)
> +	struct xfs_fsop_attrlist_handlereq __user *p)
>  {
> -	int			error = -ENOMEM;
> -	attrlist_cursor_kern_t	*cursor;
> -	struct xfs_fsop_attrlist_handlereq __user	*p = arg;
> -	xfs_fsop_attrlist_handlereq_t al_hreq;
> +	struct xfs_fsop_attrlist_handlereq al_hreq;
>  	struct dentry		*dentry;
> +	int			error = -ENOMEM;
> 
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
> +	if (copy_from_user(&al_hreq, p, sizeof(al_hreq)))
>  		return -EFAULT;
> 
>  	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
>  	if (IS_ERR(dentry))
>  		return PTR_ERR(dentry);
> 
> -	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
>  	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), al_hreq.buffer,
> -				  al_hreq.buflen, al_hreq.flags, cursor);
> -	if (error)
> -		goto out_dput;
> -
> -	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
> -		error = -EFAULT;
> -
> -out_dput:
> +				  al_hreq.buflen, al_hreq.flags, &p->pos);
>  	dput(dentry);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index ec6448b259fb..d6e8000ad825 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -40,7 +40,7 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
>  		uint32_t opcode, void __user *uname, void __user *value,
>  		uint32_t *len, uint32_t flags);
>  int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
> -	int flags, struct attrlist_cursor_kern *cursor);
> +	int flags, struct xfs_attrlist_cursor __user *ucursor);
> 
>  extern struct dentry *
>  xfs_handle_to_dentry(
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 17e14916757b..c1771e728117 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -352,35 +352,24 @@ xfs_compat_handlereq_to_dentry(
>  STATIC int
>  xfs_compat_attrlist_by_handle(
>  	struct file		*parfilp,
> -	void			__user *arg)
> +	compat_xfs_fsop_attrlist_handlereq_t __user *p)
>  {
> -	int			error;
> -	attrlist_cursor_kern_t	*cursor;
> -	compat_xfs_fsop_attrlist_handlereq_t __user *p = arg;
>  	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
>  	struct dentry		*dentry;
> +	int			error;
> 
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	if (copy_from_user(&al_hreq, arg,
> -			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
> +	if (copy_from_user(&al_hreq, p, sizeof(al_hreq)))
>  		return -EFAULT;
> 
>  	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
>  	if (IS_ERR(dentry))
>  		return PTR_ERR(dentry);
> 
> -	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
>  	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)),
>  			compat_ptr(al_hreq.buffer), al_hreq.buflen,
> -			al_hreq.flags, cursor);
> -	if (error)
> -		goto out_dput;
> -
> -	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
> -		error = -EFAULT;
> -
> -out_dput:
> +			al_hreq.flags, &p->pos);
>  	dput(dentry);
>  	return error;
>  }
> 


-- 
chandan



