Return-Path: <SRS0=0es8=33=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373C6C2D0B1
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Feb 2020 05:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E84E522314
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Feb 2020 05:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgBGFRk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 00:17:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726388AbgBGFRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Feb 2020 00:17:40 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0175EOkk049404
        for <linux-xfs@vger.kernel.org>; Fri, 7 Feb 2020 00:17:39 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0nnfutn1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 07 Feb 2020 00:17:39 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 7 Feb 2020 05:17:37 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 7 Feb 2020 05:17:35 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0175HYnK50790532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 05:17:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B00504204B;
        Fri,  7 Feb 2020 05:17:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D6E542049;
        Fri,  7 Feb 2020 05:17:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.35.73])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 05:17:33 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 06/30] xfs: factor out a helper for a single XFS_IOC_ATTRMULTI_BY_HANDLE op
Date:   Fri, 07 Feb 2020 10:50:19 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-7-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-7-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020705-4275-0000-0000-0000039EC371
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020705-4276-0000-0000-000038B2F277
Message-Id: <2577871.J7xU1ubE0c@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_04:2020-02-06,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 mlxlogscore=900 adultscore=0 priorityscore=1501
 bulkscore=0 suspectscore=1 spamscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070035
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> Add a new helper to handle a single attr multi ioctl operation that
> can be shared between the native and compat ioctl implementation.
> 
> There is a slight change in heavior in that we don't break out of the
> loop when copying in the attribute name fails.  The previous behavior
> was rather inconsistent here as it continued for any other kind of
> error.
>

Apart from "not breaking out of the for loop" change, The other changes
logically match with the code flow that existed earlier.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c   | 97 +++++++++++++++++++++++---------------------
>  fs/xfs/xfs_ioctl.h   | 18 ++------
>  fs/xfs/xfs_ioctl32.c | 50 +++--------------------
>  3 files changed, 59 insertions(+), 106 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index bb490a954c0b..cfdd80b4ea2d 100644
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
> 


-- 
chandan



