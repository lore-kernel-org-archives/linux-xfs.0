Return-Path: <SRS0=+eDc=35=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACADEC35250
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 07:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 809C120733
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 07:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgBIHuT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 02:50:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50904 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbgBIHuT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Feb 2020 02:50:19 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0197nKwc031620
        for <linux-xfs@vger.kernel.org>; Sun, 9 Feb 2020 02:50:18 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1uch0jae-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 09 Feb 2020 02:50:18 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 9 Feb 2020 07:50:16 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 9 Feb 2020 07:50:13 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0197oCit54329530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Feb 2020 07:50:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 132364C04E;
        Sun,  9 Feb 2020 07:50:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E22664C040;
        Sun,  9 Feb 2020 07:50:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.59.174])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Feb 2020 07:50:10 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 22/30] xfs: rename xfs_attr_list_int to xfs_attr_list
Date:   Sun, 09 Feb 2020 13:22:56 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-23-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-23-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020907-0028-0000-0000-000003D8DA60
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020907-0029-0000-0000-0000249D429F
Message-Id: <5256138.zvIhaygcVV@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-09_02:2020-02-07,2020-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=1 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002090064
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:33 PM Christoph Hellwig wrote: 
> The version taking the context structure is the main interface to list
> attributes, so drop the _int postfix.
>

Logical code flow remains the same.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.h | 4 ++--
>  fs/xfs/scrub/attr.c      | 4 ++--
>  fs/xfs/xfs_attr_list.c   | 6 +++---
>  fs/xfs/xfs_ioctl.c       | 2 +-
>  fs/xfs/xfs_xattr.c       | 2 +-
>  5 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 0e3c213f78ce..8d42f5782ff7 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -102,8 +102,8 @@ struct xfs_attr_list_context {
>   * Overall external interface routines.
>   */
>  int xfs_attr_inactive(struct xfs_inode *dp);
> -int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
> -int xfs_attr_list_int(struct xfs_attr_list_context *);
> +int xfs_attr_list_ilocked(struct xfs_attr_list_context *);
> +int xfs_attr_list(struct xfs_attr_list_context *);
>  int xfs_inode_hasattr(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 05537627211d..9e336d797616 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -98,7 +98,7 @@ struct xchk_xattr {
>  /*
>   * Check that an extended attribute key can be looked up by hash.
>   *
> - * We use the XFS attribute list iterator (i.e. xfs_attr_list_int_ilocked)
> + * We use the XFS attribute list iterator (i.e. xfs_attr_list_ilocked)
>   * to call this function for every attribute key in an inode.  Once
>   * we're here, we load the attribute value to see if any errors happen,
>   * or if we get more or less data than we expected.
> @@ -516,7 +516,7 @@ xchk_xattr(
>  	 * iteration, which doesn't really follow the usual buffer
>  	 * locking order.
>  	 */
> -	error = xfs_attr_list_int_ilocked(&sx.context);
> +	error = xfs_attr_list_ilocked(&sx.context);
>  	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
>  		goto out;
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 369ce1d3dd45..ea79219859a0 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -507,7 +507,7 @@ xfs_attr_leaf_list(
>  }
> 
>  int
> -xfs_attr_list_int_ilocked(
> +xfs_attr_list_ilocked(
>  	struct xfs_attr_list_context	*context)
>  {
>  	struct xfs_inode		*dp = context->dp;
> @@ -527,7 +527,7 @@ xfs_attr_list_int_ilocked(
>  }
> 
>  int
> -xfs_attr_list_int(
> +xfs_attr_list(
>  	struct xfs_attr_list_context	*context)
>  {
>  	struct xfs_inode		*dp = context->dp;
> @@ -540,7 +540,7 @@ xfs_attr_list_int(
>  		return -EIO;
> 
>  	lock_mode = xfs_ilock_attr_map_shared(dp);
> -	error = xfs_attr_list_int_ilocked(context);
> +	error = xfs_attr_list_ilocked(context);
>  	xfs_iunlock(dp, lock_mode);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 47c39895977b..0f9326bc055c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -393,7 +393,7 @@ xfs_ioc_attr_list(
>  	alist->al_more = 0;
>  	alist->al_offset[0] = context.bufsize;
> 
> -	error = xfs_attr_list_int(&context);
> +	error = xfs_attr_list(&context);
>  	ASSERT(error <= 0);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 8880dee3400f..e1951d2b878e 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -232,7 +232,7 @@ xfs_vn_listxattr(
>  	context.firstu = context.bufsize;
>  	context.put_listent = xfs_xattr_put_listent;
> 
> -	error = xfs_attr_list_int(&context);
> +	error = xfs_attr_list(&context);
>  	if (error)
>  		return error;
>  	if (context.count < 0)
> 


-- 
chandan



