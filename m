Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA307C3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 06:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF3A2078C
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 06:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgDTGW1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 02:22:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbgDTGW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 02:22:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03K61rTP054545
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 02:22:26 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmu6k0tm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 02:22:26 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 20 Apr 2020 07:21:42 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 Apr 2020 07:21:40 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03K6LFHi46727428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 06:21:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0351B52051;
        Mon, 20 Apr 2020 06:22:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.68.184])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 39E945204E;
        Mon, 20 Apr 2020 06:22:21 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 16/20] xfs: Add helper function xfs_attr_node_removename_setup
Date:   Mon, 20 Apr 2020 11:55:26 +0530
Organization: IBM
In-Reply-To: <20200403221229.4995-17-allison.henderson@oracle.com>
References: <20200403221229.4995-1-allison.henderson@oracle.com> <20200403221229.4995-17-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20042006-4275-0000-0000-000003C315F4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042006-4276-0000-0000-000038D8968A
Message-Id: <4316392.Z7yW20nrPr@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_01:2020-04-17,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=2 mlxlogscore=999
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday, April 4, 2020 3:42 AM Allison Collins wrote: 
> This patch adds a new helper function xfs_attr_node_removename_setup.
> This will help modularize xfs_attr_node_removename when we add delay
> ready attributes later.
>
The changes look good to me,

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f70b4f2..3c33dc5 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1193,6 +1193,35 @@ xfs_attr_leaf_mark_incomplete(
>  }
>  
>  /*
> + * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
> + * the blocks are valid.  Any remote blocks will be marked incomplete.
> + */
> +STATIC
> +int xfs_attr_node_removename_setup(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	**state)
> +{
> +	int			error;
> +	struct xfs_da_state_blk	*blk;
> +
> +	error = xfs_attr_node_hasname(args, state);
> +	if (error != -EEXIST)
> +		return error;
> +
> +	blk = &(*state)->path.blk[(*state)->path.active - 1];
> +	ASSERT(blk->bp != NULL);
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
> +	if (args->rmtblkno > 0) {
> +		error = xfs_attr_leaf_mark_incomplete(args, *state);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1210,8 +1239,8 @@ xfs_attr_node_removename(
>  
>  	trace_xfs_attr_node_removename(args);
>  
> -	error = xfs_attr_node_hasname(args, &state);
> -	if (error != -EEXIST)
> +	error = xfs_attr_node_removename_setup(args, &state);
> +	if (error)
>  		goto out;
>  
>  	/*
> @@ -1219,14 +1248,7 @@ xfs_attr_node_removename(
>  	 * This is done before we remove the attribute so that we don't
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
> -	blk = &state->path.blk[ state->path.active-1 ];
> -	ASSERT(blk->bp != NULL);
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_leaf_mark_incomplete(args, state);
> -		if (error)
> -			goto out;
> -
>  		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			goto out;
> 


-- 
chandan



