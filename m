Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A44FF7F3F
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 10:26:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A8DDAC002
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 08:26:47 -0700 (PDT)
Date: Mon, 7 Jul 2014 11:26:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: fix cil push sequence after log recovery
Message-ID: <20140707152641.GC4123@laptop.bfoster>
References: <20140702143206.438456679@sgi.com>
	<20140702144139.978978390@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140702144139.978978390@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 02, 2014 at 09:32:11AM -0500, Mark Tinguely wrote:
> The CIL pushes are marked complete with transaction
> tickets and should be in the the correct sequence order.
> The back end of the cil push code uses the ctx->commit_lsn
> to make sure all previous pushes are complete before adding
> the commit ticket for the current cil push. Because
> xlog_cil_init_post_recovery sets the ctx->commit_lsn,
> the later pushes can incorrectly think that the first
> sequence push is complete and allow out of order cil
> completion records to be written to the log. If the
> system crashes, the log will be replayed in the
> wrong order.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_log_cil.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: b/fs/xfs/xfs_log_cil.c
> ===================================================================
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -78,8 +78,6 @@ xlog_cil_init_post_recovery(
>  {
>  	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
>  	log->l_cilp->xc_ctx->sequence = 1;
> -	log->l_cilp->xc_ctx->commit_lsn = xlog_assign_lsn(log->l_curr_cycle,
> -								log->l_curr_block);

So we set ctx->commit_lsn here, this ctx is open for business and
sometime later it's committed. If a subsequent ctx is pushed before this
one has committed, commit_lsn is already set and thus the wait checks in
xlog_cil_push(), etc. are bypassed.

The fix seems logical to me, though I'm curious if there was some
original reason for setting commit_lsn here (it looks like this and the
xlog_wait() bits both go back to the original delayed logging commit).

It also seems that the dependence on l_curr_cycle and l_curr_block is
the only reason for the existence of this post-recovery function. Can we
move the ticket alloc and kill it if the commit_lsn assignment goes
away?

Brian

>  }
>  
>  /*
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
