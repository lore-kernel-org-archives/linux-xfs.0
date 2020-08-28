Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4116CC433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 06:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15FDE2098B
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 06:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rFcD0dD2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgH1GJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Aug 2020 02:09:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52806 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728464AbgH1GJL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 02:09:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S645g2146488;
        Fri, 28 Aug 2020 06:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Ac0KaOwlk2fTetinsAcPQc2Rfd12oiUl7IR+RhK+2Rc=;
 b=rFcD0dD2kg1TGiMB6EmPZC97rxz3L+MPwKoVoHs1Nh1jLjElJETB8UBSCAJRlbXm0Owi
 KYs9BU37EXSq99RTooHsZaORNWx8FyIDF8vKNsD9RobEkA8RKQUoHQAT0YbE63EtkGL+
 zasAbRM/Srmex0uAj08istkTpzxx6SDBq5S3ABU+WD63TqzhhyZzRL5/24e+/7BBh8h2
 47f5w9Wh6O8TW3DKF1I9YACHd1dwy0982+MCx+nWb2uuveoDqhPiw9bBWQRVbFSoXgvu
 lT39XtUbLN3WiGX895SX/iCperNA8FLKRN5lxHeN8lxhd4x/E30g4Ln0IukZhOwksNHv DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbsa4ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 06:09:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S64jRL040726;
        Fri, 28 Aug 2020 06:08:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 333ru2cs46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 06:08:59 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07S68w9D005116;
        Fri, 28 Aug 2020 06:08:58 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 23:08:58 -0700
Subject: Re: [PATCH 10/11] xfs: trace timestamp limits
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com,
        hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847956308.2601708.12409676822646276735.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <869a2b15-3019-e1a8-5d92-2a5719fc11f2@oracle.com>
Date:   Thu, 27 Aug 2020 23:08:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159847956308.2601708.12409676822646276735.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/26/20 3:06 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of tracepoints so that we can check the timestamp limits
> being set on inodes and quotas.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_qm.c    |    2 ++
>   fs/xfs/xfs_super.c |    1 +
>   fs/xfs/xfs_trace.h |   26 ++++++++++++++++++++++++++
>   3 files changed, 29 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 259588a4227d..3f82e0c92c2d 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -670,6 +670,8 @@ xfs_qm_init_quotainfo(
>   		qinf->qi_expiry_min = XFS_DQ_LEGACY_EXPIRY_MIN;
>   		qinf->qi_expiry_max = XFS_DQ_LEGACY_EXPIRY_MAX;
>   	}
> +	trace_xfs_quota_expiry_range(mp, qinf->qi_expiry_min,
> +			qinf->qi_expiry_max);
>   
>   	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
>   
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 58be2220ae05..8230c902a813 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1491,6 +1491,7 @@ xfs_fc_fill_super(
>   		sb->s_time_min = XFS_LEGACY_TIME_MIN;
>   		sb->s_time_max = XFS_LEGACY_TIME_MAX;
>   	}
> +	trace_xfs_inode_timestamp_range(mp, sb->s_time_min, sb->s_time_max);
>   	sb->s_iflags |= SB_I_CGROUPWB;
>   
>   	set_posix_acl_flag(sb);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index abb1d859f226..a3a35a2d8ed9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3844,6 +3844,32 @@ TRACE_EVENT(xfs_btree_bload_block,
>   		  __entry->nr_records)
>   )
>   
> +DECLARE_EVENT_CLASS(xfs_timestamp_range_class,
> +	TP_PROTO(struct xfs_mount *mp, time64_t min, time64_t max),
> +	TP_ARGS(mp, min, max),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(long long, min)
> +		__field(long long, max)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->min = min;
> +		__entry->max = max;
> +	),
> +	TP_printk("dev %d:%d min %lld max %lld",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->min,
> +		  __entry->max)
> +)
> +
> +#define DEFINE_TIMESTAMP_RANGE_EVENT(name) \
> +DEFINE_EVENT(xfs_timestamp_range_class, name, \
> +	TP_PROTO(struct xfs_mount *mp, long long min, long long max), \
> +	TP_ARGS(mp, min, max))
> +DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
> +DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
> +
>   #endif /* _TRACE_XFS_H */
>   
>   #undef TRACE_INCLUDE_PATH
> 
