Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F2BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 17:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C6A120882
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 17:55:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nqE4TQFu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgAURzB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 12:55:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAURzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 12:55:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LHmDXB152590;
        Tue, 21 Jan 2020 17:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DpwpoNlFRWbxyM0ODAMtc+M2KQ5+hBElJBTOBuioFy4=;
 b=nqE4TQFuO6bnQTo0CSjZk96MiHBJBkn9hV/Bx0DRG03is/r+4FPCvhlRvu+0YVohFTq9
 a8R1Uk5YgUNSA0/qmJdlVQJiLleTvm9L+KhyCfE5ZejYps6BQTKX3OB7VkeJOi6MnXYY
 sCjy9FPVUmxYVKnuaQ/2Ikw468tU89tQ7HOMwVF2U8OjSjEAZML984jNT2KzC0Nr3+Rd
 v7eyUDjfDcB+o31DwE2jtGY31NrwHI7NsPB/j/1h0S9jpRdwB5NL4uWlGuUmlijmUmbW
 AJwPP3i9HqXGEOHsjByaXLMEPeGIaQUsfr0S+TtyLEkAcsXCAwWk+tWug1HNQ4OCoiNB hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnr6kjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 17:54:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LHnsUV186614;
        Tue, 21 Jan 2020 17:54:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xnsa93r4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 17:54:56 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LHsuvH015418;
        Tue, 21 Jan 2020 17:54:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 09:54:55 -0800
Date:   Tue, 21 Jan 2020 09:54:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 05/29] xfs: factor out a helper for a single
 XFS_IOC_ATTRMULTI_BY_HANDLE op
Message-ID: <20200121175453.GF8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=943
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:27AM +0100, Christoph Hellwig wrote:
> Add a new helper to handle a single attr multi ioctl operation that
> can be shared between the native and compat ioctl implementation.
> 
> There is a slight change in heavior in that we don't break out of the
> loop when copying in the attribute name fails.  The previous behavior
> was rather inconsistent here as it continued for any other kind of
> error.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c   | 97 +++++++++++++++++++++++---------------------
>  fs/xfs/xfs_ioctl.h   | 18 ++------
>  fs/xfs/xfs_ioctl32.c | 50 +++--------------------
>  3 files changed, 59 insertions(+), 106 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f4d5c865e29e..3dbbc1099375 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -347,7 +347,7 @@ xfs_attrlist_by_handle(
>  	return error;
>  }
>  
> -int
> +static int
>  xfs_attrmulti_attr_get(
>  	struct inode		*inode,
>  	unsigned char		*name,
> @@ -379,7 +379,7 @@ xfs_attrmulti_attr_get(
>  	return error;
>  }
>  
> -int
> +static int
>  xfs_attrmulti_attr_set(
>  	struct inode		*inode,
>  	unsigned char		*name,
> @@ -410,6 +410,51 @@ xfs_attrmulti_attr_set(
>  	return error;
>  }
>  
> +int
> +xfs_ioc_attrmulti_one(
> +	struct file		*parfilp,
> +	struct inode		*inode,
> +	uint32_t		opcode,
> +	void __user		*uname,
> +	void __user		*value,
> +	uint32_t		*len,
> +	uint32_t		flags)

That's a lot of arguments.  Any chance you could change the ioctl32
handler to convert the compat_xfs_attr_multiop to a xfs_attr_multiop and
pass that into this function?

(I'm not passionate one way or another, I just don't like 7 argument
functions when most of them come from the same struct.)

--D

> +{
> +	unsigned char		*name;
> +	int			error;
> +
> +	if ((flags & ATTR_ROOT) && (flags & ATTR_SECURE))
> +		return -EINVAL;
> +	flags &= ~ATTR_KERNEL_FLAGS;
> +
> +	name = strndup_user(uname, MAXNAMELEN);
> +	if (IS_ERR(name))
> +		return PTR_ERR(name);
> +
> +	switch (opcode) {
> +	case ATTR_OP_GET:
> +		error = xfs_attrmulti_attr_get(inode, name, value, len, flags);
> +		break;
> +	case ATTR_OP_REMOVE:
> +		value = NULL;
> +		*len = 0;
> +		/*FALLTHRU*/
> +	case ATTR_OP_SET:
> +		error = mnt_want_write_file(parfilp);
> +		if (error)
> +			break;
> +		error = xfs_attrmulti_attr_set(inode, name, value, *len, flags);
> +		mnt_drop_write_file(parfilp);
> +		break;
> +	default:
> +		error = -EINVAL;
> +		break;
> +	}
> +
> +	kfree(name);
> +	return error;
> +}
> +
>  STATIC int
>  xfs_attrmulti_by_handle(
>  	struct file		*parfilp,
> @@ -420,7 +465,6 @@ xfs_attrmulti_by_handle(
>  	xfs_fsop_attrmulti_handlereq_t am_hreq;
>  	struct dentry		*dentry;
>  	unsigned int		i, size;
> -	unsigned char		*attr_name;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -448,49 +492,10 @@ xfs_attrmulti_by_handle(
>  
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
> -		if ((ops[i].am_flags & ATTR_ROOT) &&
> -		    (ops[i].am_flags & ATTR_SECURE)) {
> -			ops[i].am_error = -EINVAL;
> -			continue;
> -		}
> -		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
> -
> -		attr_name = strndup_user(ops[i].am_attrname, MAXNAMELEN);
> -		if (IS_ERR(attr_name)) {
> -			ops[i].am_error = PTR_ERR(attr_name);
> -			break;
> -		}
> -
> -		switch (ops[i].am_opcode) {
> -		case ATTR_OP_GET:
> -			ops[i].am_error = xfs_attrmulti_attr_get(
> -					d_inode(dentry), attr_name,
> -					ops[i].am_attrvalue, &ops[i].am_length,
> -					ops[i].am_flags);
> -			break;
> -		case ATTR_OP_SET:
> -			ops[i].am_error = mnt_want_write_file(parfilp);
> -			if (ops[i].am_error)
> -				break;
> -			ops[i].am_error = xfs_attrmulti_attr_set(
> -					d_inode(dentry), attr_name,
> -					ops[i].am_attrvalue, ops[i].am_length,
> -					ops[i].am_flags);
> -			mnt_drop_write_file(parfilp);
> -			break;
> -		case ATTR_OP_REMOVE:
> -			ops[i].am_error = mnt_want_write_file(parfilp);
> -			if (ops[i].am_error)
> -				break;
> -			ops[i].am_error = xfs_attrmulti_attr_set(
> -					d_inode(dentry), attr_name, NULL, 0,
> -					ops[i].am_flags);
> -			mnt_drop_write_file(parfilp);
> -			break;
> -		default:
> -			ops[i].am_error = -EINVAL;
> -		}
> -		kfree(attr_name);
> +		ops[i].am_error = xfs_ioc_attrmulti_one(parfilp,
> +				d_inode(dentry), ops[i].am_opcode,
> +				ops[i].am_attrname, ops[i].am_attrvalue,
> +				&ops[i].am_length, ops[i].am_flags);
>  	}
>  
>  	if (copy_to_user(am_hreq.ops, ops, size))
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index 819504df00ae..bb50cb3dc61f 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -30,21 +30,9 @@ xfs_readlink_by_handle(
>  	struct file		*parfilp,
>  	xfs_fsop_handlereq_t	*hreq);
>  
> -extern int
> -xfs_attrmulti_attr_get(
> -	struct inode		*inode,
> -	unsigned char		*name,
> -	unsigned char		__user *ubuf,
> -	uint32_t		*len,
> -	uint32_t		flags);
> -
> -extern int
> -xfs_attrmulti_attr_set(
> -	struct inode		*inode,
> -	unsigned char		*name,
> -	const unsigned char	__user *ubuf,
> -	uint32_t		len,
> -	uint32_t		flags);
> +int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
> +		uint32_t opcode, void __user *uname, void __user *value,
> +		uint32_t *len, uint32_t flags);
>  
>  extern struct dentry *
>  xfs_handle_to_dentry(
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index e6a7f619a54c..ee428ddf51e5 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -416,7 +416,6 @@ xfs_compat_attrmulti_by_handle(
>  	compat_xfs_fsop_attrmulti_handlereq_t	am_hreq;
>  	struct dentry				*dentry;
>  	unsigned int				i, size;
> -	unsigned char				*attr_name;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -445,50 +444,11 @@ xfs_compat_attrmulti_by_handle(
>  
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
> -		if ((ops[i].am_flags & ATTR_ROOT) &&
> -		    (ops[i].am_flags & ATTR_SECURE)) {
> -			ops[i].am_error = -EINVAL;
> -			continue;
> -		}
> -		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
> -
> -		attr_name = strndup_user(compat_ptr(ops[i].am_attrname),
> -				MAXNAMELEN);
> -		if (IS_ERR(attr_name)) {
> -			ops[i].am_error = PTR_ERR(attr_name);
> -			break;
> -		}
> -
> -		switch (ops[i].am_opcode) {
> -		case ATTR_OP_GET:
> -			ops[i].am_error = xfs_attrmulti_attr_get(
> -					d_inode(dentry), attr_name,
> -					compat_ptr(ops[i].am_attrvalue),
> -					&ops[i].am_length, ops[i].am_flags);
> -			break;
> -		case ATTR_OP_SET:
> -			ops[i].am_error = mnt_want_write_file(parfilp);
> -			if (ops[i].am_error)
> -				break;
> -			ops[i].am_error = xfs_attrmulti_attr_set(
> -					d_inode(dentry), attr_name,
> -					compat_ptr(ops[i].am_attrvalue),
> -					ops[i].am_length, ops[i].am_flags);
> -			mnt_drop_write_file(parfilp);
> -			break;
> -		case ATTR_OP_REMOVE:
> -			ops[i].am_error = mnt_want_write_file(parfilp);
> -			if (ops[i].am_error)
> -				break;
> -			ops[i].am_error = xfs_attrmulti_attr_set(
> -					d_inode(dentry), attr_name, NULL, 0,
> -					ops[i].am_flags);
> -			mnt_drop_write_file(parfilp);
> -			break;
> -		default:
> -			ops[i].am_error = -EINVAL;
> -		}
> -		kfree(attr_name);
> +		ops[i].am_error = xfs_ioc_attrmulti_one(parfilp,
> +				d_inode(dentry), ops[i].am_opcode,
> +				compat_ptr(ops[i].am_attrname),
> +				compat_ptr(ops[i].am_attrvalue),
> +				&ops[i].am_length, ops[i].am_flags);
>  	}
>  
>  	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
> -- 
> 2.24.1
> 
