Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A6CC4363A
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 19:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A35022276
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 19:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eIzyf6Bb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764037AbgJXT3Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 15:29:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51394 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764036AbgJXT3Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 15:29:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OJTJJ3105646;
        Sat, 24 Oct 2020 19:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IZQO/8kerNG53B9fq1CZwUYCh48R8W28DZRDIhXEoTc=;
 b=eIzyf6Bb7Bkh0QOYjbcSedA59iycLkkHdCjIxtZUErhIuzwFRx+Mp6NLUlbA7Ilf+rNK
 HNo54/SA2hmRfmQJoPoXmk0qesm1pyetGb5idFh32KQH3Khys43B2tF/PRfOH3xIHSHk
 PE/LhR0KQxVs+7H5xnfOgsbYB5w+Z385G1rtDjSF8U/VzNl35QVvqD1UdS/afRAVnWQH
 X794Yst9iGaKRGklOhLR99GB4d+T4cjCMkNJl04m9i2f+cl2KpjXianeieP//1jxLWU0
 lwG8RSzcamRo4DUchdOWKW+RLWFi7knheujcm6CEYfZbHYhW8je3sU2ISl/l0Fm8tYYi Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kh23q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 19:29:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OJK6s2052291;
        Sat, 24 Oct 2020 19:29:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cbkhn79c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 19:29:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09OJTHcs030233;
        Sat, 24 Oct 2020 19:29:17 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 12:29:17 -0700
Subject: Re: [PATCH V7 04/14] xfs: Check for extent overflow when
 adding/removing xattrs
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-5-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <10bf6a0b-7aeb-f9ed-b233-3b707a90c0ed@oracle.com>
Date:   Sat, 24 Oct 2020 12:29:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-5-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240149
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
> added. One extra extent for dabtree in case a local attr is large enough
> to cause a double split.  It can also cause extent count to increase
> proportional to the size of a remote xattr's value.
> 
Ok makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_attr.c       | 13 +++++++++++++
>   fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
>   2 files changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd8e6418a0d3..be51e7068dcd 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -396,6 +396,7 @@ xfs_attr_set(
>   	struct xfs_trans_res	tres;
>   	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
>   	int			error, local;
> +	int			rmt_blks = 0;
>   	unsigned int		total;
>   
>   	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> @@ -442,11 +443,15 @@ xfs_attr_set(
>   		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>   		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>   		total = args->total;
> +
> +		if (!local)
> +			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
>   	} else {
>   		XFS_STATS_INC(mp, xs_attr_remove);
>   
>   		tres = M_RES(mp)->tr_attrrm;
>   		total = XFS_ATTRRM_SPACE_RES(mp);
> +		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
>   	}
>   
>   	/*
> @@ -460,6 +465,14 @@ xfs_attr_set(
>   
>   	xfs_ilock(dp, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(args->trans, dp, 0);
> +
> +	if (args->value || xfs_inode_hasattr(dp)) {
> +		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> +				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>   	if (args->value) {
>   		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
>   
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index bcac769a7df6..5de2f07d0dd5 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -47,6 +47,16 @@ struct xfs_ifork {
>    */
>   #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
>   
> +/*
> + * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
> + * be added. One extra extent for dabtree in case a local attr is
> + * large enough to cause a double split.  It can also cause extent
> + * count to increase proportional to the size of a remote xattr's
> + * value.
> + */
> +#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
> +	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
> +
>   /*
>    * Fork handling.
>    */
> 
