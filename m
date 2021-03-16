Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890A2C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 18:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C6F86511A
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 18:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhCPSkW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 14:40:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231795AbhCPSkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 14:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615920004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vlcOIho7oS06PwlS1bupwFo01H9lJxyiAFDQ93lQ7qE=;
        b=XE+mFUk9DACcz9GtiZYzg8x8NRvYfZ7zcrJ5E0e9xh1Gl9AlJv9TEcDugWPcu/sqgnVS1H
        ZtldYZej3/IFXgKyt6zHBxFwbk3IEPoeyCu51WAgkYSAbnt0w8AXVbPR/ZW/GqdgE1kHjZ
        TmZUR76hPUkkADHaHLIGEYoNuWu0YT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-xe72ekF6NTmtPklmHAdLHQ-1; Tue, 16 Mar 2021 14:40:02 -0400
X-MC-Unique: xe72ekF6NTmtPklmHAdLHQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AA1269753;
        Tue, 16 Mar 2021 18:40:01 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DF265C1A3;
        Tue, 16 Mar 2021 18:40:01 +0000 (UTC)
Date:   Tue, 16 Mar 2021 14:39:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/45] xfs: introduce xlog_write_single()
Message-ID: <YFD7f+7h54WOIfKx@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-29-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-29-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:26PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce an optimised version of xlog_write() that is used when the
> entire write will fit in a single iclog. This greatly simplifies the
> implementation of writing a log vector chain into an iclog, and sets
> the ground work for a much more understandable xlog_write()
> implementation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 22f97914ab99..590c1e6db475 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2214,6 +2214,52 @@ xlog_write_copy_finish(
>  	return error;
>  }
>  
> +/*
> + * Write log vectors into a single iclog which is guaranteed by the caller
> + * to have enough space to write the entire log vector into. Return the number
> + * of log vectors written into the iclog.
> + */
> +static int
> +xlog_write_single(
> +	struct xfs_log_vec	*log_vector,
> +	struct xlog_ticket	*ticket,
> +	struct xlog_in_core	*iclog,
> +	uint32_t		log_offset,
> +	uint32_t		len)
> +{
> +	struct xfs_log_vec	*lv = log_vector;

This is initialized here and in the loop below.

> +	void			*ptr;
> +	int			index = 0;
> +	int			record_cnt = 0;
> +
> +	ASSERT(log_offset + len <= iclog->ic_size);
> +
> +	ptr = iclog->ic_datap + log_offset;
> +	for (lv = log_vector; lv; lv = lv->lv_next) {
> +		/*
> +		 * Ordered log vectors have no regions to write so this
> +		 * loop will naturally skip them.
> +		 */
> +		for (index = 0; index < lv->lv_niovecs; index++) {
> +			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> +			struct xlog_op_header	*ophdr = reg->i_addr;
> +
> +			ASSERT(reg->i_len % sizeof(int32_t) == 0);
> +			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> +
> +			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +			ophdr->oh_len = cpu_to_be32(reg->i_len -
> +						sizeof(struct xlog_op_header));

Perhaps we should retain the xlog_verify_dest_ptr() call here? It's
DEBUG code and otherwise compiled out, so shouldn't impact production

> +			memcpy(ptr, reg->i_addr, reg->i_len);
> +			xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
> +			record_cnt++;
> +		}
> +	}
> +	ASSERT(len == 0);
> +	return record_cnt;
> +}
> +
> +
>  /*
>   * Write some region out to in-core log
>   *
> @@ -2294,7 +2340,6 @@ xlog_write(
>  			return error;
>  
>  		ASSERT(log_offset <= iclog->ic_size - 1);
> -		ptr = iclog->ic_datap + log_offset;
>  
>  		/* Start_lsn is the first lsn written to. */
>  		if (start_lsn && !*start_lsn)
> @@ -2311,10 +2356,20 @@ xlog_write(
>  						XLOG_ICL_NEED_FUA);
>  		}
>  
> +		/* If this is a single iclog write, go fast... */
> +		if (!contwr && lv == log_vector) {
> +			record_cnt = xlog_write_single(lv, ticket, iclog,
> +						log_offset, len);
> +			len = 0;

I assume this is here to satisfy the assert further down in the
function.. This seems a bit contrived when you consider we pass len to
the helper, the helper reduces it and asserts that it goes to zero, then
we do so again here just for another assert. Unless this is all just
removed later, it might be more straightforward to pass a reference.

> +			data_cnt = len;

Similarly, this looks a bit odd because it seems data_cnt should be zero
in the case where contwr == 0. xlog_state_get_iclog_space() has already
bumped ->ic_offset by len (so xlog_state_finish_copy() doesn't need to
via data_cnt).

Brian

> +			break;
> +		}
> +
>  		/*
>  		 * This loop writes out as many regions as can fit in the amount
>  		 * of space which was allocated by xlog_state_get_iclog_space().
>  		 */
> +		ptr = iclog->ic_datap + log_offset;
>  		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  			struct xfs_log_iovec	*reg;
>  			struct xlog_op_header	*ophdr;
> -- 
> 2.28.0
> 

