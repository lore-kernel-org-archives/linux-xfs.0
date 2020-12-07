Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECEFC4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6932388E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgLGRaT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:30:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbgLGRaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:30:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607362132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z1mzwpPklpdNpciM0MKkkQE3USYuYGTHjPrwZeuQL7k=;
        b=CVNBcimPoCrYchB47PQAjVzKxgnIw0Mgi5uEhUKrz1YheYgA1LNvpnZilfp45KKb3+zcmI
        Fgw3jpkolwK61lEhrRI8WZZESyqspwgJo1+Oc3FaKEq2muw5pLeYmiAQFUGuLXGwWQpnjp
        mqaSn/6gFX33pqveMQ90rmN0T2kPk4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-8fXUXXcwOjehupqCiX5S6w-1; Mon, 07 Dec 2020 12:28:51 -0500
X-MC-Unique: 8fXUXXcwOjehupqCiX5S6w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1235C800D53;
        Mon,  7 Dec 2020 17:28:50 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A17C26EF40;
        Mon,  7 Dec 2020 17:28:49 +0000 (UTC)
Date:   Mon, 7 Dec 2020 12:28:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: trace log intent item recovery failures
Message-ID: <20201207172847.GA1598552@bfoster>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
 <160729624812.1607103.14927905190925127101.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729624812.1607103.14927905190925127101.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:10:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a trace point so that we can capture when a recovered log intent
> item fails to recover.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_recover.c |    5 ++++-
>  fs/xfs/xfs_trace.h       |   18 ++++++++++++++++++
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 86951652d3ed..8fdb51eac1af 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -103,6 +103,24 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
>  DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
>  DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
>  
> +TRACE_EVENT(xlog_intent_recovery_failed,
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
> +	TP_printk("dev %d:%d error %d function %pS",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->error, __entry->caller_ip)
> +);
> +

Nit: I'd still swap out all of the caller_ip naming for clarity, but
otherwise LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  DECLARE_EVENT_CLASS(xfs_perag_class,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
>  		 unsigned long caller_ip),
> 

