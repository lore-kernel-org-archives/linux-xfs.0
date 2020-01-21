Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B2BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C2DB24655
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:52:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dit1Me3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAUSwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:52:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58850 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUSwx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:52:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImQ4S030499;
        Tue, 21 Jan 2020 18:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=m8t/KDwIjV5K48VkHICTeJbrpP/mVlqmV7CDsPIkQCE=;
 b=dit1Me3lRm0Rx6Hlh7BZMDbwMPq9eB5jJ2gsdk0bv9f0i/jMTnD8vhiyJM1+5pwkarqA
 YtSxQxUWu89fwLgZIuL0QIrqoPhjqSAAuPPdGkIIShMH5bI3PNLPHPKMse1sx4T6R6os
 s8Xofy1PVe/mrPt2sSZd9tb621fBaDDpUwhOi1VjG5gdL1Ig2TRbwPutj3bVe0K/egjJ
 hH4pS1BeEBYdU1INc++uCstmSl7D8RnVxE/7Jpyzr5m23XUDIcg5ubQaCygRySuv5+WK
 Cmh6zjo9eunMmbyPBcVpNIA8CYMUNDS79t+puRamUVF5T4QldEOke0U4CiOWQv39beGF sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseuf6v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:52:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImIOA029574;
        Tue, 21 Jan 2020 18:52:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xnpfpje6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:52:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LIqlb5021318;
        Tue, 21 Jan 2020 18:52:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:52:46 -0800
Date:   Tue, 21 Jan 2020 10:52:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 24/29] xfs: lift cursor copy in/out into xfs_ioc_attr_list
Message-ID: <20200121185245.GY8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-25-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-25-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:46AM +0100, Christoph Hellwig wrote:
> Lift the common code to copy the cursor from and to user space into
> xfs_ioc_attr_list.  Note that this means we copy in twice now as
> the cursor is in the middle of the conaining structure, but we never
> touch the memory for the original copy.  Doing so keeps the cursor
> handling isolated in the common helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c   | 36 +++++++++++++++---------------------
>  fs/xfs/xfs_ioctl.h   |  2 +-
>  fs/xfs/xfs_ioctl32.c | 19 ++++---------------
>  3 files changed, 20 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8d7b8ad21d9e..899a3b41fa91 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -356,9 +356,10 @@ xfs_ioc_attr_list(
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
> -- 
> 2.24.1
> 
