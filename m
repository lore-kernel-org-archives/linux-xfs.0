Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830B3C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 11:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4641520684
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 11:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Osckwb5s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgIDL1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:27:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22117 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730205AbgIDL0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 07:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599218756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8BIKFR1pM/3NwoCXzlWerY2LwOyTaxWq4LD956AaKNE=;
        b=Osckwb5sSclIbzkroMKpG0PAoXSwpNSv2lHtRqelI2EWNVi4+A6RN6VBjUFh7sMQPG4UGv
        LRVpaTsDLiQKVioFHvHdsrqKZwKHoo+k2QqW6gX2BXGsfwKuNHaivh58azt1Dp3cZslJ3B
        0Z4N+22XTNeQNthOHd2rGARy6lNu9P4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-mA0W8wwiPEGy0_P1QmDqow-1; Fri, 04 Sep 2020 07:25:54 -0400
X-MC-Unique: mA0W8wwiPEGy0_P1QmDqow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBA941007470;
        Fri,  4 Sep 2020 11:25:53 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 577A87EED7;
        Fri,  4 Sep 2020 11:25:50 +0000 (UTC)
Date:   Fri, 4 Sep 2020 07:25:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] xfs: clean up calculation of LR header blocks
Message-ID: <20200904112548.GC529978@bfoster>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
 <20200904082516.31205-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904082516.31205-3-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 04:25:16PM +0800, Gao Xiang wrote:
> Let's use DIV_ROUND_UP() to calculate log record header
> blocks as what did in xlog_get_iclog_buffer_size() and
> wrap up common helpers for log recovery.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> v1: https://lore.kernel.org/r/20200902140923.24392-1-hsiangkao@redhat.com
> 
> changes since v1:
>  - add another helper xlog_logrec_hblks() for the cases with
>    xfs_sb_version_haslogv2(), and use xlog_logrecv2_hblks()
>    for the case of xlog_do_recovery_pass() since it has more
>    complex logic other than just calculate hblks...
> 
>  fs/xfs/xfs_log.c         |  4 +--
>  fs/xfs/xfs_log_recover.c | 53 ++++++++++++++++------------------------
>  2 files changed, 22 insertions(+), 35 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 28d952794bfa..c6163065f6e0 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -397,6 +397,23 @@ xlog_find_verify_cycle(
>  	return error;
>  }
>  
> +static inline int xlog_logrecv2_hblks(struct xlog_rec_header *rh)
> +{
> +	int	h_size = be32_to_cpu(rh->h_size);
> +
> +	if ((be32_to_cpu(rh->h_version) & XLOG_VERSION_2) &&
> +	    h_size > XLOG_HEADER_CYCLE_SIZE)
> +		return DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
> +	return 1;
> +}
> +
> +static inline int xlog_logrec_hblks(struct xlog *log, xlog_rec_header_t *rh)
> +{
> +	if (!xfs_sb_version_haslogv2(&log->l_mp->m_sb))
> +		return 1;
> +	return xlog_logrecv2_hblks(rh);
> +}
> +

h_version is assigned based on xfs_sb_version_haslogv2() in the first
place so I'm not sure I see the need for multiple helpers like this, at
least with the current code. I can't really speak to why some code
checks the feature bit and/or the record header version and not the
other way around, but perhaps there's some historical reason I'm not
aware of. Regardless, is there ever a case where
xfs_sb_version_haslogv2() == true and h_version != 2? That strikes me as
more of a corruption scenario than anything..

Brian

>  /*
>   * Potentially backup over partial log record write.
>   *
> @@ -489,15 +506,7 @@ xlog_find_verify_log_record(
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
> @@ -1184,22 +1193,7 @@ xlog_check_unmount_rec(
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
> @@ -3024,15 +3018,10 @@ xlog_do_recovery_pass(
>  		if (error)
>  			goto bread_err1;
>  
> -		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
> -		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
> -			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> -			if (h_size % XLOG_HEADER_CYCLE_SIZE)
> -				hblks++;
> +		hblks = xlog_logrecv2_hblks(rhead);
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

