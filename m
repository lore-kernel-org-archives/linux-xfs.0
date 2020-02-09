Return-Path: <SRS0=+eDc=35=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E595FC35250
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 08:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0972081E
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 08:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgBIIBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 03:01:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgBIIBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Feb 2020 03:01:00 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01980LrK020791
        for <linux-xfs@vger.kernel.org>; Sun, 9 Feb 2020 03:00:59 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1u54scta-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 09 Feb 2020 03:00:58 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 9 Feb 2020 08:00:56 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 9 Feb 2020 08:00:54 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01980rS755116020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Feb 2020 08:00:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 648CC42045;
        Sun,  9 Feb 2020 08:00:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 405A54203F;
        Sun,  9 Feb 2020 08:00:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.59.174])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Feb 2020 08:00:52 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 23/30] xfs: lift common checks into xfs_ioc_attr_list
Date:   Sun, 09 Feb 2020 13:33:38 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-24-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-24-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020908-0028-0000-0000-000003D8DAEF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020908-0029-0000-0000-0000249D4331
Message-Id: <1812060.WSnF9zcqM7@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-09_02:2020-02-07,2020-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002090067
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:33 PM Christoph Hellwig wrote: 
> Lift the flags and bufsize checks from both callers into the common code
> in xfs_ioc_attr_list.
>

Logically, code flow remains the same.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c   | 23 ++++++++++++-----------
>  fs/xfs/xfs_ioctl32.c | 11 -----------
>  2 files changed, 12 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0f9326bc055c..c8814808a551 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -360,6 +360,18 @@ xfs_ioc_attr_list(
>  	struct xfs_attrlist		*alist;
>  	int				error;
> 
> +	if (bufsize < sizeof(struct xfs_attrlist) ||
> +	    bufsize > XFS_XATTR_LIST_MAX)
> +		return -EINVAL;
> +
> +	/*
> +	 * Reject flags, only allow namespaces.
> +	 */
> +	if (flags & ~(ATTR_ROOT | ATTR_SECURE))
> +		return -EINVAL;
> +	if (flags == (ATTR_ROOT | ATTR_SECURE))
> +		return -EINVAL;
> +
>  	/*
>  	 * Validate the cursor.
>  	 */
> @@ -414,17 +426,6 @@ xfs_attrlist_by_handle(
>  		return -EPERM;
>  	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
>  		return -EFAULT;
> -	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
> -	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
> -		return -EINVAL;
> -
> -	/*
> -	 * Reject flags, only allow namespaces.
> -	 */
> -	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
> -		return -EINVAL;
> -	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
> -		return -EINVAL;
> 
>  	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
>  	if (IS_ERR(dentry))
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 10ea0222954c..840d17951407 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -366,17 +366,6 @@ xfs_compat_attrlist_by_handle(
>  	if (copy_from_user(&al_hreq, arg,
>  			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
>  		return -EFAULT;
> -	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
> -	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
> -		return -EINVAL;
> -
> -	/*
> -	 * Reject flags, only allow namespaces.
> -	 */
> -	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
> -		return -EINVAL;
> -	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
> -		return -EINVAL;
> 
>  	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
>  	if (IS_ERR(dentry))
> 


-- 
chandan



