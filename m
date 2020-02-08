Return-Path: <SRS0=5CkV=34=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25189C35250
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 11:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E806220715
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Feb 2020 11:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgBHLcq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Feb 2020 06:32:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17690 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726970AbgBHLcq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Feb 2020 06:32:46 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 018BIgW1072975
        for <linux-xfs@vger.kernel.org>; Sat, 8 Feb 2020 06:32:45 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tnstkab-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 08 Feb 2020 06:32:44 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sat, 8 Feb 2020 11:32:42 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 8 Feb 2020 11:32:41 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 018BWelS60293284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 8 Feb 2020 11:32:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ABEA11C050;
        Sat,  8 Feb 2020 11:32:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0497911C04A;
        Sat,  8 Feb 2020 11:32:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.68.130])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  8 Feb 2020 11:32:38 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/30] xfs: replace ATTR_KERNOTIME with XFS_DA_OP_NOTIME
Date:   Sat, 08 Feb 2020 17:05:25 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-17-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-17-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020811-0020-0000-0000-000003A8464B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020811-0021-0000-0000-000022001C1E
Message-Id: <9195667.EHZHh7sMLN@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_06:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002080092
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> op_flags with the XFS_DA_OP_* flags is the usual place for in-kernel
> only flags, so move the notime flag there.
>

The changes look good to me,
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c  | 4 ++--
>  fs/xfs/libxfs/xfs_attr.h  | 8 +-------
>  fs/xfs/libxfs/xfs_types.h | 2 ++
>  fs/xfs/scrub/attr.c       | 2 +-
>  fs/xfs/xfs_ioctl.c        | 1 -
>  5 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1382e51ef85e..3b1db2afb104 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -186,7 +186,7 @@ xfs_attr_try_sf_addname(
>  	 * Commit the shortform mods, and we're done.
>  	 * NOTE: this is also the error path (EEXIST, etc).
>  	 */
> -	if (!error && (args->flags & ATTR_KERNOTIME) == 0)
> +	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
> 
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
> @@ -389,7 +389,7 @@ xfs_attr_set(
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args->trans);
> 
> -	if ((args->flags & ATTR_KERNOTIME) == 0)
> +	if (!(args->op_flags & XFS_DA_OP_NOTIME))
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
> 
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index a6de050675c9..0f369399effd 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -33,19 +33,13 @@ struct xfs_attr_list_context;
>  #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
>  #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
> 
> -#define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
> -
> -#define ATTR_KERNEL_FLAGS \
> -	(ATTR_KERNOTIME)
> -
>  #define XFS_ATTR_FLAGS \
>  	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
>  	{ ATTR_ROOT,		"ROOT" }, \
>  	{ ATTR_TRUST,		"TRUST" }, \
>  	{ ATTR_SECURE,		"SECURE" }, \
>  	{ ATTR_CREATE,		"CREATE" }, \
> -	{ ATTR_REPLACE,		"REPLACE" }, \
> -	{ ATTR_KERNOTIME,	"KERNOTIME" }
> +	{ ATTR_REPLACE,		"REPLACE" }
> 
>  /*
>   * The maximum size (into the kernel or returned from the kernel) of an
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 3379ebc0c7c5..1594325d7742 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -223,6 +223,7 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
>  #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
>  #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
> +#define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
>  #define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
> 
>  #define XFS_DA_OP_FLAGS \
> @@ -231,6 +232,7 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> +	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
>  	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
> 
>  /*
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index f983c2b969e0..05537627211d 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -147,7 +147,7 @@ xchk_xattr_listent(
>  		return;
>  	}
> 
> -	args.flags = ATTR_KERNOTIME;
> +	args.op_flags = XFS_DA_OP_NOTIME;
>  	if (flags & XFS_ATTR_ROOT)
>  		args.flags |= ATTR_ROOT;
>  	else if (flags & XFS_ATTR_SECURE)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2da22595f828..dd1cb8c50518 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -436,7 +436,6 @@ xfs_ioc_attrmulti_one(
> 
>  	if ((flags & ATTR_ROOT) && (flags & ATTR_SECURE))
>  		return -EINVAL;
> -	flags &= ~ATTR_KERNEL_FLAGS;
> 
>  	name = strndup_user(uname, MAXNAMELEN);
>  	if (IS_ERR(name))
> 


-- 
chandan



