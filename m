Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54B5C4CECE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A17521835
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:13:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZghjgVva"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388235AbfJNRNC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 13:13:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48768 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387910AbfJNRNC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 13:13:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EH9qbr029431;
        Mon, 14 Oct 2019 17:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=UVLC+E209EGtPM/JXRVAGlV+1fgd+evXadddScTsJ4E=;
 b=ZghjgVvafDCWM48haMCnKfSdi/8wWyvLOXYtNiU6D4NP4DYVaEPBCV5p6Fbwq7dl1kkG
 z9sDOeQDaKsctS881+xIIhwWQiMecavC27kzMqLVmb1kBhreRPm2MXjdAkAuZ0tVMm/b
 UVAw62Dch7bLYDPfwFP8fT/ehkbyLroDyjPVRUtim59tO6L1TSk/tJ8HZmprFvFHRQRN
 nTzEBa753S3ihlV8ZnrdSZ0UTGvyF8c8893JcfS4NV1tbbGfmBOAYetNBrLGlKcu7OJU
 pJznBYtSEcUcmijiP8fTZuQA6ohazTFmzPF6y28RGBmy5uhq4h9JvM1Lypq30UzdtE6K 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vk6sqabq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:12:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EH7wFu149572;
        Mon, 14 Oct 2019 17:12:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vkry6r56m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:12:57 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9EHCurq016365;
        Mon, 14 Oct 2019 17:12:56 GMT
Received: from localhost (/10.159.144.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 17:12:56 +0000
Date:   Mon, 14 Oct 2019 10:12:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: remove the unused ic_io_size field from
 xlog_in_core
Message-ID: <20191014171255.GV13108@magnolia>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:42PM +0200, Christoph Hellwig wrote:
> ic_io_size is only used inside xlog_write_iclog, where we can just use
> the count parameter intead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c      | 6 ++----
>  fs/xfs/xfs_log_priv.h | 3 ---
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index cd90871c2101..4f5927ddfa40 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1740,8 +1740,6 @@ xlog_write_iclog(
>  		return;
>  	}
>  
> -	iclog->ic_io_size = count;
> -
>  	bio_init(&iclog->ic_bio, iclog->ic_bvec, howmany(count, PAGE_SIZE));
>  	bio_set_dev(&iclog->ic_bio, log->l_targ->bt_bdev);
>  	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
> @@ -1751,9 +1749,9 @@ xlog_write_iclog(
>  	if (need_flush)
>  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
>  
> -	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, iclog->ic_io_size);
> +	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
>  	if (is_vmalloc_addr(iclog->ic_data))
> -		flush_kernel_vmap_range(iclog->ic_data, iclog->ic_io_size);
> +		flush_kernel_vmap_range(iclog->ic_data, count);
>  
>  	/*
>  	 * If this log buffer would straddle the end of the log we will have
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b880c23cb6e4..90e210e433cf 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -179,8 +179,6 @@ typedef struct xlog_ticket {
>   * - ic_next is the pointer to the next iclog in the ring.
>   * - ic_log is a pointer back to the global log structure.
>   * - ic_size is the full size of the log buffer, minus the cycle headers.
> - * - ic_io_size is the size of the currently pending log buffer write, which
> - *	might be smaller than ic_size
>   * - ic_offset is the current number of bytes written to in this iclog.
>   * - ic_refcnt is bumped when someone is writing to the log.
>   * - ic_state is the state of the iclog.
> @@ -205,7 +203,6 @@ typedef struct xlog_in_core {
>  	struct xlog_in_core	*ic_prev;
>  	struct xlog		*ic_log;
>  	u32			ic_size;
> -	u32			ic_io_size;
>  	u32			ic_offset;
>  	unsigned short		ic_state;
>  	char			*ic_datap;	/* pointer to iclog data */
> -- 
> 2.20.1
> 
