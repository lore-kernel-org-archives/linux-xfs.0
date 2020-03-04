Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B05C3F2CE
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 15:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 486C421739
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 15:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dAImu7s0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgCDPoW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 10:44:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51028 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgCDPoW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:44:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9yJ2OmB+WBFWB9anTuwdw9MSFkWvHB46i0YOPtAPJFY=; b=dAImu7s0DEJrbZMRyrnc0yIZZF
        z1th4SIMlGSJvrCYMEAVAOGtyMbckGeyaq3AppXo6QLnhsqO9Mo7sO+zz4PKFf3zcrKq80TgUI7ra
        qRDOH7iUdg89E7szXp8sxysVuaPY0zSEAZLGfKa2JNgiZfmfDy/dXUFOXwiy/7YlWAg6gycsZ4t8b
        DQHd6pO+W9EuO5kGbH1CY6W96GXK5D6/lkBizx0Zwqz/COjlKvk39EAklF4NkpKh8cYkmDjKxxx6O
        WGRdcuQ5DN6sOtwWvUAnzSVSVuVCy72sYgJXLBR1f298qRGelabVA8XyqPePCuzK5mHb5JsDIMdLK
        sfenfu9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9WC5-00072Q-T4; Wed, 04 Mar 2020 15:44:21 +0000
Date:   Wed, 4 Mar 2020 07:44:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200304154421.GA17565@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  /*
> - * Calculate the potential space needed by the log vector.  Each region gets
> - * its own xlog_op_header_t and may need to be double word aligned.
> + * Calculate the potential space needed by the log vector.  We may need a
> + * start record, and each region gets its own xlog_op_header_t and may need to
> + * be double word aligned.

s/xlog_op_header_t/struct xlog_op_header/ while you're at it.

> @@ -2404,25 +2391,29 @@ xlog_write(
>  	int			record_cnt = 0;
>  	int			data_cnt = 0;
>  	int			error = 0;
> +	int			start_rec_size = sizeof(struct xlog_op_header);
>  
>  	*start_lsn = 0;
>  
> -	len = xlog_write_calc_vec_length(ticket, log_vector);
>  
>  	/*
>  	 * Region headers and bytes are already accounted for.
>  	 * We only need to take into account start records and
>  	 * split regions in this function.
>  	 */
> -	if (ticket->t_flags & XLOG_TIC_INITED)
> +	if (ticket->t_flags & XLOG_TIC_INITED) {
>  		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +		ticket->t_flags &= ~XLOG_TIC_INITED;
> +	}
>  
>  	/*
>  	 * Commit record headers need to be accounted for. These
>  	 * come in as separate writes so are easy to detect.
>  	 */
> -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> +	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
>  		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +		start_rec_size = 0;
> +	}
>  
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2431,6 +2422,8 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> +	len = xlog_write_calc_vec_length(ticket, log_vector, start_rec_size);

The last arg is used as a boolean in xlog_write_calc_vec_length. I
think it would make sense to have a need_start_rec boolean in this
function as well, and just hardcode the sizeof in the two places that
actually need the size.

> +			copy_len += sizeof(xlog_op_header_t);

s/xlog_op_header_t/struct xlog_op_header/
