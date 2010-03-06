Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o269oH3x075338 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 03:50:20 -0600
Date: Sat, 6 Mar 2010 04:51:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix dquot trace format
Message-ID: <20100306095145.GA21173@infradead.org>
References: <20100214220144.GA10548@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100214220144.GA10548@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com, xfs@oss.sgi.com

Alex, it looks like this never got picked up?

On Sun, Feb 14, 2010 at 05:01:45PM -0500, Christoph Hellwig wrote:
> 
> The be32_to_cpu in the TP_printk output breaks automatic parsing of
> the trace format by the trace-cmd tools, so we have to move it into
> the TP_assign block.  While we're at it also fix the format for the
> quota limits to more regular and easier parseable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-02-12 20:26:31.506274631 +0100
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h	2010-02-12 20:32:17.319255704 +0100
> @@ -565,7 +565,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  	TP_ARGS(dqp),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
> -		__field(__be32, id)
> +		__field(u32, id)
>  		__field(unsigned, flags)
>  		__field(unsigned, nrefs)
>  		__field(unsigned long long, res_bcount)
> @@ -578,7 +578,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  	), \
>  	TP_fast_assign(
>  		__entry->dev = dqp->q_mount->m_super->s_dev;
> -		__entry->id = dqp->q_core.d_id;
> +		__entry->id = be32_to_cpu(dqp->q_core.d_id);
>  		__entry->flags = dqp->dq_flags;
>  		__entry->nrefs = dqp->q_nrefs;
>  		__entry->res_bcount = dqp->q_res_bcount;
> @@ -594,10 +594,10 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  			be64_to_cpu(dqp->q_core.d_ino_softlimit);
>  	),
>  	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u res_bc 0x%llx "
> -		  "bcnt 0x%llx [hard 0x%llx | soft 0x%llx] "
> -		  "icnt 0x%llx [hard 0x%llx | soft 0x%llx]",
> +		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
> +		  "icnt 0x%llx ihardlimit 0x%llx isoftlimit 0x%llx]",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -		  be32_to_cpu(__entry->id),
> +		  __entry->id,
>  		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
>  		  __entry->nrefs,
>  		  __entry->res_bcount,
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
