Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6C5C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC5B23A1B
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:23:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qnmrcc1w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIVPX2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:23:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbgIVPX1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 11:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600788206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S485Mlxl64jXqcXpsFb4SBI72adRLrhWBFjmxj0FDlA=;
        b=Qnmrcc1wswY0RYuD1lX46U8JzRAAQQ5b3gTqSuNp4VflnoIqengFj+x4BqOoJyFi+d0k1l
        QpBuR8c+IEyo77aRmSPc35zi68b1WRoGIaZIW2VR2qVgBGlFQMSCO6+TTEW3ZJP6wmEiaq
        1JXIu0QvHTchqszFnZ2HklYuTDYCwqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-1R-e8nI5OGC1bOO7lo_gqQ-1; Tue, 22 Sep 2020 11:23:24 -0400
X-MC-Unique: 1R-e8nI5OGC1bOO7lo_gqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70C75195E3FB;
        Tue, 22 Sep 2020 15:23:07 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C96BB5577B;
        Tue, 22 Sep 2020 15:22:50 +0000 (UTC)
Date:   Tue, 22 Sep 2020 11:22:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/2] xfs: clean up calculation of LR header blocks
Message-ID: <20200922152248.GC2175303@bfoster>
References: <20200917051341.9811-1-hsiangkao@redhat.com>
 <20200917051341.9811-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917051341.9811-3-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 01:13:41PM +0800, Gao Xiang wrote:
> Let's use DIV_ROUND_UP() to calculate log record header
> blocks as what did in xlog_get_iclog_buffer_size() and
> wrap up a common helper for log recovery.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> v2: https://lore.kernel.org/r/20200904082516.31205-3-hsiangkao@redhat.com
> 
> changes since v2:
>  - get rid of xlog_logrecv2_hblks() and use xlog_logrec_hblks()
>    entirely (Brian).
> 
>  fs/xfs/xfs_log.c         |  4 +---
>  fs/xfs/xfs_log_recover.c | 48 ++++++++++++++--------------------------
>  2 files changed, 17 insertions(+), 35 deletions(-)
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
> index 782ec3eeab4d..28dd98b5a703 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -371,6 +371,18 @@ xlog_find_verify_cycle(
>  	return error;
>  }
>  
> +static inline int xlog_logrec_hblks(struct xlog *log, xlog_rec_header_t *rh)
> +{

We're trying to gradually eliminate various structure typedefs so it's
frowned upon to introduce new instances. If you replace the above with
'struct xlog_rec_header,' the rest looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
> @@ -463,15 +475,7 @@ xlog_find_verify_log_record(
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
> @@ -1158,22 +1162,7 @@ xlog_check_unmount_rec(
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
> @@ -2989,15 +2978,10 @@ xlog_do_recovery_pass(
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

