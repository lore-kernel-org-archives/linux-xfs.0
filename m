Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C117DC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 20:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8097622A83
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 20:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbhAZFSs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:18:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727843AbhAYSrF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 13:47:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611600338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MCu9FAVyIHqihXASR/XIkfHjxyzxgupSX11c6DzFK0s=;
        b=JVO3lmxSa8vbAHtfpaCbIzttjY7Zmvhk4qh4u7zjqFpgTZCyte0oSujUbKjgwRW7jP4t+q
        sO3Qp8AfSQpRULq/tIqGNuFmhdw+pjy1yrVyHwSyMUV0tZZRkeKHElCsDhAGbn6nQp66wc
        FzQbqfqez7VsSfCcoyxMo4MZ0aXDfu8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-rEBcYHy5Pjyx_4uWcjuT6w-1; Mon, 25 Jan 2021 13:45:33 -0500
X-MC-Unique: rEBcYHy5Pjyx_4uWcjuT6w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CC578143EB;
        Mon, 25 Jan 2021 18:45:32 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0B1D19C47;
        Mon, 25 Jan 2021 18:45:31 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:45:30 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 09/11] xfs: add a tracepoint for blockgc scans
Message-ID: <20210125184530.GM2047559@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142796954.2171939.15250362023143903757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142796954.2171939.15250362023143903757.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:52:49AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some tracepoints so that we can observe when the speculative
> preallocation garbage collector runs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c |    2 ++
>  fs/xfs/xfs_trace.c |    1 +
>  fs/xfs/xfs_trace.h |   39 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 42 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 952eca338807..da407934364c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -2356,6 +2356,8 @@ xfs_file_ioctl(
>  		if (error)
>  			return error;
>  
> +		trace_xfs_ioc_free_eofblocks(mp, &keofb, _RET_IP_);
> +
>  		sb_start_write(mp->m_super);
>  		error = xfs_icache_free_eofblocks(mp, &keofb);
>  		sb_end_write(mp->m_super);
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index 120398a37c2a..9b8d703dc9fd 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -29,6 +29,7 @@
>  #include "xfs_filestream.h"
>  #include "xfs_fsmap.h"
>  #include "xfs_btree_staging.h"
> +#include "xfs_icache.h"
>  
>  /*
>   * We include this last to have the helpers above available for the trace
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 407c3a5208ab..4cbf446bae9a 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -37,6 +37,7 @@ struct xfs_trans_res;
>  struct xfs_inobt_rec_incore;
>  union xfs_btree_ptr;
>  struct xfs_dqtrx;
> +struct xfs_eofblocks;
>  
>  #define XFS_ATTR_FILTER_FLAGS \
>  	{ XFS_ATTR_ROOT,	"ROOT" }, \
> @@ -3888,6 +3889,44 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
>  DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
>  DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
>  
> +DECLARE_EVENT_CLASS(xfs_eofblocks_class,
> +	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb,
> +		 unsigned long caller_ip),
> +	TP_ARGS(mp, eofb, caller_ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(__u32, flags)
> +		__field(uint32_t, uid)
> +		__field(uint32_t, gid)
> +		__field(prid_t, prid)
> +		__field(__u64, min_file_size)
> +		__field(unsigned long, caller_ip)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->flags = eofb->eof_flags;
> +		__entry->uid = from_kuid(mp->m_super->s_user_ns, eofb->eof_uid);
> +		__entry->gid = from_kgid(mp->m_super->s_user_ns, eofb->eof_gid);
> +		__entry->prid = eofb->eof_prid;
> +		__entry->min_file_size = eofb->eof_min_file_size;
> +		__entry->caller_ip = caller_ip;
> +	),
> +	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu caller %pS",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->flags,
> +		  __entry->uid,
> +		  __entry->gid,
> +		  __entry->prid,
> +		  __entry->min_file_size,
> +		  (char *)__entry->caller_ip)
> +);
> +#define DEFINE_EOFBLOCKS_EVENT(name)	\
> +DEFINE_EVENT(xfs_eofblocks_class, name,	\
> +	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb, \
> +		 unsigned long caller_ip), \
> +	TP_ARGS(mp, eofb, caller_ip))
> +DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 

