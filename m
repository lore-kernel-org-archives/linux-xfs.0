Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDACAC35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87D5624650
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wR6Ztjyn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgBUPRe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:17:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39310 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgBUPRe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:17:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFHStx017535;
        Fri, 21 Feb 2020 15:17:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JoVX1iIwD1T6HJHxpL4eDWctkBBs2eXJ0AleEHWRLwg=;
 b=wR6ZtjynJko0cGpLNqqbIJU6lP0yhlZqk3iFzU+hL91zILSOSdhzoNIrTD79PEK9GCtD
 tPjrdmWAm62kkvp/cy9znCRACodHvs2nbQxzmhKWhZiHXu5jvT9dlABvnx9nRiglHaD2
 Z2h4glyHQKnnX6dtZ7LA94eSnZpLl8NxOIEyMiib+t3GxUMfxlLhcfVW5acC/1uWecSN
 mV7KLsM9Lhok3c3xYjQxfdW2P5l9npyEx5929FcU/CAsCDtknvyB7J7/DWrdo/kdd2xH
 Uqy1oOI90+aYhGKcRWpi6pa+471e+fUxch/Xf0/jw1qvAlRIhOivQ5AOLnTprS0MXxDn EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2y8udks449-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:17:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFBtdq133797;
        Fri, 21 Feb 2020 15:17:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8udndew2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:17:29 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01LFHSTD003302;
        Fri, 21 Feb 2020 15:17:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 07:17:28 -0800
Date:   Fri, 21 Feb 2020 07:17:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 06/31] xfs: factor out a helper for a single
 XFS_IOC_ATTRMULTI_BY_HANDLE op
Message-ID: <20200221151727.GI9506@magnolia>
References: <20200221141154.476496-1-hch@lst.de>
 <20200221141154.476496-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221141154.476496-7-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:11:29AM -0800, Christoph Hellwig wrote:
> Add a new helper to handle a single attr multi ioctl operation that
> can be shared between the native and compat ioctl implementation.
> 
> There is a slight change in heavior in that we don't break out of the
> loop when copying in the attribute name fails.  The previous behavior
> was rather inconsistent here as it continued for any other kind of
> error, and that we don't clear the flags in the structure returned
> to userspace, a behavior only introduced as a bug fix in the last
> merge window.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Seems pretty straightforward,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c   | 97 +++++++++++++++++++++++---------------------
>  fs/xfs/xfs_ioctl.h   | 18 ++------
>  fs/xfs/xfs_ioctl32.c | 50 +++--------------------
>  3 files changed, 59 insertions(+), 106 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index bb490a954c0b..b17458c8947e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -349,7 +349,7 @@ xfs_attrlist_by_handle(
>  	return error;
>  }
>  
> -int
> +static int
>  xfs_attrmulti_attr_get(
>  	struct inode		*inode,
>  	unsigned char		*name,
> @@ -381,7 +381,7 @@ xfs_attrmulti_attr_get(
>  	return error;
>  }
>  
> -int
> +static int
>  xfs_attrmulti_attr_set(
>  	struct inode		*inode,
>  	unsigned char		*name,
> @@ -412,6 +412,51 @@ xfs_attrmulti_attr_set(
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
> +		/* fall through */
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
> @@ -422,7 +467,6 @@ xfs_attrmulti_by_handle(
>  	xfs_fsop_attrmulti_handlereq_t am_hreq;
>  	struct dentry		*dentry;
>  	unsigned int		i, size;
> -	unsigned char		*attr_name;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -450,49 +494,10 @@ xfs_attrmulti_by_handle(
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
> index 936c2f62fb6c..e1daf095c585 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -418,7 +418,6 @@ xfs_compat_attrmulti_by_handle(
>  	compat_xfs_fsop_attrmulti_handlereq_t	am_hreq;
>  	struct dentry				*dentry;
>  	unsigned int				i, size;
> -	unsigned char				*attr_name;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -447,50 +446,11 @@ xfs_compat_attrmulti_by_handle(
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
