Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9F8C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 03:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B81F320747
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 03:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbgDBDCE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 23:02:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732498AbgDBDCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 23:02:03 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03231o8i088296
        for <linux-xfs@vger.kernel.org>; Wed, 1 Apr 2020 23:02:02 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304g86yp97-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Apr 2020 23:02:02 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 2 Apr 2020 04:01:49 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Apr 2020 04:01:48 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03231wMA29360586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 03:01:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C09055204F;
        Thu,  2 Apr 2020 03:01:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.79.191.239])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1E2575204E;
        Thu,  2 Apr 2020 03:01:57 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: drop all altpath buffers at the end of the sibling check
Date:   Thu, 02 Apr 2020 08:35:01 +0530
Organization: IBM
In-Reply-To: <158510668935.922633.2938909097570009707.stgit@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia> <158510668935.922633.2938909097570009707.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20040203-0008-0000-0000-00000368CEDA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040203-0009-0000-0000-00004A8A5922
Message-Id: <2249872.qAYv1JrkZs@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_04:2020-03-31,2020-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=5 adultscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, March 25, 2020 8:54 AM Darrick J. Wong wrote: 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The dirattr btree checking code uses the altpath substructure of the
> dirattr state structure to check the sibling pointers of dir/attr tree
> blocks.  At the end of sibling checks, xfs_da3_path_shift could have
> changed multiple levels of buffer pointers in the altpath structure.
> Although we release the leaf level buffer, this isn't enough -- we also
> need to release the node buffers that are unique to the altpath.
> 
> Not releasing all of the altpath buffers leaves them locked to the
> transaction.  This is suboptimal because we should release resources
> when we don't need them anymore.  Fix the function to loop all levels of
> the altpath, and fix the return logic so that we always run the loop.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

The patch indeed releases 'altpath' block buffers that are not referenced by
by block buffers in 'path' after the sibling block is checked for
inconsistencies.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> ---
>  fs/xfs/scrub/dabtree.c |   42 +++++++++++++++++++++++++-----------------
>  1 file changed, 25 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 97a15b6f2865..9a2e27ac1300 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -219,19 +219,21 @@ xchk_da_btree_block_check_sibling(
>  	int			direction,
>  	xfs_dablk_t		sibling)
>  {
> +	struct xfs_da_state_path *path = &ds->state->path;
> +	struct xfs_da_state_path *altpath = &ds->state->altpath;
>  	int			retval;
> +	int			plevel;
>  	int			error;
>  
> -	memcpy(&ds->state->altpath, &ds->state->path,
> -			sizeof(ds->state->altpath));
> +	memcpy(altpath, path, sizeof(ds->state->altpath));
>  
>  	/*
>  	 * If the pointer is null, we shouldn't be able to move the upper
>  	 * level pointer anywhere.
>  	 */
>  	if (sibling == 0) {
> -		error = xfs_da3_path_shift(ds->state, &ds->state->altpath,
> -				direction, false, &retval);
> +		error = xfs_da3_path_shift(ds->state, altpath, direction,
> +				false, &retval);
>  		if (error == 0 && retval == 0)
>  			xchk_da_set_corrupt(ds, level);
>  		error = 0;
> @@ -239,27 +241,33 @@ xchk_da_btree_block_check_sibling(
>  	}
>  
>  	/* Move the alternate cursor one block in the direction given. */
> -	error = xfs_da3_path_shift(ds->state, &ds->state->altpath,
> -			direction, false, &retval);
> +	error = xfs_da3_path_shift(ds->state, altpath, direction, false,
> +			&retval);
>  	if (!xchk_da_process_error(ds, level, &error))
> -		return error;
> +		goto out;
>  	if (retval) {
>  		xchk_da_set_corrupt(ds, level);
> -		return error;
> +		goto out;
>  	}
> -	if (ds->state->altpath.blk[level].bp)
> -		xchk_buffer_recheck(ds->sc,
> -				ds->state->altpath.blk[level].bp);
> +	if (altpath->blk[level].bp)
> +		xchk_buffer_recheck(ds->sc, altpath->blk[level].bp);
>  
>  	/* Compare upper level pointer to sibling pointer. */
> -	if (ds->state->altpath.blk[level].blkno != sibling)
> +	if (altpath->blk[level].blkno != sibling)
>  		xchk_da_set_corrupt(ds, level);
> -	if (ds->state->altpath.blk[level].bp) {
> -		xfs_trans_brelse(ds->dargs.trans,
> -				ds->state->altpath.blk[level].bp);
> -		ds->state->altpath.blk[level].bp = NULL;
> -	}
> +
>  out:
> +	/* Free all buffers in the altpath that aren't referenced from path. */
> +	for (plevel = 0; plevel < altpath->active; plevel++) {
> +		if (altpath->blk[plevel].bp == NULL ||
> +		    (plevel < path->active &&
> +		     altpath->blk[plevel].bp == path->blk[plevel].bp))
> +			continue;
> +
> +		xfs_trans_brelse(ds->dargs.trans, altpath->blk[plevel].bp);
> +		altpath->blk[plevel].bp = NULL;
> +	}
> +
>  	return error;
>  }
>  
> 
> 


-- 
chandan



