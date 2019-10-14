Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEC9ECE587
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31E1F20873
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:02:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ujrh61lI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbfJNSC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 14:02:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49764 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfJNSC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 14:02:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EHwlbY069916;
        Mon, 14 Oct 2019 18:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=uN1ftC8S/YgH8KhA+AIhSumRQEBCwZbzzeli7vejk0c=;
 b=Ujrh61lIB8RhqQEBUsVSdMmWyNdOGvmvSbCd7IO9NB3zzPzsYnnUGpe6UnG2aKOQx70m
 p9liOWtIhbbSwdkOt4aiQdpmGM3tvTDLqn4/O8qwGeNY9Le7ZQM9R3xTj8rv85dy1+O8
 n4BeKQMATZAo9tnjhjOzx+4Bx7Q1TD+1372+O0SdrRmKZ4yvODpAT3kOiDTHk9fhC9Jk
 J6XTfEnZfsrw6mkR7Q1Pj02fCnJAHYcOdfujZk8/1x1292C+9Sol/w0bWTzbnIw7gMSK
 feJkLDJ5uSOBYSRjxBnjKcWKYP6Sp2O4HsvWWU6/NPWaGV/Ov/Ets2I6nVPS3ePg7yrv 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vk6sqam0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 18:02:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EHwE7W171704;
        Mon, 14 Oct 2019 18:02:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vks0788q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 18:02:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9EI2Nk5020039;
        Mon, 14 Oct 2019 18:02:23 GMT
Received: from localhost (/10.159.144.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 18:02:22 +0000
Date:   Mon, 14 Oct 2019 11:02:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move the locking from xlog_state_finish_copy to
 the callers
Message-ID: <20191014180221.GY13108@magnolia>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:43PM +0200, Christoph Hellwig wrote:
> This will allow optimizing various locking cycles in the following
> patches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4f5927ddfa40..860a555772fe 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1967,7 +1967,6 @@ xlog_dealloc_log(
>  /*
>   * Update counters atomically now that memcpy is done.
>   */
> -/* ARGSUSED */
>  static inline void
>  xlog_state_finish_copy(
>  	struct xlog		*log,
> @@ -1975,16 +1974,11 @@ xlog_state_finish_copy(
>  	int			record_cnt,
>  	int			copy_bytes)
>  {
> -	spin_lock(&log->l_icloglock);
> +	lockdep_assert_held(&log->l_icloglock);
>  
>  	be32_add_cpu(&iclog->ic_header.h_num_logops, record_cnt);
>  	iclog->ic_offset += copy_bytes;
> -
> -	spin_unlock(&log->l_icloglock);
> -}	/* xlog_state_finish_copy */
> -
> -
> -
> +}
>  
>  /*
>   * print out info relating to regions written which consume
> @@ -2266,7 +2260,9 @@ xlog_write_copy_finish(
>  		 * This iclog has already been marked WANT_SYNC by
>  		 * xlog_state_get_iclog_space.
>  		 */
> +		spin_lock(&log->l_icloglock);
>  		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> +		spin_unlock(&log->l_icloglock);
>  		*record_cnt = 0;
>  		*data_cnt = 0;
>  		return xlog_state_release_iclog(log, iclog);
> @@ -2277,11 +2273,11 @@ xlog_write_copy_finish(
>  
>  	if (iclog->ic_size - log_offset <= sizeof(xlog_op_header_t)) {
>  		/* no more space in this iclog - push it. */
> +		spin_lock(&log->l_icloglock);
>  		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
>  		*record_cnt = 0;
>  		*data_cnt = 0;
>  
> -		spin_lock(&log->l_icloglock);
>  		xlog_state_want_sync(log, iclog);
>  		spin_unlock(&log->l_icloglock);
>  
> @@ -2504,7 +2500,9 @@ xlog_write(
>  
>  	ASSERT(len == 0);
>  
> +	spin_lock(&log->l_icloglock);
>  	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
> +	spin_unlock(&log->l_icloglock);
>  	if (!commit_iclog)
>  		return xlog_state_release_iclog(log, iclog);
>  
> -- 
> 2.20.1
> 
