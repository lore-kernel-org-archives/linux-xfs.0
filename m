Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689EDC35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 12:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FAF4218AC
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 12:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbgBYMuq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 07:50:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56268 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730382AbgBYMup (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 07:50:45 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PCoOws021521
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 07:50:45 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb00ad2gp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 07:50:43 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Tue, 25 Feb 2020 12:50:32 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 25 Feb 2020 12:50:29 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01PCoSpO52232314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 12:50:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE081AE057;
        Tue, 25 Feb 2020 12:50:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21263AE045;
        Tue, 25 Feb 2020 12:50:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.72.199])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Feb 2020 12:50:27 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 05/19] xfs: Factor out new helper functions xfs_attr_rmtval_set
Date:   Tue, 25 Feb 2020 18:23:21 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-6-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022512-0008-0000-0000-0000035644CF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022512-0009-0000-0000-00004A776079
Message-Id: <2068968.RKExeAfMjv@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_04:2020-02-21,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 suspectscore=3 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250100
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:35 AM Allison Collins wrote: 
> Break xfs_attr_rmtval_set into two helper functions xfs_attr_rmt_find_hole
> and xfs_attr_rmtval_set_value. xfs_attr_rmtval_set rolls the transaction between the
> helpers, but delayed operations cannot.  We will use the helpers later when
> constructing new delayed attribute routines.

I don't see any logical errors.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 149 +++++++++++++++++++++++++---------------
>  1 file changed, 92 insertions(+), 57 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index df8aca5..d1eee24 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -440,32 +440,23 @@ xfs_attr_rmtval_get(
>  }
>  
>  /*
> - * Write the value associated with an attribute into the out-of-line buffer
> - * that we have defined for it.
> + * Find a "hole" in the attribute address space large enough for us to drop the
> + * new attribute's value into
>   */
> -int
> -xfs_attr_rmtval_set(
> +STATIC int
> +xfs_attr_rmt_find_hole(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
> -	struct xfs_bmbt_irec	map;
> -	xfs_dablk_t		lblkno;
> -	xfs_fileoff_t		lfileoff = 0;
> -	uint8_t			*src = args->value;
> -	int			blkcnt;
> -	int			valuelen;
> -	int			nmap;
>  	int			error;
> -	int			offset = 0;
> -
> -	trace_xfs_attr_rmtval_set(args);
> +	int			blkcnt;
> +	xfs_fileoff_t		lfileoff = 0;
>  
>  	/*
> -	 * Find a "hole" in the attribute address space large enough for
> -	 * us to drop the new attribute's value into. Because CRC enable
> -	 * attributes have headers, we can't just do a straight byte to FSB
> -	 * conversion and have to take the header space into account.
> +	 * Because CRC enable attributes have headers, we can't just do a
> +	 * straight byte to FSB conversion and have to take the header space
> +	 * into account.
>  	 */
>  	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
>  	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
> @@ -473,48 +464,26 @@ xfs_attr_rmtval_set(
>  	if (error)
>  		return error;
>  
> -	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
> +	args->rmtblkno = (xfs_dablk_t)lfileoff;
>  	args->rmtblkcnt = blkcnt;
>  
> -	/*
> -	 * Roll through the "value", allocating blocks on disk as required.
> -	 */
> -	while (blkcnt > 0) {
> -		/*
> -		 * Allocate a single extent, up to the size of the value.
> -		 *
> -		 * Note that we have to consider this a data allocation as we
> -		 * write the remote attribute without logging the contents.
> -		 * Hence we must ensure that we aren't using blocks that are on
> -		 * the busy list so that we don't overwrite blocks which have
> -		 * recently been freed but their transactions are not yet
> -		 * committed to disk. If we overwrite the contents of a busy
> -		 * extent and then crash then the block may not contain the
> -		 * correct metadata after log recovery occurs.
> -		 */
> -		nmap = 1;
> -		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
> -				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
> -				  &nmap);
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -
> -		ASSERT(nmap == 1);
> -		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> -		       (map.br_startblock != HOLESTARTBLOCK));
> -		lblkno += map.br_blockcount;
> -		blkcnt -= map.br_blockcount;
> +	return 0;
> +}
>  
> -		/*
> -		 * Start the next trans in the chain.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> -	}
> +STATIC int
> +xfs_attr_rmtval_set_value(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_bmbt_irec	map;
> +	xfs_dablk_t		lblkno;
> +	uint8_t			*src = args->value;
> +	int			blkcnt;
> +	int			valuelen;
> +	int			nmap;
> +	int			error;
> +	int			offset = 0;
>  
>  	/*
>  	 * Roll through the "value", copying the attribute value to the
> @@ -595,6 +564,72 @@ xfs_attr_rmtval_stale(
>  }
>  
>  /*
> + * Write the value associated with an attribute into the out-of-line buffer
> + * that we have defined for it.
> + */
> +int
> +xfs_attr_rmtval_set(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_bmbt_irec	map;
> +	xfs_dablk_t		lblkno;
> +	int			blkcnt;
> +	int			nmap;
> +	int			error;
> +
> +	trace_xfs_attr_rmtval_set(args);
> +
> +	error = xfs_attr_rmt_find_hole(args);
> +	if (error)
> +		return error;
> +
> +	blkcnt = args->rmtblkcnt;
> +	lblkno = (xfs_dablk_t)args->rmtblkno;
> +	/*
> +	 * Roll through the "value", allocating blocks on disk as required.
> +	 */
> +	while (blkcnt > 0) {
> +		/*
> +		 * Allocate a single extent, up to the size of the value.
> +		 *
> +		 * Note that we have to consider this a data allocation as we
> +		 * write the remote attribute without logging the contents.
> +		 * Hence we must ensure that we aren't using blocks that are on
> +		 * the busy list so that we don't overwrite blocks which have
> +		 * recently been freed but their transactions are not yet
> +		 * committed to disk. If we overwrite the contents of a busy
> +		 * extent and then crash then the block may not contain the
> +		 * correct metadata after log recovery occurs.
> +		 */
> +		nmap = 1;
> +		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
> +				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
> +				  &nmap);
> +		if (error)
> +			return error;
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +
> +		ASSERT(nmap == 1);
> +		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> +		       (map.br_startblock != HOLESTARTBLOCK));
> +		lblkno += map.br_blockcount;
> +		blkcnt -= map.br_blockcount;
> +
> +		/*
> +		 * Start the next trans in the chain.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			return error;
> +	}
> +
> +	return xfs_attr_rmtval_set_value(args);
> +}
> +
> +/*
>   * Remove the value associated with an attribute by deleting the
>   * out-of-line buffer that it is stored on.
>   */
> 


-- 
chandan



