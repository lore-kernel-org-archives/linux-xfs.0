Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751CEC352A4
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 06:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C5AA20870
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 06:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgBJGy4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 01:54:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7750 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726061AbgBJGy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Feb 2020 01:54:56 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01A6rIUl103404
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 01:54:55 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1uchrftj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2020 01:54:54 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 10 Feb 2020 06:54:53 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 06:54:50 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01A6snEZ58654862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 06:54:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1564C11C04A;
        Mon, 10 Feb 2020 06:54:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 521F611C05B;
        Mon, 10 Feb 2020 06:54:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.35.21])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 06:54:48 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 27/30] xfs: clean up the ATTR_REPLACE checks
Date:   Mon, 10 Feb 2020 12:27:35 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-28-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-28-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20021006-0020-0000-0000-000003A8AF33
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021006-0021-0000-0000-000022008861
Message-Id: <32274659.LzHWCM3A9y@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_01:2020-02-07,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=890 priorityscore=1501 suspectscore=1 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100057
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:33 PM Christoph Hellwig wrote: 
> Remove superflous braces, elses after return statements and use a goto
> label to merge common error handling.
>

The changes look good to me,

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3b1db2afb104..9c629c7c912d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -423,9 +423,9 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	trace_xfs_attr_sf_addname(args);
> 
>  	retval = xfs_attr_shortform_lookup(args);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
>  		return retval;
> -	} else if (retval == -EEXIST) {
> +	if (retval == -EEXIST) {
>  		if (args->flags & ATTR_CREATE)
>  			return retval;
>  		retval = xfs_attr_shortform_remove(args);
> @@ -489,14 +489,11 @@ xfs_attr_leaf_addname(
>  	 * the given flags produce an error or call for an atomic rename.
>  	 */
>  	retval = xfs_attr3_leaf_lookup_int(bp, args);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> -		xfs_trans_brelse(args->trans, bp);
> -		return retval;
> -	} else if (retval == -EEXIST) {
> -		if (args->flags & ATTR_CREATE) {	/* pure create op */
> -			xfs_trans_brelse(args->trans, bp);
> -			return retval;
> -		}
> +	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
> +		goto out_brelse;
> +	if (retval == -EEXIST) {
> +		if (args->flags & ATTR_CREATE)	/* pure create op */
> +			goto out_brelse;
> 
>  		trace_xfs_attr_leaf_replace(args);
> 
> @@ -637,6 +634,9 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  	}
>  	return error;
> +out_brelse:
> +	xfs_trans_brelse(args->trans, bp);
> +	return retval;
>  }
> 
>  /*
> @@ -763,9 +763,9 @@ xfs_attr_node_addname(
>  		goto out;
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
>  		goto out;
> -	} else if (retval == -EEXIST) {
> +	if (retval == -EEXIST) {
>  		if (args->flags & ATTR_CREATE)
>  			goto out;
> 
> 


-- 
chandan



