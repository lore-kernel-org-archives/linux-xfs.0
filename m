Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D95FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AC6A2178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V7f5B4xm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfKHGsM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 01:48:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfKHGsM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 01:48:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA86iV0T056552;
        Fri, 8 Nov 2019 06:48:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WmzESLXrPEUTlklaM82pA6PsC/Sus7KhnfLdY+Chags=;
 b=V7f5B4xm0JrpwKnfwLmsnBX9HFkcperA8zGkoz1uCawJbMEFFks5VYJ80v72yW4+fY0r
 AEd+SOMMkN/PRwKpHeBMmFReYBjOiJ1Zy8HpmXHRDPKxKf7iZHCgxpb353GDha3al8lD
 NuaiEjvVHhemtxkje7CW5DPF5eLxBb/zV7iH4VCsyxTvaWv0QUc3sts42edO3fWOrQms
 3BO1+EW3hAc1OD28B7ACT3jt/NrVn411gSZVKlW/foX/V5blM/ZxgPaOnsklyu+Q096n
 W6AG/C2o4d1A3sRbFS6KQTJwsBekL6uZfkdX3XJMQd18rtjCD2waJE/6IarIAOhQTWIn wQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w1bb2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 06:48:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA86hm9k014815;
        Fri, 8 Nov 2019 06:48:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w4k30eu5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 06:48:06 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA86m4et024363;
        Fri, 8 Nov 2019 06:48:04 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 22:48:04 -0800
Date:   Thu, 7 Nov 2019 22:48:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove XFS_IOC_FSSETDM and XFS_IOC_FSSETDM_BY_HANDLE
Message-ID: <20191108064801.GM6219@magnolia>
References: <20191108052303.15052-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108052303.15052-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080066
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 06:23:03AM +0100, Christoph Hellwig wrote:
> Thes ioctls set DMAPI specific flags in the on-disk inode, but there is
> no way to actually ever query those flags.  The only known user is
> xfsrestore with the -D option, which is documented to be only useful
> inside a DMAPI enviroment, which isn't supported by upstream XFS.

Hmm, shouldn't we deprecate this at least for one or two releases?

Even if it's functionally pointless...

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c   | 94 --------------------------------------------
>  fs/xfs/xfs_ioctl.h   |  6 ---
>  fs/xfs/xfs_ioctl32.c | 40 -------------------
>  fs/xfs/xfs_ioctl32.h |  9 -----
>  4 files changed, 149 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 287f83eb791f..a979d730203a 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -291,82 +291,6 @@ xfs_readlink_by_handle(
>  	return error;
>  }
>  
> -int
> -xfs_set_dmattrs(
> -	xfs_inode_t     *ip,
> -	uint		evmask,
> -	uint16_t	state)
> -{
> -	xfs_mount_t	*mp = ip->i_mount;
> -	xfs_trans_t	*tp;
> -	int		error;
> -
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -
> -	if (XFS_FORCED_SHUTDOWN(mp))
> -		return -EIO;
> -
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
> -	if (error)
> -		return error;
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -
> -	ip->i_d.di_dmevmask = evmask;
> -	ip->i_d.di_dmstate  = state;
> -
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	error = xfs_trans_commit(tp);
> -
> -	return error;
> -}
> -
> -STATIC int
> -xfs_fssetdm_by_handle(
> -	struct file		*parfilp,
> -	void			__user *arg)
> -{
> -	int			error;
> -	struct fsdmidata	fsd;
> -	xfs_fsop_setdm_handlereq_t dmhreq;
> -	struct dentry		*dentry;
> -
> -	if (!capable(CAP_MKNOD))
> -		return -EPERM;
> -	if (copy_from_user(&dmhreq, arg, sizeof(xfs_fsop_setdm_handlereq_t)))
> -		return -EFAULT;
> -
> -	error = mnt_want_write_file(parfilp);
> -	if (error)
> -		return error;
> -
> -	dentry = xfs_handlereq_to_dentry(parfilp, &dmhreq.hreq);
> -	if (IS_ERR(dentry)) {
> -		mnt_drop_write_file(parfilp);
> -		return PTR_ERR(dentry);
> -	}
> -
> -	if (IS_IMMUTABLE(d_inode(dentry)) || IS_APPEND(d_inode(dentry))) {
> -		error = -EPERM;
> -		goto out;
> -	}
> -
> -	if (copy_from_user(&fsd, dmhreq.data, sizeof(fsd))) {
> -		error = -EFAULT;
> -		goto out;
> -	}
> -
> -	error = xfs_set_dmattrs(XFS_I(d_inode(dentry)), fsd.fsd_dmevmask,
> -				 fsd.fsd_dmstate);
> -
> - out:
> -	mnt_drop_write_file(parfilp);
> -	dput(dentry);
> -	return error;
> -}
> -
>  STATIC int
>  xfs_attrlist_by_handle(
>  	struct file		*parfilp,
> @@ -2126,22 +2050,6 @@ xfs_file_ioctl(
>  	case XFS_IOC_SETXFLAGS:
>  		return xfs_ioc_setxflags(ip, filp, arg);
>  
> -	case XFS_IOC_FSSETDM: {
> -		struct fsdmidata	dmi;
> -
> -		if (copy_from_user(&dmi, arg, sizeof(dmi)))
> -			return -EFAULT;
> -
> -		error = mnt_want_write_file(filp);
> -		if (error)
> -			return error;
> -
> -		error = xfs_set_dmattrs(ip, dmi.fsd_dmevmask,
> -				dmi.fsd_dmstate);
> -		mnt_drop_write_file(filp);
> -		return error;
> -	}
> -
>  	case XFS_IOC_GETBMAP:
>  	case XFS_IOC_GETBMAPA:
>  	case XFS_IOC_GETBMAPX:
> @@ -2169,8 +2077,6 @@ xfs_file_ioctl(
>  			return -EFAULT;
>  		return xfs_open_by_handle(filp, &hreq);
>  	}
> -	case XFS_IOC_FSSETDM_BY_HANDLE:
> -		return xfs_fssetdm_by_handle(filp, arg);
>  
>  	case XFS_IOC_READLINK_BY_HANDLE: {
>  		xfs_fsop_handlereq_t	hreq;
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index 25ef178cbb74..420bd95dc326 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -70,12 +70,6 @@ xfs_file_compat_ioctl(
>  	unsigned int		cmd,
>  	unsigned long		arg);
>  
> -extern int
> -xfs_set_dmattrs(
> -	struct xfs_inode	*ip,
> -	uint			evmask,
> -	uint16_t		state);
> -
>  struct xfs_ibulk;
>  struct xfs_bstat;
>  struct xfs_inogrp;
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 3c0d518e1039..c4c4f09113d3 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -500,44 +500,6 @@ xfs_compat_attrmulti_by_handle(
>  	return error;
>  }
>  
> -STATIC int
> -xfs_compat_fssetdm_by_handle(
> -	struct file		*parfilp,
> -	void			__user *arg)
> -{
> -	int			error;
> -	struct fsdmidata	fsd;
> -	compat_xfs_fsop_setdm_handlereq_t dmhreq;
> -	struct dentry		*dentry;
> -
> -	if (!capable(CAP_MKNOD))
> -		return -EPERM;
> -	if (copy_from_user(&dmhreq, arg,
> -			   sizeof(compat_xfs_fsop_setdm_handlereq_t)))
> -		return -EFAULT;
> -
> -	dentry = xfs_compat_handlereq_to_dentry(parfilp, &dmhreq.hreq);
> -	if (IS_ERR(dentry))
> -		return PTR_ERR(dentry);
> -
> -	if (IS_IMMUTABLE(d_inode(dentry)) || IS_APPEND(d_inode(dentry))) {
> -		error = -EPERM;
> -		goto out;
> -	}
> -
> -	if (copy_from_user(&fsd, compat_ptr(dmhreq.data), sizeof(fsd))) {
> -		error = -EFAULT;
> -		goto out;
> -	}
> -
> -	error = xfs_set_dmattrs(XFS_I(d_inode(dentry)), fsd.fsd_dmevmask,
> -				 fsd.fsd_dmstate);
> -
> -out:
> -	dput(dentry);
> -	return error;
> -}
> -
>  long
>  xfs_file_compat_ioctl(
>  	struct file		*filp,
> @@ -646,8 +608,6 @@ xfs_file_compat_ioctl(
>  		return xfs_compat_attrlist_by_handle(filp, arg);
>  	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:
>  		return xfs_compat_attrmulti_by_handle(filp, arg);
> -	case XFS_IOC_FSSETDM_BY_HANDLE_32:
> -		return xfs_compat_fssetdm_by_handle(filp, arg);
>  	default:
>  		/* try the native version */
>  		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
> diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
> index 7985344d3aa6..7cbd6a0ee3e9 100644
> --- a/fs/xfs/xfs_ioctl32.h
> +++ b/fs/xfs/xfs_ioctl32.h
> @@ -143,15 +143,6 @@ typedef struct compat_xfs_fsop_attrmulti_handlereq {
>  #define XFS_IOC_ATTRMULTI_BY_HANDLE_32 \
>  	_IOW('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
>  
> -typedef struct compat_xfs_fsop_setdm_handlereq {
> -	struct compat_xfs_fsop_handlereq hreq;	/* handle information   */
> -	/* ptr to struct fsdmidata */
> -	compat_uptr_t			data;	/* DMAPI data   */
> -} compat_xfs_fsop_setdm_handlereq_t;
> -
> -#define XFS_IOC_FSSETDM_BY_HANDLE_32 \
> -	_IOW('X', 121, struct compat_xfs_fsop_setdm_handlereq)
> -
>  #ifdef BROKEN_X86_ALIGNMENT
>  /* on ia32 l_start is on a 32-bit boundary */
>  typedef struct compat_xfs_flock64 {
> -- 
> 2.20.1
> 
