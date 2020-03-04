Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B39C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 04:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D7A320838
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 04:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgCDE1P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 23:27:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19494 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgCDE1O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 23:27:14 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0244L04H053760
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 23:27:13 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfknbg438-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 23:27:13 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 4 Mar 2020 04:27:12 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 4 Mar 2020 04:27:09 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0244R8UA48562340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Mar 2020 04:27:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A62C9AE055;
        Wed,  4 Mar 2020 04:27:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3D3BAE04D;
        Wed,  4 Mar 2020 04:27:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.41.86])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Mar 2020 04:27:07 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 16/19] xfs: Simplify xfs_attr_set_iter
Date:   Wed, 04 Mar 2020 10:00:03 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-17-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-17-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20030404-0012-0000-0000-0000038CF4AA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030404-0013-0000-0000-000021C9AD6A
Message-Id: <11418238.YRoMbP1DLo@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_08:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=1 clxscore=1015 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040029
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:36 AM Allison Collins wrote: 
> Delayed attribute mechanics make frequent use of goto statements.  We can use this
> to further simplify xfs_attr_set_iter.  Because states tend to fall between if
> conditions, we can invert the if logic and jump to the goto. This helps to reduce
> indentation and simplify things.
>

I don't see any logical errors.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 42 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 30a16fe..dd935ff 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -254,6 +254,19 @@ xfs_attr_try_sf_addname(
>  }
>  
>  /*
> + * Check to see if the attr should be upgraded from non-existent or shortform to
> + * single-leaf-block attribute list.
> + */
> +static inline bool
> +xfs_attr_fmt_needs_update(
> +	struct xfs_inode    *dp)
> +{
> +	return dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> +	      (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> +	      dp->i_d.di_anextents == 0);
> +}
> +
> +/*
>   * Set the attribute specified in @args.
>   */
>  int
> @@ -342,40 +355,40 @@ xfs_attr_set_iter(
>  	}
>  
>  	/*
> -	 * If the attribute list is non-existent or a shortform list,
> -	 * upgrade it to a single-leaf-block attribute list.
> +	 * If the attribute list is already in leaf format, jump straight to
> +	 * leaf handling.  Otherwise, try to add the attribute to the shortform
> +	 * list; if there's no room then convert the list to leaf format and try
> +	 * again.
>  	 */
> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> +	if (!xfs_attr_fmt_needs_update(dp))
> +		goto add_leaf;
>  
> -		/*
> -		 * Try to add the attr to the attribute list in the inode.
> -		 */
> -		error = xfs_attr_try_sf_addname(dp, args);
> +	/*
> +	 * Try to add the attr to the attribute list in the inode.
> +	 */
> +	error = xfs_attr_try_sf_addname(dp, args);
>  
> -		/* Should only be 0, -EEXIST or ENOSPC */
> -		if (error != -ENOSPC)
> -			return error;
> +	/* Should only be 0, -EEXIST or ENOSPC */
> +	if (error != -ENOSPC)
> +		return error;
>  
> -		/*
> -		 * It won't fit in the shortform, transform to a leaf block.
> -		 * GROT: another possible req'mt for a double-split btree op.
> -		 */
> -		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> -		if (error)
> -			return error;
> +	/*
> +	 * It won't fit in the shortform, transform to a leaf block.
> +	 * GROT: another possible req'mt for a double-split btree op.
> +	 */
> +	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> +	if (error)
> +		return error;
>  
> -		/*
> -		 * Prevent the leaf buffer from being unlocked so that a
> -		 * concurrent AIL push cannot grab the half-baked leaf
> -		 * buffer and run into problems with the write verifier.
> -		 */
> -		xfs_trans_bhold(args->trans, *leaf_bp);
> -		args->dac.flags |= XFS_DAC_FINISH_TRANS;
> -		args->dac.dela_state = XFS_DAS_ADD_LEAF;
> -		return -EAGAIN;
> -	}
> +	/*
> +	 * Prevent the leaf buffer from being unlocked so that a
> +	 * concurrent AIL push cannot grab the half-baked leaf
> +	 * buffer and run into problems with the write verifier.
> +	 */
> +	xfs_trans_bhold(args->trans, *leaf_bp);
> +	args->dac.flags |= XFS_DAC_FINISH_TRANS;
> +	args->dac.dela_state = XFS_DAS_ADD_LEAF;
> +	return -EAGAIN;
>  
>  add_leaf:
>  
> 


-- 
chandan



