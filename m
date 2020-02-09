Return-Path: <SRS0=+eDc=35=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD50C35250
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 08:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EBC920733
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 08:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgBIIVw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 03:21:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbgBIIVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Feb 2020 03:21:52 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0198IpQ3116648
        for <linux-xfs@vger.kernel.org>; Sun, 9 Feb 2020 03:21:51 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1u2cj7x3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 09 Feb 2020 03:21:51 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 9 Feb 2020 08:21:48 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 9 Feb 2020 08:21:46 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0198Lj5144499088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Feb 2020 08:21:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 751F442047;
        Sun,  9 Feb 2020 08:21:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E78242041;
        Sun,  9 Feb 2020 08:21:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.59.174])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Feb 2020 08:21:44 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 24/30] xfs: lift buffer allocation into xfs_ioc_attr_list
Date:   Sun, 09 Feb 2020 13:54:30 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-25-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-25-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020908-4275-0000-0000-0000039F69C7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020908-4276-0000-0000-000038B39BD5
Message-Id: <1917197.rWHQBRpNhb@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-09_02:2020-02-07,2020-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=5
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002090070
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:33 PM Christoph Hellwig wrote: 
> Lift the buffer allocation from the two callers into xfs_ioc_attr_list.
>

Logically, code flow remains the same.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c   | 39 ++++++++++++++++-----------------------
>  fs/xfs/xfs_ioctl.h   |  2 +-
>  fs/xfs/xfs_ioctl32.c | 22 +++++-----------------
>  3 files changed, 22 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index c8814808a551..cdb3800dfcef 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -351,13 +351,14 @@ xfs_ioc_attr_put_listent(
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
> 


-- 
chandan



