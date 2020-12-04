Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85549C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58AAF22AB0
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgLDOCY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:02:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387618AbgLDOCX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 09:02:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l1GS5zcYORTRwDSwfTviRNVKNO9WCwACYXygzVv4B1I=;
        b=cDm0UTHtN/xv4oSrYa9jRyDyo9UYgnSp745zNOIWoV7Goap1YBF1ocw5IV4BcAzqiylUTk
        9UgQjHgA7xGzam4pEnB/or9P16rKWrELiQnToXue2XmjpcsaDQWlwq9nkjEj8DYY8reSwg
        5eSuob0RiHH691Le+l4sBKtAaT8+p/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-4uezzPo5O2aTxrYsa9lZHg-1; Fri, 04 Dec 2020 09:00:55 -0500
X-MC-Unique: 4uezzPo5O2aTxrYsa9lZHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97C5581CBF6;
        Fri,  4 Dec 2020 14:00:54 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27017620D7;
        Fri,  4 Dec 2020 14:00:54 +0000 (UTC)
Date:   Fri, 4 Dec 2020 09:00:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: trace log intent item recovery failures
Message-ID: <20201204140052.GL1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704435695.734470.320027217185016602.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704435695.734470.320027217185016602.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:12:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a trace point so that we can capture when a recovered log intent
> item fails to recover.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_recover.c |    5 ++++-
>  fs/xfs/xfs_trace.h       |   19 +++++++++++++++++++
>  2 files changed, 23 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 87886b7f77da..ed92c72976c9 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2559,8 +2559,11 @@ xlog_recover_process_intents(
>  		spin_unlock(&ailp->ail_lock);
>  		error = lip->li_ops->iop_recover(lip, &capture_list);
>  		spin_lock(&ailp->ail_lock);
> -		if (error)
> +		if (error) {
> +			trace_xfs_error_return(log->l_mp, error,
> +					lip->li_ops->iop_recover);
>  			break;
> +		}
>  	}
>  
>  	xfs_trans_ail_cursor_done(&cur);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 86951652d3ed..99383b1acd49 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -103,6 +103,25 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
>  DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
>  DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
>  
> +TRACE_EVENT(xfs_error_return,

xfs_error_return seems rather vague of a name given the current use.

> +	TP_PROTO(struct xfs_mount *mp, int error, void *caller_ip),
> +	TP_ARGS(mp, error, caller_ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(int, error)
> +		__field(void *, caller_ip)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->error = error;
> +		__entry->caller_ip = caller_ip;
> +	),
> +	TP_printk("dev %d:%d error %d caller %pS",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->error, __entry->caller_ip)
> +

Extra whitespace. Also, using the text "caller" here is a bit misleading
IMO. I'd suggest just calling it "function" or some such, but not that
big of a deal.

Brian

> +);
> +
>  DECLARE_EVENT_CLASS(xfs_perag_class,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
>  		 unsigned long caller_ip),
> 

