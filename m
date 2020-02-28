Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AB9C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3FD324677
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgB1NMm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:12:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34316 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgB1NMm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 08:12:42 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SD2fbi066294
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2020 08:12:40 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yepy3mtxk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2020 08:12:40 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 28 Feb 2020 13:12:38 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 28 Feb 2020 13:12:35 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01SDCZ7q51576844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 13:12:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 040154C040;
        Fri, 28 Feb 2020 13:12:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E5234C04A;
        Fri, 28 Feb 2020 13:12:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.88.173])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Feb 2020 13:12:33 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 10/19] xfs: Factor out xfs_attr_rmtval_invalidate
Date:   Fri, 28 Feb 2020 16:12:36 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-11-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022813-0008-0000-0000-00000357501F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022813-0009-0000-0000-00004A787593
Message-Id: <5978319.gsSuJ8ybiv@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_04:2020-02-26,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=3 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002280106
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:36 AM Allison Collins wrote:
> Because new delayed attribute routines cannot roll transactions, we carve off the
> parts of xfs_attr_rmtval_remove that we can use.  This will help to reduce
> repetitive code later when we introduce delayed attributes.
>

I don't see any logical errors.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 26 +++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_attr_remote.h |  2 +-
>  2 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index d1eee24..3de2eec 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -634,15 +634,12 @@ xfs_attr_rmtval_set(
>   * out-of-line buffer that it is stored on.
>   */
>  int
> -xfs_attr_rmtval_remove(
> +xfs_attr_rmtval_invalidate(
>  	struct xfs_da_args	*args)
>  {
>  	xfs_dablk_t		lblkno;
>  	int			blkcnt;
>  	int			error;
> -	int			done;
> -
> -	trace_xfs_attr_rmtval_remove(args);
>  
>  	/*
>  	 * Roll through the "value", invalidating the attribute value's blocks.
> @@ -670,13 +667,32 @@ xfs_attr_rmtval_remove(
>  		lblkno += map.br_blockcount;
>  		blkcnt -= map.br_blockcount;
>  	}
> +	return 0;
> +}
>  
> +/*
> + * Remove the value associated with an attribute by deleting the
> + * out-of-line buffer that it is stored on.
> + */
> +int
> +xfs_attr_rmtval_remove(
> +	struct xfs_da_args      *args)
> +{
> +	xfs_dablk_t		lblkno;
> +	int			blkcnt;
> +	int			error = 0;
> +	int			done = 0;
> +
> +	trace_xfs_attr_rmtval_remove(args);
> +
> +	error = xfs_attr_rmtval_invalidate(args);
> +	if (error)
> +		return error;
>  	/*
>  	 * Keep de-allocating extents until the remote-value region is gone.
>  	 */
>  	lblkno = args->rmtblkno;
>  	blkcnt = args->rmtblkcnt;
> -	done = 0;
>  	while (!done) {
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>  				    XFS_BMAPI_ATTRFORK, 1, &done);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 6fb4572..eff5f95 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -13,5 +13,5 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
> -
> +int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> 


-- 
chandan



