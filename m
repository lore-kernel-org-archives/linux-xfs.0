Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B7DC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE30724677
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgB1NMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:12:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbgB1NMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 08:12:43 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SD3tuK043731
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2020 08:12:42 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yepxb6p6h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2020 08:12:42 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 28 Feb 2020 13:12:40 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 28 Feb 2020 13:12:38 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01SDCbEd42992030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 13:12:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 038D24C05A;
        Fri, 28 Feb 2020 13:12:37 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39CDC4C04E;
        Fri, 28 Feb 2020 13:12:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.88.173])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Feb 2020 13:12:35 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 11/19] xfs: Factor out trans roll in xfs_attr3_leaf_clearflag
Date:   Fri, 28 Feb 2020 16:26:45 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-12-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022813-0012-0000-0000-0000038B27CB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022813-0013-0000-0000-000021C7D496
Message-Id: <2305153.mO9ejTnR4H@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_04:2020-02-26,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 spamscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002280106
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:36 AM Allison Collins wrote: 
> New delayed allocation routines cannot be handling transactions so factor them out
> into the calling functions
>

I don't see any logical errors.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 16 ++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 26412da..5d73bdf 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -822,6 +822,14 @@ xfs_attr_leaf_addname(
>  		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
>  		error = xfs_attr3_leaf_clearflag(args);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  	}
>  	return error;
>  }
> @@ -1185,6 +1193,14 @@ xfs_attr_node_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  		if (error)
>  			goto out;
> +
> +		 /*
> +		  * Commit the flag value change and start the next trans in
> +		  * series.
> +		  */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		if (error)
> +			goto out;
>  	}
>  	retval = error = 0;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 67339f0..1742f0a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2804,10 +2804,7 @@ xfs_attr3_leaf_clearflag(
>  			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> +	return 0;
>  }
>  
>  /*
> 


-- 
chandan



