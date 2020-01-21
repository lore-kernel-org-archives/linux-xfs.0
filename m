Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A342C33CB6
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 17:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CF4822522
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 17:43:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FlZ6z0X/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgAURnx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 12:43:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgAURnx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 12:43:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LHdAIG165969;
        Tue, 21 Jan 2020 17:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=l2UhIu8x5ORkKumP3X0aExET1ylJErBp1JGpwNTPGTk=;
 b=FlZ6z0X/llNUYZ5745+hf6Es+Ph9HtH2IwCtvhIBMtthRKisU+leKGkuvamkFGx0rQMl
 99SbvjXmyHCiFvTf9379Jc99FeWqEeayEgk19m3kOpI68haoCmTSEPpjdp3HZughmcVN
 eLggBXl9Axk3EHK1hYZ2ceJFCIInb0c6ue8pVBQM//xETJn4N+a/nPgGAkxuaowyFJG7
 26NAjrvPsGmlnpKMlqs/ziJ6KkSFVCBwA3R6sC3AhzN+qkImsk9b5TXtFnQGbaR0ZJes
 6PNEHEbzqYcm9ZSVy0rSNNg8/lGCkK13IHBje7rNZuTs2Uhlf74FRS8CsvIYcmwp7REc og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseuesqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 17:43:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LHdLcF143202;
        Tue, 21 Jan 2020 17:41:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xnpef2u3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 17:41:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LHflTZ027899;
        Tue, 21 Jan 2020 17:41:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 09:41:47 -0800
Date:   Tue, 21 Jan 2020 09:41:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/29] xfs: merge xfs_attrmulti_attr_remove into
 xfs_attrmulti_attr_set
Message-ID: <20200121174145.GD8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:25AM +0100, Christoph Hellwig wrote:
> Merge the ioctl handlers just like the low-level xfs_attr_set function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c   | 34 ++++++++++------------------------
>  fs/xfs/xfs_ioctl.h   |  6 ------
>  fs/xfs/xfs_ioctl32.c |  4 ++--
>  3 files changed, 12 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8e35887f62fa..6bd0684a3528 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -387,18 +387,20 @@ xfs_attrmulti_attr_set(

Does /any/ of this have a testcase?  I couldn't find anywhere that uses
attrmulti, not even xfsdump.

Granted it's a straight conversion of code so AFAICT it won't be any
more broken than it probably already is <cough>...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
> @@ -408,22 +410,6 @@ xfs_attrmulti_attr_set(
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
> @@ -502,8 +488,8 @@ xfs_attrmulti_by_handle(
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
> index 769581a79c58..1092c66e48d6 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -486,8 +486,8 @@ xfs_compat_attrmulti_by_handle(
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
> -- 
> 2.24.1
> 
