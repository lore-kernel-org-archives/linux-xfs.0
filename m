Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A45C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 04:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F80208E4
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 04:08:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l6XR/8qU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgH1EIm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Aug 2020 00:08:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgH1EIk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 00:08:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S3xlhD023632;
        Fri, 28 Aug 2020 04:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rngmjOT7w6RvLX7lgJ/uPym3ITGKTLccSzrH0h4duqI=;
 b=l6XR/8qUl35mrx91LUFPM0KFesAuqea630Me1Ing6S4ifiOphtKXM8dd/KXTBv9StRP9
 8aLfbV8fJL+faKwT+kbP2sKajiwl7vOPbYgkZBi9NbfCG2esQBgJb8dKFCa5wpaboXUZ
 E/8zw88ytQxJStPEKN+LkIse6p+gJEdnZEYJ7+1cX7n7Ldp0mtKSj+xHHTTXU/fk1qds
 nLxLkgXLE2BXsrUmiywd0LMH0odIWEArWehgfYbkE2ZMMGHnasMOGptACExRUMJbQr2u
 ZU/nCOfeWiHoTmjOIQ0X0+SzKBr4n9sb6gH2fer7o70XDWhY6k6jlYGXSbclFHYJtmtY aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 333w6u8ch2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 04:08:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S40Lxo157018;
        Fri, 28 Aug 2020 04:08:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 333ruerdy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 04:08:31 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07S48UoY024936;
        Fri, 28 Aug 2020 04:08:30 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 21:08:30 -0700
Subject: Re: [PATCH 04/11] xfs: refactor quota timestamp coding
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com,
        hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847952392.2601708.833795605203708912.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <79517cd3-8113-cdfd-a47f-dbe5e657cd38@oracle.com>
Date:   Thu, 27 Aug 2020 21:08:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159847952392.2601708.833795605203708912.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/26/20 3:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor quota timestamp encoding and decoding into helper functions so
> that we can add extra behavior in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Looks fine
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_dquot_buf.c  |   18 ++++++++++++++++++
>   fs/xfs/libxfs/xfs_quota_defs.h |    5 +++++
>   fs/xfs/xfs_dquot.c             |   12 ++++++------
>   3 files changed, 29 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 5a2db00b9d5f..cf85bad8a894 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -288,3 +288,21 @@ const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
>   	.verify_read = xfs_dquot_buf_readahead_verify,
>   	.verify_write = xfs_dquot_buf_write_verify,
>   };
> +
> +/* Convert an on-disk timer value into an incore timer value. */
> +time64_t
> +xfs_dquot_from_disk_ts(
> +	struct xfs_disk_dquot	*ddq,
> +	__be32			dtimer)
> +{
> +	return be32_to_cpu(dtimer);
> +}
> +
> +/* Convert an incore timer value into an on-disk timer value. */
> +__be32
> +xfs_dquot_to_disk_ts(
> +	struct xfs_dquot	*dqp,
> +	time64_t		timer)
> +{
> +	return cpu_to_be32(timer);
> +}
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 076bdc7037ee..9a99910d857e 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -143,4 +143,9 @@ extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
>   extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
>   		xfs_dqid_t id, xfs_dqtype_t type);
>   
> +struct xfs_dquot;
> +time64_t xfs_dquot_from_disk_ts(struct xfs_disk_dquot *ddq,
> +		__be32 dtimer);
> +__be32 xfs_dquot_to_disk_ts(struct xfs_dquot *ddq, time64_t timer);
> +
>   #endif	/* __XFS_QUOTA_H__ */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index e63a933413a3..59c03e973741 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -536,9 +536,9 @@ xfs_dquot_from_disk(
>   	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
>   	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
>   
> -	dqp->q_blk.timer = be32_to_cpu(ddqp->d_btimer);
> -	dqp->q_ino.timer = be32_to_cpu(ddqp->d_itimer);
> -	dqp->q_rtb.timer = be32_to_cpu(ddqp->d_rtbtimer);
> +	dqp->q_blk.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_btimer);
> +	dqp->q_ino.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_itimer);
> +	dqp->q_rtb.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_rtbtimer);
>   
>   	/*
>   	 * Reservation counters are defined as reservation plus current usage
> @@ -581,9 +581,9 @@ xfs_dquot_to_disk(
>   	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
>   	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
>   
> -	ddqp->d_btimer = cpu_to_be32(dqp->q_blk.timer);
> -	ddqp->d_itimer = cpu_to_be32(dqp->q_ino.timer);
> -	ddqp->d_rtbtimer = cpu_to_be32(dqp->q_rtb.timer);
> +	ddqp->d_btimer = xfs_dquot_to_disk_ts(dqp, dqp->q_blk.timer);
> +	ddqp->d_itimer = xfs_dquot_to_disk_ts(dqp, dqp->q_ino.timer);
> +	ddqp->d_rtbtimer = xfs_dquot_to_disk_ts(dqp, dqp->q_rtb.timer);
>   }
>   
>   /* Allocate and initialize the dquot buffer for this in-core dquot. */
> 
