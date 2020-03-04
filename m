Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC96C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 04:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74264214D8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 04:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCDE45 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 23:56:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726094AbgCDE45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 23:56:57 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0244tfXa113522
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 23:56:56 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yhpwmg2uw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 23:56:55 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 4 Mar 2020 04:56:54 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 4 Mar 2020 04:56:52 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0244upgd48889968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Mar 2020 04:56:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDCD152052;
        Wed,  4 Mar 2020 04:56:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.41.86])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1726E5204F;
        Wed,  4 Mar 2020 04:56:50 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 18/19] xfs: Add remote block helper functions
Date:   Wed, 04 Mar 2020 10:29:46 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-19-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20030404-0016-0000-0000-000002ECF72F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030404-0017-0000-0000-0000335041D5
Message-Id: <4227347.qSKJyTc33i@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_08:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=1
 mlxlogscore=999 phishscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040035
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:36 AM Allison Collins wrote: 
> This patch adds two new helper functions xfs_attr_store_rmt_blk and
> xfs_attr_restore_rmt_blk. These two helpers assist to remove redunant code
> associated with storing and retrieving remote blocks during the attr set operations.
>

The changes look good to me,

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 48 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b9728d1..f88be36 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -786,6 +786,30 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * External routines when attribute list is one block
>   *========================================================================*/
>  
> +/* Store info about a remote block */
> +STATIC void
> +xfs_attr_store_rmt_blk(
> +	struct xfs_da_args	*args)
> +{
> +	args->blkno2 = args->blkno;
> +	args->index2 = args->index;
> +	args->rmtblkno2 = args->rmtblkno;
> +	args->rmtblkcnt2 = args->rmtblkcnt;
> +	args->rmtvaluelen2 = args->rmtvaluelen;
> +}
> +
> +/* Set stored info about a remote block */
> +STATIC void
> +xfs_attr_restore_rmt_blk(
> +	struct xfs_da_args	*args)
> +{
> +	args->blkno = args->blkno2;
> +	args->index = args->index2;
> +	args->rmtblkno = args->rmtblkno2;
> +	args->rmtblkcnt = args->rmtblkcnt2;
> +	args->rmtvaluelen = args->rmtvaluelen2;
> +}
> +
>  /*
>   * Tries to add an attribute to an inode in leaf form
>   *
> @@ -824,11 +848,7 @@ xfs_attr_leaf_try_add(
>  
>  		/* save the attribute state for later removal*/
>  		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
> -		args->blkno2 = args->blkno;		/* set 2nd entry info*/
> -		args->index2 = args->index;
> -		args->rmtblkno2 = args->rmtblkno;
> -		args->rmtblkcnt2 = args->rmtblkcnt;
> -		args->rmtvaluelen2 = args->rmtvaluelen;
> +		xfs_attr_store_rmt_blk(args);
>  
>  		/*
>  		 * clear the remote attr state now that it is saved so that the
> @@ -939,11 +959,7 @@ xfs_attr_leaf_addname(
>  		 * Dismantle the "old" attribute/value pair by removing
>  		 * a "remote" value (if it exists).
>  		 */
> -		args->index = args->index2;
> -		args->blkno = args->blkno2;
> -		args->rmtblkno = args->rmtblkno2;
> -		args->rmtblkcnt = args->rmtblkcnt2;
> -		args->rmtvaluelen = args->rmtvaluelen2;
> +		xfs_attr_restore_rmt_blk(args);
>  
>  		args->dac.dela_state = XFS_DAS_FLIP_LFLAG;
>  		return -EAGAIN;
> @@ -1189,11 +1205,7 @@ xfs_attr_node_addname(
>  
>  		/* save the attribute state for later removal*/
>  		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
> -		args->blkno2 = args->blkno;		/* set 2nd entry info*/
> -		args->index2 = args->index;
> -		args->rmtblkno2 = args->rmtblkno;
> -		args->rmtblkcnt2 = args->rmtblkcnt;
> -		args->rmtvaluelen2 = args->rmtvaluelen;
> +		xfs_attr_store_rmt_blk(args);
>  
>  		/*
>  		 * clear the remote attr state now that it is saved so that the
> @@ -1306,11 +1318,7 @@ xfs_attr_node_addname(
>  		 * Dismantle the "old" attribute/value pair by removing
>  		 * a "remote" value (if it exists).
>  		 */
> -		args->index = args->index2;
> -		args->blkno = args->blkno2;
> -		args->rmtblkno = args->rmtblkno2;
> -		args->rmtblkcnt = args->rmtblkcnt2;
> -		args->rmtvaluelen = args->rmtvaluelen2;
> +		xfs_attr_restore_rmt_blk(args);
>  
>  		/*
>  		 * Commit the flag value change and start the next trans in
> 


-- 
chandan



