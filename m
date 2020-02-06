Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4F6C2D0B1
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 10:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9104B214AF
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 10:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgBFKbV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 05:31:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728261AbgBFKbU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 05:31:20 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 016AG3cB070899
        for <linux-xfs@vger.kernel.org>; Thu, 6 Feb 2020 05:31:19 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhmyq10g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2020 05:31:19 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 6 Feb 2020 10:31:15 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 10:31:12 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 016AUIO648169348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 10:30:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 990F7A405B;
        Thu,  6 Feb 2020 10:31:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71171A4057;
        Thu,  6 Feb 2020 10:31:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.102.2.200])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Feb 2020 10:31:10 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/30] xfs: use strndup_user in XFS_IOC_ATTRMULTI_BY_HANDLE
Date:   Thu, 06 Feb 2020 16:03:55 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-6-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-6-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020610-4275-0000-0000-0000039E7CB3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020610-4276-0000-0000-000038B2A987
Message-Id: <3011142.zga9gAiKYx@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_01:2020-02-06,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 adultscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002060080
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 

> Simplify the user copy code by using strndup_user.  This means that we
> now do one memory allocation per operation instead of one per ioctl,
> but memory allocations are cheap compared to the actual file system
> operations.
>

The newly introduced changes logically match with the code flow that existed
earlier.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c   | 17 +++++------------
>  fs/xfs/xfs_ioctl32.c | 17 +++++------------
>  2 files changed, 10 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index b806003caacd..bb490a954c0b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -448,11 +448,6 @@ xfs_attrmulti_by_handle(
>  		goto out_dput;
>  	}
> 
> -	error = -ENOMEM;
> -	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
> -	if (!attr_name)
> -		goto out_kfree_ops;
> -
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
>  		if ((ops[i].am_flags & ATTR_ROOT) &&
> @@ -462,12 +457,11 @@ xfs_attrmulti_by_handle(
>  		}
>  		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
> 
> -		ops[i].am_error = strncpy_from_user((char *)attr_name,
> -				ops[i].am_attrname, MAXNAMELEN);
> -		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> -		if (ops[i].am_error < 0)
> +		attr_name = strndup_user(ops[i].am_attrname, MAXNAMELEN);
> +		if (IS_ERR(attr_name)) {
> +			ops[i].am_error = PTR_ERR(attr_name);
>  			break;
> +		}
> 
>  		switch (ops[i].am_opcode) {
>  		case ATTR_OP_GET:
> @@ -498,13 +492,12 @@ xfs_attrmulti_by_handle(
>  		default:
>  			ops[i].am_error = -EINVAL;
>  		}
> +		kfree(attr_name);
>  	}
> 
>  	if (copy_to_user(am_hreq.ops, ops, size))
>  		error = -EFAULT;
> 
> -	kfree(attr_name);
> - out_kfree_ops:
>  	kfree(ops);
>   out_dput:
>  	dput(dentry);
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index e085f304e539..936c2f62fb6c 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -445,11 +445,6 @@ xfs_compat_attrmulti_by_handle(
>  		goto out_dput;
>  	}
> 
> -	error = -ENOMEM;
> -	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
> -	if (!attr_name)
> -		goto out_kfree_ops;
> -
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
>  		if ((ops[i].am_flags & ATTR_ROOT) &&
> @@ -459,13 +454,12 @@ xfs_compat_attrmulti_by_handle(
>  		}
>  		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
> 
> -		ops[i].am_error = strncpy_from_user((char *)attr_name,
> -				compat_ptr(ops[i].am_attrname),
> +		attr_name = strndup_user(compat_ptr(ops[i].am_attrname),
>  				MAXNAMELEN);
> -		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> -		if (ops[i].am_error < 0)
> +		if (IS_ERR(attr_name)) {
> +			ops[i].am_error = PTR_ERR(attr_name);
>  			break;
> +		}
> 
>  		switch (ops[i].am_opcode) {
>  		case ATTR_OP_GET:
> @@ -496,13 +490,12 @@ xfs_compat_attrmulti_by_handle(
>  		default:
>  			ops[i].am_error = -EINVAL;
>  		}
> +		kfree(attr_name);
>  	}
> 
>  	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
>  		error = -EFAULT;
> 
> -	kfree(attr_name);
> - out_kfree_ops:
>  	kfree(ops);
>   out_dput:
>  	dput(dentry);
> 

-- 
chandan



