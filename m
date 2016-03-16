Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 349F17CEB
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 06:40:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87383AC002
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 04:40:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zzjoo4PTeJyV6Svt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 04:40:23 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 45E9B64D13
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 11:40:22 +0000 (UTC)
Date: Wed, 16 Mar 2016 07:40:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] Add caller function output to xfs_log_force tracepoint
Message-ID: <20160316114020.GA8096@bfoster.bfoster>
References: <1458032019-31953-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458032019-31953-1-git-send-email-cmaiolino@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 15, 2016 at 09:53:39AM +0100, Carlos Maiolino wrote:
> I had sent this patch yesterday, but for some reason it didn't reach xfs list,
> sending again.
> 
> 
> Output the caller of xfs_log_force might be useful when tracing log checkpoint
> problems without the need to build kernel with DEBUG.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c   |  4 ++--
>  fs/xfs/xfs_trace.h | 10 ++++++----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b49ccf5..8c08015b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3378,7 +3378,7 @@ xfs_log_force(
>  {
>  	int	error;
>  
> -	trace_xfs_log_force(mp, 0);
> +	trace_xfs_log_force(mp, 0, _RET_IP_);
>  	error = _xfs_log_force(mp, flags, NULL);
>  	if (error)
>  		xfs_warn(mp, "%s: error %d returned.", __func__, error);
> @@ -3527,7 +3527,7 @@ xfs_log_force_lsn(
>  {
>  	int	error;
>  
> -	trace_xfs_log_force(mp, lsn);
> +	trace_xfs_log_force(mp, lsn, _RET_IP_);
>  	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
>  	if (error)
>  		xfs_warn(mp, "%s: error %d returned.", __func__, error);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index c8d5842..384bb17 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1053,19 +1053,21 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
>  )
>  
>  TRACE_EVENT(xfs_log_force,
> -	TP_PROTO(struct xfs_mount *mp, xfs_lsn_t lsn),
> -	TP_ARGS(mp, lsn),
> +	TP_PROTO(struct xfs_mount *mp, xfs_lsn_t lsn, unsigned long caller_ip),
> +	TP_ARGS(mp, lsn, caller_ip),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_lsn_t, lsn)
> +		__field(unsigned long, caller_ip)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp->m_super->s_dev;
>  		__entry->lsn = lsn;
> +		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d lsn 0x%llx",
> +	TP_printk("dev %d:%d lsn 0x%llx caller %ps",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -		  __entry->lsn)
> +		  __entry->lsn, (void *)__entry->caller_ip)
>  )
>  
>  #define DEFINE_LOG_ITEM_EVENT(name) \
> -- 
> 2.4.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
