Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A67C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5620420678
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZqDuJIOr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgAUStT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:49:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbgAUStT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:49:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImZ5J188055;
        Tue, 21 Jan 2020 18:49:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=0+2L12W07a5hOt9rK+aiMk1bLP3s9UWrF1evvpZ23l8=;
 b=ZqDuJIOrzLWt9e5A7+6I+0ShZT8+e+Sc5a2+Eec7W61vb06lVHdiDfrvqod3jmPHHxEQ
 HPT20IHwC1O9PMbmzBg5AHCEHUHMlyYAyobocAwS5ShddDLCOVY2cAX/Ma7rUyLVlNye
 jp87xF65LTM08ULRLsEUoXOUNOSKKWCLVJylQ9pIYjA6QdDXff+uo8jThiiNsKPNSPuf
 86eIY02QaBlNRFyI9HeQqvIYc5csdAwHVuFnobFpiDny1lv4hmTAa+wSTsvw3/hbujwT
 V6Bl21R6wuFexYiuP+GYWe1c5JRypRvpDQyBXB2LEHd+FEmRxdL0ELLNTeIF4sp7UG10 +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyq719k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:49:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImbnK034873;
        Tue, 21 Jan 2020 18:49:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xnsj559we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:49:15 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LInEQo012010;
        Tue, 21 Jan 2020 18:49:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:49:14 -0800
Date:   Tue, 21 Jan 2020 10:49:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 23/29] xfs: lift buffer allocation into xfs_ioc_attr_list
Message-ID: <20200121184912.GX8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-24-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-24-hch@lst.de>
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

On Tue, Jan 14, 2020 at 09:10:45AM +0100, Christoph Hellwig wrote:
> Lift the buffer allocation from the two callers into xfs_ioc_attr_list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c   | 39 ++++++++++++++++-----------------------
>  fs/xfs/xfs_ioctl.h   |  2 +-
>  fs/xfs/xfs_ioctl32.c | 22 +++++-----------------
>  3 files changed, 22 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a3a6c6882c6f..8d7b8ad21d9e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -353,13 +353,14 @@ xfs_ioc_attr_put_listent(
>  int
>  xfs_ioc_attr_list(
>  	struct xfs_inode		*dp,
> -	char				*buffer,
> +	void __user			*ubuf,
>  	int				bufsize,
>  	int				flags,
>  	struct attrlist_cursor_kern	*cursor)
>  {
>  	struct xfs_attr_list_context	context;
>  	struct xfs_attrlist		*alist;
> +	void				*buffer;
>  	int				error;
>  
>  	if (bufsize < sizeof(struct xfs_attrlist) ||
> @@ -381,11 +382,9 @@ xfs_ioc_attr_list(
>  	    (cursor->hashval || cursor->blkno || cursor->offset))
>  		return -EINVAL;
>  
> -	/*
> -	 * Check for a properly aligned buffer.
> -	 */
> -	if (((long)buffer) & (sizeof(int)-1))
> -		return -EFAULT;
> +	buffer = kmem_zalloc_large(bufsize, 0);
> +	if (!buffer)
> +		return -ENOMEM;
>  
>  	/*
>  	 * Initialize the output buffer.
> @@ -406,7 +405,13 @@ xfs_ioc_attr_list(
>  	alist->al_offset[0] = context.bufsize;
>  
>  	error = xfs_attr_list(&context);
> -	ASSERT(error <= 0);
> +	if (error)
> +		goto out_free;
> +
> +	if (copy_to_user(ubuf, buffer, bufsize))
> +		error = -EFAULT;
> +out_free:
> +	kmem_free(buffer);
>  	return error;
>  }
>  
> @@ -420,7 +425,6 @@ xfs_attrlist_by_handle(
>  	struct xfs_fsop_attrlist_handlereq __user	*p = arg;
>  	xfs_fsop_attrlist_handlereq_t al_hreq;
>  	struct dentry		*dentry;
> -	char			*kbuf;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -431,26 +435,15 @@ xfs_attrlist_by_handle(
>  	if (IS_ERR(dentry))
>  		return PTR_ERR(dentry);
>  
> -	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
> -	if (!kbuf)
> -		goto out_dput;
> -
>  	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
> -	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
> -					al_hreq.flags, cursor);
> +	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), al_hreq.buffer,
> +				  al_hreq.buflen, al_hreq.flags, cursor);
>  	if (error)
> -		goto out_kfree;
> -
> -	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t))) {
> -		error = -EFAULT;
> -		goto out_kfree;
> -	}
> +		goto out_dput;
>  
> -	if (copy_to_user(al_hreq.buffer, kbuf, al_hreq.buflen))
> +	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
>  		error = -EFAULT;
>  
> -out_kfree:
> -	kmem_free(kbuf);
>  out_dput:
>  	dput(dentry);
>  	return error;
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index cb7b94c576a7..ec6448b259fb 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -39,7 +39,7 @@ xfs_readlink_by_handle(
>  int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
>  		uint32_t opcode, void __user *uname, void __user *value,
>  		uint32_t *len, uint32_t flags);
> -int xfs_ioc_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
> +int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
>  	int flags, struct attrlist_cursor_kern *cursor);
>  
>  extern struct dentry *
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 840d17951407..17e14916757b 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -359,7 +359,6 @@ xfs_compat_attrlist_by_handle(
>  	compat_xfs_fsop_attrlist_handlereq_t __user *p = arg;
>  	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
>  	struct dentry		*dentry;
> -	char			*kbuf;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -371,27 +370,16 @@ xfs_compat_attrlist_by_handle(
>  	if (IS_ERR(dentry))
>  		return PTR_ERR(dentry);
>  
> -	error = -ENOMEM;
> -	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
> -	if (!kbuf)
> -		goto out_dput;
> -
>  	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
> -	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
> -					al_hreq.flags, cursor);
> +	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)),
> +			compat_ptr(al_hreq.buffer), al_hreq.buflen,
> +			al_hreq.flags, cursor);
>  	if (error)
> -		goto out_kfree;
> -
> -	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t))) {
> -		error = -EFAULT;
> -		goto out_kfree;
> -	}
> +		goto out_dput;
>  
> -	if (copy_to_user(compat_ptr(al_hreq.buffer), kbuf, al_hreq.buflen))
> +	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
>  		error = -EFAULT;
>  
> -out_kfree:
> -	kmem_free(kbuf);
>  out_dput:
>  	dput(dentry);
>  	return error;
> -- 
> 2.24.1
> 
