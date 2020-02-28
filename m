Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA5AC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B3324677
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgB1NMT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:12:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19766 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbgB1NMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 08:12:18 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SCwmYB038914
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2020 08:12:17 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yepwj6197-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2020 08:12:16 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 28 Feb 2020 13:12:14 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 28 Feb 2020 13:12:13 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01SDCC4a20971690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 13:12:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 766184C052;
        Fri, 28 Feb 2020 13:12:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A74444C040;
        Fri, 28 Feb 2020 13:12:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.88.173])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Feb 2020 13:12:11 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 08/19] xfs: Refactor xfs_attr_try_sf_addname
Date:   Fri, 28 Feb 2020 13:12:27 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-9-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022813-4275-0000-0000-000003A65919
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022813-4276-0000-0000-000038BAE833
Message-Id: <1889824.mfX55q8Ynv@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_04:2020-02-26,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=3 malwarescore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002280106
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:36 AM Allison Collins wrote:
> To help pre-simplify xfs_attr_set_args, we need to hoist transacation handling up,
> while modularizing the adjacent code down into helpers. In this patch, hoist the
> commit in xfs_attr_try_sf_addname up into the calling function, and also pull the
> attr list creation down.
>

I don't see any logical errors.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b2f0780..71298b9 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -227,8 +227,13 @@ xfs_attr_try_sf_addname(
>  	struct xfs_da_args	*args)
>  {
>  
> -	struct xfs_mount	*mp = dp->i_mount;
> -	int			error, error2;
> +	int			error;
> +
> +	/*
> +	 * Build initial attribute list (if required).
> +	 */
> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
> +		xfs_attr_shortform_create(args);
>  
>  	error = xfs_attr_shortform_addname(args);
>  	if (error == -ENOSPC)
> @@ -241,12 +246,10 @@ xfs_attr_try_sf_addname(
>  	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>  
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args->trans);
>  
> -	error2 = xfs_trans_commit(args->trans);
> -	args->trans = NULL;
> -	return error ? error : error2;
> +	return error;
>  }
>  
>  /*
> @@ -258,7 +261,7 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error;
> +	int			error, error2 = 0;
>  
>  	/*
>  	 * If the attribute list is non-existent or a shortform list,
> @@ -269,17 +272,14 @@ xfs_attr_set_args(
>  	     dp->i_d.di_anextents == 0)) {
>  
>  		/*
> -		 * Build initial attribute list (if required).
> -		 */
> -		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
> -			xfs_attr_shortform_create(args);
> -
> -		/*
>  		 * Try to add the attr to the attribute list in the inode.
>  		 */
>  		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC)
> -			return error;
> +		if (error != -ENOSPC) {
> +			error2 = xfs_trans_commit(args->trans);
> +			args->trans = NULL;
> +			return error ? error : error2;
> +		}
>  
>  		/*
>  		 * It won't fit in the shortform, transform to a leaf block.
> 


-- 
chandan



