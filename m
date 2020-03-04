Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB69C3F2D7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 04:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00BD820838
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 04:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgCDEei (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 23:34:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728339AbgCDEeg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 23:34:36 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0244YYvO092377
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 23:34:35 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yj4q0h23v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 23:34:34 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 4 Mar 2020 04:34:28 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 4 Mar 2020 04:34:26 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0244YPCj43254214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Mar 2020 04:34:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31FEAAE051;
        Wed,  4 Mar 2020 04:34:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A32E7AE045;
        Wed,  4 Mar 2020 04:34:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.41.86])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Mar 2020 04:34:24 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 17/19] xfs: Add helper function xfs_attr_leaf_mark_incomplete
Date:   Wed, 04 Mar 2020 10:07:20 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-18-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20030404-0028-0000-0000-000003E0AC56
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030404-0029-0000-0000-000024A5DAE0
Message-Id: <3675766.gmhG8tua6g@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_08:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=3 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:36 AM Allison Collins wrote: 
> This patch helps to simplify xfs_attr_node_removename by modularizing the code
> around the transactions into helper functions.  This will make the function easier
> to follow when we introduce delayed attributes.
>

The changes look good to me.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index dd935ff..b9728d1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1416,6 +1416,36 @@ xfs_attr_node_shrink(
>  }
>  
>  /*
> + * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
> + * for later deletion of the entry.
> + */
> +STATIC int
> +xfs_attr_leaf_mark_incomplete(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	int error;
> +
> +	/*
> +	 * Fill in disk block numbers in the state structure
> +	 * so that we can get the buffers back after we commit
> +	 * several transactions in the following calls.
> +	 */
> +	error = xfs_attr_fillstate(state);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Mark the attribute as INCOMPLETE
> +	 */
> +	error = xfs_attr3_leaf_setflag(args);
> +	if (error)
> +		return error;
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1473,20 +1503,7 @@ xfs_attr_node_removename(
>  	args->dac.da_state = state;
>  
>  	if (args->rmtblkno > 0) {
> -		/*
> -		 * Fill in disk block numbers in the state structure
> -		 * so that we can get the buffers back after we commit
> -		 * several transactions in the following calls.
> -		 */
> -		error = xfs_attr_fillstate(state);
> -		if (error)
> -			goto out;
> -
> -		/*
> -		 * Mark the attribute as INCOMPLETE, then bunmapi() the
> -		 * remote value.
> -		 */
> -		error = xfs_attr3_leaf_setflag(args);
> +		error = xfs_attr_leaf_mark_incomplete(args, state);
>  		if (error)
>  			goto out;
>  
> 


-- 
chandan



