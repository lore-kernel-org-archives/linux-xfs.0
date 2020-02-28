Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47970C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25F6D24677
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgB1NMO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:12:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbgB1NMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 08:12:14 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SCxpvD030714
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2020 08:12:13 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yepx4pjmx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2020 08:12:12 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 28 Feb 2020 13:12:11 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 28 Feb 2020 13:12:09 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01SDC8Hm39387262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 13:12:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6265F4C050;
        Fri, 28 Feb 2020 13:12:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBC6F4C044;
        Fri, 28 Feb 2020 13:12:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.88.173])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Feb 2020 13:12:07 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 06/19] xfs: Factor out trans handling in xfs_attr3_leaf_flipflags
Date:   Fri, 28 Feb 2020 10:26:16 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-7-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022813-0012-0000-0000-0000038B27BA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022813-0013-0000-0000-000021C7D485
Message-Id: <1782458.M39mk1tkPu@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_04:2020-02-26,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 phishscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 clxscore=1015 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002280106
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:35 AM Allison Collins wrote: 
> Since delayed operations cannot roll transactions, factor up the transaction
> handling into the calling function
>

I don't see any logical errors.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c |  7 +------
>  2 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a2f812f..cf0cba7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -739,6 +739,13 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_flipflags(args);
>  		if (error)
>  			return error;
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (error)
> +			return error;
>  
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> @@ -1081,6 +1088,13 @@ xfs_attr_node_addname(
>  		error = xfs_attr3_leaf_flipflags(args);
>  		if (error)
>  			goto out;
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (error)
> +			goto out;
>  
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 9d6b68c..d691509 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2973,10 +2973,5 @@ xfs_attr3_leaf_flipflags(
>  			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -
> -	return error;
> +	return 0;
>  }
> 


-- 
chandan



