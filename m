Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649D2C2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F4230208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:33:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l0lEWHGb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgIWQdG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:33:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44816 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIWQdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 12:33:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGTDQl147956;
        Wed, 23 Sep 2020 16:33:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=P2iNZdFNdU8bnpnC9eyWZmLnd7J5smiARXkEsKNUHXo=;
 b=l0lEWHGbrFzQUqzGVmAGCdtWj+xtm/gX+fk3C2A0+bxngMCWRlRsAI23CecVWYkx8VAe
 3anj7QvQmdtHnBoJtgwpHTblqYM/isJ5L07hJCY4duQhneRqGCo0c7kOBLug/Wvme8Hr
 dZyI7+/wSC8uI8Fny++Tz4unr1Fq2Ch39VD0Hejp1HIqkNASK3mDJpAwxEYbWTOrHJD7
 GNu82Xx0tuUcjNaf77LUms3iizHEoU+9wMiR4PpkyX6ZaYLPfK0jpVmzLLVSpeWGgQ1A
 l1EAoMkz9lb4qKCceK4FfQjDWuaAbJsZnFzJzH8GhnbhscapwcTUp8LjpH7/Qnoizdo0 wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33q5rghx39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 16:33:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGUQE2131718;
        Wed, 23 Sep 2020 16:33:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33nurux92m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 16:33:01 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08NGWxOF014311;
        Wed, 23 Sep 2020 16:32:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 09:32:58 -0700
Date:   Wed, 23 Sep 2020 09:32:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3.2] xfs: clean up calculation of LR header blocks
Message-ID: <20200923163257.GT7955@magnolia>
References: <20200917051341.9811-3-hsiangkao@redhat.com>
 <20200922155316.31275-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922155316.31275-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=5
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=5 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 11:53:16PM +0800, Gao Xiang wrote:
> Let's use DIV_ROUND_UP() to calculate log record header
> blocks as what did in xlog_get_iclog_buffer_size() and
> wrap up a common helper for log recovery.
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> changelog:
>  - 'xlog_rec_header_t' => 'struct xlog_rec_header' to eliminate
>    various structure typedefs (Brian).
> 
>  fs/xfs/xfs_log.c         |  4 +---
>  fs/xfs/xfs_log_recover.c | 49 ++++++++++++++--------------------------
>  2 files changed, 18 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ad0c69ee8947..7a4ba408a3a2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1604,9 +1604,7 @@ xlog_cksum(
>  		int		i;
>  		int		xheads;
>  
> -		xheads = size / XLOG_HEADER_CYCLE_SIZE;
> -		if (size % XLOG_HEADER_CYCLE_SIZE)
> -			xheads++;
> +		xheads = DIV_ROUND_UP(size, XLOG_HEADER_CYCLE_SIZE);
>  
>  		for (i = 1; i < xheads; i++) {
>  			crc = crc32c(crc, &xhdr[i].hic_xheader,
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 782ec3eeab4d..12cde89c090b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -371,6 +371,19 @@ xlog_find_verify_cycle(
>  	return error;
>  }
>  
> +static inline int
> +xlog_logrec_hblks(struct xlog *log, struct xlog_rec_header *rh)
> +{
> +	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> +		int	h_size = be32_to_cpu(rh->h_size);
> +
> +		if ((be32_to_cpu(rh->h_version) & XLOG_VERSION_2) &&
> +		    h_size > XLOG_HEADER_CYCLE_SIZE)
> +			return DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
> +	}
> +	return 1;
> +}
> +
>  /*
>   * Potentially backup over partial log record write.
>   *
> @@ -463,15 +476,7 @@ xlog_find_verify_log_record(
>  	 * reset last_blk.  Only when last_blk points in the middle of a log
>  	 * record do we update last_blk.
>  	 */
> -	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> -		uint	h_size = be32_to_cpu(head->h_size);
> -
> -		xhdrs = h_size / XLOG_HEADER_CYCLE_SIZE;
> -		if (h_size % XLOG_HEADER_CYCLE_SIZE)
> -			xhdrs++;
> -	} else {
> -		xhdrs = 1;
> -	}
> +	xhdrs = xlog_logrec_hblks(log, head);
>  
>  	if (*last_blk - i + extra_bblks !=
>  	    BTOBB(be32_to_cpu(head->h_len)) + xhdrs)
> @@ -1158,22 +1163,7 @@ xlog_check_unmount_rec(
>  	 * below. We won't want to clear the unmount record if there is one, so
>  	 * we pass the lsn of the unmount record rather than the block after it.
>  	 */
> -	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> -		int	h_size = be32_to_cpu(rhead->h_size);
> -		int	h_version = be32_to_cpu(rhead->h_version);
> -
> -		if ((h_version & XLOG_VERSION_2) &&
> -		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
> -			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> -			if (h_size % XLOG_HEADER_CYCLE_SIZE)
> -				hblks++;
> -		} else {
> -			hblks = 1;
> -		}
> -	} else {
> -		hblks = 1;
> -	}
> -
> +	hblks = xlog_logrec_hblks(log, rhead);
>  	after_umount_blk = xlog_wrap_logbno(log,
>  			rhead_blk + hblks + BTOBB(be32_to_cpu(rhead->h_len)));
>  
> @@ -2989,15 +2979,10 @@ xlog_do_recovery_pass(
>  		if (error)
>  			goto bread_err1;
>  
> -		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
> -		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
> -			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> -			if (h_size % XLOG_HEADER_CYCLE_SIZE)
> -				hblks++;
> +		hblks = xlog_logrec_hblks(log, rhead);
> +		if (hblks != 1) {
>  			kmem_free(hbp);
>  			hbp = xlog_alloc_buffer(log, hblks);
> -		} else {
> -			hblks = 1;
>  		}
>  	} else {
>  		ASSERT(log->l_sectBBsize == 1);
> -- 
> 2.18.1
> 
