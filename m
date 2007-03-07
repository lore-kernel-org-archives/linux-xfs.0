Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Mar 2007 04:06:04 -0800 (PST)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l27C5x6p028635
	for <xfs@oss.sgi.com>; Wed, 7 Mar 2007 04:06:00 -0800
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l27C5v3A021162
	for <xfs@oss.sgi.com>; Wed, 7 Mar 2007 04:05:57 -0800
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l27C64UH010619
	for <xfs@oss.sgi.com>; Wed, 7 Mar 2007 04:06:04 -0800
Message-ID: <45EEA92C.9080505@agami.com>
Date: Wed, 07 Mar 2007 17:29:40 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: use xfs_get_buf_noaddr for iclogs
References: <20070307101314.GB30587@lst.de>
In-Reply-To: <20070307101314.GB30587@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org, linux-kernel@vger.kernel.org

Does not look to me either.  Looks logical as well because these buffers 
are used only in log syncing and only one thread can be ever flushing 
one ICLOG and, hence, no need for protection.
        Even split buffer (log->l_xbuf) is used by only ICLOG at a time, 
should not matter. I don't see protection for this even today as no 
locking is done in split sync path.

-shailendra

Christoph Hellwig wrote:
> Currently xlog_alloc allocates memory for the iclogs first, then
> allocates a buffer using xfs_buf_get_empty and finally assigns
> the memory to the buffer.  We don't really want to do this, but
> rather allocate a buffer with memory attached to it using
> xfs_buf_get_noaddr.  There's a subtile change because
> xfs_buf_get_empty returns the buffer locked, but xfs_buf_get_noaddr
> returns it unlocked.  From my auditing and testing nothing in the
> log I/O code cares about this distincition, but I'd be happy if
> someone could try to prove this independently.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/xfs/xfs_log.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_log.c	2007-03-06 17:26:40.000000000 +0100
> +++ linux-2.6/fs/xfs/xfs_log.c	2007-03-06 17:28:03.000000000 +0100
> @@ -1199,11 +1199,16 @@
>  		*iclogp = (xlog_in_core_t *)
>  			  kmem_zalloc(sizeof(xlog_in_core_t), KM_SLEEP);
>  		iclog = *iclogp;
> -		iclog->hic_data = (xlog_in_core_2_t *)
> -			  kmem_zalloc(iclogsize, KM_SLEEP | KM_LARGE);
> -
>  		iclog->ic_prev = prev_iclog;
>  		prev_iclog = iclog;
> +
> +		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
> +		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
> +		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
> +		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
> +		iclog->ic_bp = bp;
> +		iclog->hic_data = bp->b_addr;
> +
>  		log->l_iclog_bak[i] = (xfs_caddr_t)&(iclog->ic_header);
>  
>  		head = &iclog->ic_header;
> @@ -1216,11 +1221,6 @@
>  		INT_SET(head->h_fmt, ARCH_CONVERT, XLOG_FMT);
>  		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
>  
> -		bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
> -		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
> -		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
> -		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
> -		iclog->ic_bp = bp;
>  
>  		iclog->ic_size = XFS_BUF_SIZE(bp) - log->l_iclog_hsize;
>  		iclog->ic_state = XLOG_STATE_ACTIVE;
> @@ -1229,7 +1229,6 @@
>  		iclog->ic_datap = (char *)iclog->hic_data + log->l_iclog_hsize;
>  
>  		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
> -		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
>  		sv_init(&iclog->ic_forcesema, SV_DEFAULT, "iclog-force");
>  		sv_init(&iclog->ic_writesema, SV_DEFAULT, "iclog-write");
>  
> @@ -1528,7 +1527,6 @@
>  		}
>  #endif
>  		next_iclog = iclog->ic_next;
> -		kmem_free(iclog->hic_data, log->l_iclog_size);
>  		kmem_free(iclog, sizeof(xlog_in_core_t));
>  		iclog = next_iclog;
>  	}
> 
> 
