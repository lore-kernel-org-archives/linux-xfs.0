Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7951BC2D0B1
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 09:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53E8820838
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 09:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgBFJTQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 04:19:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgBFJTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 04:19:15 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0169E0UY108561
        for <linux-xfs@vger.kernel.org>; Thu, 6 Feb 2020 04:19:14 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhme6fsx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2020 04:19:14 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 6 Feb 2020 09:19:12 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 09:19:09 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0169IF1t47710520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 09:18:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79C9A52050;
        Thu,  6 Feb 2020 09:19:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.102.2.200])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 71D1F52051;
        Thu,  6 Feb 2020 09:19:07 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/30] xfs: merge xfs_attrmulti_attr_remove into xfs_attrmulti_attr_set
Date:   Thu, 06 Feb 2020 14:51:52 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-5-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-5-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020609-0012-0000-0000-00000384363B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020609-0013-0000-0000-000021C0A371
Message-Id: <2023754.vEBZo8tne2@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_06:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=1
 spamscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002060073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> Merge the ioctl handlers just like the low-level xfs_attr_set function.
>

The newly introduced changes match with the code flow that earlier existed
separately in xfs_attrmulti_attr_set() and xfs_attrmulti_attr_remove().

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c   | 34 ++++++++++------------------------
>  fs/xfs/xfs_ioctl.h   |  6 ------
>  fs/xfs/xfs_ioctl32.c |  4 ++--
>  3 files changed, 12 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 79c418888e9a..b806003caacd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -389,18 +389,20 @@ xfs_attrmulti_attr_set(
>  	uint32_t		len,
>  	uint32_t		flags)
>  {
> -	unsigned char		*kbuf;
> +	unsigned char		*kbuf = NULL;
>  	int			error;
>  	size_t			namelen;
> 
>  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  		return -EPERM;
> -	if (len > XFS_XATTR_SIZE_MAX)
> -		return -EINVAL;
> 
> -	kbuf = memdup_user(ubuf, len);
> -	if (IS_ERR(kbuf))
> -		return PTR_ERR(kbuf);
> +	if (ubuf) {
> +		if (len > XFS_XATTR_SIZE_MAX)
> +			return -EINVAL;
> +		kbuf = memdup_user(ubuf, len);
> +		if (IS_ERR(kbuf))
> +			return PTR_ERR(kbuf);
> +	}
> 
>  	namelen = strlen(name);
>  	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
> @@ -410,22 +412,6 @@ xfs_attrmulti_attr_set(
>  	return error;
>  }
> 
> -int
> -xfs_attrmulti_attr_remove(
> -	struct inode		*inode,
> -	unsigned char		*name,
> -	uint32_t		flags)
> -{
> -	int			error;
> -
> -	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> -		return -EPERM;
> -	error = xfs_attr_set(XFS_I(inode), name, strlen(name), NULL, 0, flags);
> -	if (!error)
> -		xfs_forget_acl(inode, name, flags);
> -	return error;
> -}
> -
>  STATIC int
>  xfs_attrmulti_by_handle(
>  	struct file		*parfilp,
> @@ -504,8 +490,8 @@ xfs_attrmulti_by_handle(
>  			ops[i].am_error = mnt_want_write_file(parfilp);
>  			if (ops[i].am_error)
>  				break;
> -			ops[i].am_error = xfs_attrmulti_attr_remove(
> -					d_inode(dentry), attr_name,
> +			ops[i].am_error = xfs_attrmulti_attr_set(
> +					d_inode(dentry), attr_name, NULL, 0,
>  					ops[i].am_flags);
>  			mnt_drop_write_file(parfilp);
>  			break;
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index 420bd95dc326..819504df00ae 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -46,12 +46,6 @@ xfs_attrmulti_attr_set(
>  	uint32_t		len,
>  	uint32_t		flags);
> 
> -extern int
> -xfs_attrmulti_attr_remove(
> -	struct inode		*inode,
> -	unsigned char		*name,
> -	uint32_t		flags);
> -
>  extern struct dentry *
>  xfs_handle_to_dentry(
>  	struct file		*parfilp,
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 9705172e5410..e085f304e539 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -488,8 +488,8 @@ xfs_compat_attrmulti_by_handle(
>  			ops[i].am_error = mnt_want_write_file(parfilp);
>  			if (ops[i].am_error)
>  				break;
> -			ops[i].am_error = xfs_attrmulti_attr_remove(
> -					d_inode(dentry), attr_name,
> +			ops[i].am_error = xfs_attrmulti_attr_set(
> +					d_inode(dentry), attr_name, NULL, 0,
>  					ops[i].am_flags);
>  			mnt_drop_write_file(parfilp);
>  			break;
> 


-- 
chandan



