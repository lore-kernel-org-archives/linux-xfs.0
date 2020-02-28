Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA21DC3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 02:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B762468D
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 02:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgCBCmN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Mar 2020 21:42:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726688AbgCBCmN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Mar 2020 21:42:13 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0222ZWg5133089
        for <linux-xfs@vger.kernel.org>; Sun, 1 Mar 2020 21:42:11 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfmu36kdh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 01 Mar 2020 21:42:11 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 2 Mar 2020 02:42:09 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Mar 2020 02:42:08 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0222g71433161472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Mar 2020 02:42:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C2C7AE04D;
        Mon,  2 Mar 2020 02:42:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09FA3AE045;
        Mon,  2 Mar 2020 02:42:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.35.41])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Mar 2020 02:42:06 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 12/19] xfs: Add helper function xfs_attr_rmtval_unmap
Date:   Fri, 28 Feb 2020 19:52:09 +0530
Organization: IBM
In-Reply-To: <20200223020611.1802-13-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20030202-0020-0000-0000-000003AF5285
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030202-0021-0000-0000-000022077B4D
Message-Id: <22012336.ZNLmcpOMGY@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_09:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=3 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 impostorscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020019
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 7:36 AM Allison Collins wrote: 
> This function is similar to xfs_attr_rmtval_remove, but adapted to return EAGAIN for
> new transactions. We will use this later when we introduce delayed attributes
>
I don't see any logical errors.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 28 ++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 29 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 3de2eec..da40f85 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -711,3 +711,31 @@ xfs_attr_rmtval_remove(
>  	}
>  	return 0;
>  }
> +
> +/*
> + * Remove the value associated with an attribute by deleting the out-of-line
> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> + * transaction and recall the function
> + */
> +int
> +xfs_attr_rmtval_unmap(
> +	struct xfs_da_args	*args)
> +{
> +	int	error, done;
> +
> +	/*
> +	 * Unmap value blocks for this attr.  This is similar to
> +	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
> +	 * for new transactions
> +	 */
> +	error = xfs_bunmapi(args->trans, args->dp,
> +		    args->rmtblkno, args->rmtblkcnt,
> +		    XFS_BMAPI_ATTRFORK, 1, &done);
> +	if (error)
> +		return error;
> +
> +	if (!done)
> +		return -EAGAIN;
> +
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index eff5f95..e06299a 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> +int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> 


-- 
chandan



