Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70852C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D5F66508A
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbhCPO4B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 10:56:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237626AbhCPOzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 10:55:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615906541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oXpNpE/q63iMLxuPsRemeyADYyB9Vu/nXwuk776EPX8=;
        b=K7+siSBWfFu6OtALb4FXI9Tr7CVbIzAsyJIr26rSxvWPaHBr4L7bhP4Di4B9z4T0v0nDZt
        Zd7l/A7viJiMWfs1YZswFhUK8MaeZaK352bstOiBoehY0ArxYdVuol68Zyecibdjhz4O6R
        ZhF6LAZrkGo/5kJBT2zmK8bca4adhho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-EpIInxPAPiK_OJFsX7fYtw-1; Tue, 16 Mar 2021 10:55:37 -0400
X-MC-Unique: EpIInxPAPiK_OJFsX7fYtw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4166AEC1A4;
        Tue, 16 Mar 2021 14:55:36 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D479710023B0;
        Tue, 16 Mar 2021 14:55:35 +0000 (UTC)
Date:   Tue, 16 Mar 2021 10:55:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/45] xfs: log ticket region debug is largely useless
Message-ID: <YFDG5mYRTvSL1Wjo@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-27-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-27-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:24PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_tic_add_region() is used to trace the regions being added to a
> log ticket to provide information in the situation where a ticket
> reservation overrun occurs. The information gathered is stored int
> the ticket, and dumped if xlog_print_tic_res() is called.
> 
> For a front end struct xfs_trans overrun, the ticket only contains
> reservation tracking information - the ticket is never handed to the
> log so has no regions attached to it. The overrun debug information in this
> case comes from xlog_print_trans(), which walks the items attached
> to the transaction and dumps their attached formatted log vectors
> directly. It also dumps the ticket state, but that only contains
> reservation accounting and nothing else. Hence xlog_print_tic_res()
> never dumps region or overrun information from this path.
> 
> xlog_tic_add_region() is actually called from xlog_write(), which
> means it is being used to track the regions seen in a
> CIL checkpoint log vector chain. In looking at CIL behaviour
> recently, I've seen 32MB checkpoints regularly exceed 250,000
> regions in the LV chain. The log ticket debug code can track *15*
> regions. IOWs, if there is a ticket overrun in the CIL code, the
> ticket region tracking code is going to be completely useless for
> determining what went wrong. The only thing it can tell us is how
> much of an overrun occurred, and we really don't need extra debug
> information in the log ticket to tell us that.
> 
> Indeed, the main place we call xlog_tic_add_region() is also adding
> up the number of regions and the space used so that xlog_write()
> knows how much will be written to the log. This is exactly the same
> information that log ticket is storing once we take away the useless
> region tracking array. Hence xlog_tic_add_region() is not useful,
> but can be called 250,000 times a CIL push...
> 
> Just strip all that debug "information" out of the of the log ticket
> and only have it report reservation space information when an
> overrun occurs. This also reduces the size of a log ticket down by
> about 150 bytes...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 107 +++---------------------------------------
>  fs/xfs/xfs_log_priv.h |  17 -------
>  2 files changed, 6 insertions(+), 118 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 7f601c1c9f45..8ee6a5f74396 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -139,16 +139,6 @@ enum xlog_iclog_state {
>  /* Ticket reservation region accounting */ 
>  #define XLOG_TIC_LEN_MAX	15
>  

This is unused now.

> -/*
> - * Reservation region
> - * As would be stored in xfs_log_iovec but without the i_addr which
> - * we don't care about.
> - */
> -typedef struct xlog_res {
> -	uint	r_len;	/* region length		:4 */
> -	uint	r_type;	/* region's transaction type	:4 */
> -} xlog_res_t;
> -
>  typedef struct xlog_ticket {
>  	struct list_head   t_queue;	 /* reserve/write queue */
>  	struct task_struct *t_task;	 /* task that owns this ticket */
> @@ -159,13 +149,6 @@ typedef struct xlog_ticket {
>  	char		   t_ocnt;	 /* original count		 : 1  */
>  	char		   t_cnt;	 /* current count		 : 1  */
>  	char		   t_flags;	 /* properties of reservation	 : 1  */
> -
> -        /* reservation array fields */
> -	uint		   t_res_num;                    /* num in array : 4 */
> -	uint		   t_res_num_ophdrs;		 /* num op hdrs  : 4 */

I'm curious why we wouldn't want to retain the ophdr count..? That's
managed separately from the _add_region() bits and provides some info on
the total number of vectors, etc. Otherwise looks reasonable.

Brian

> -	uint		   t_res_arr_sum;		 /* array sum    : 4 */
> -	uint		   t_res_o_flow;		 /* sum overflow : 4 */
> -	xlog_res_t	   t_res_arr[XLOG_TIC_LEN_MAX];  /* array of res : 8 * 15 */ 
>  } xlog_ticket_t;
>  
>  /*
> -- 
> 2.28.0
> 

