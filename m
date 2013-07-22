Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7DA137F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 13:53:46 -0500 (CDT)
Date: Mon, 22 Jul 2013 13:53:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Fix a deadlock in xfs_log_commit_cil() code path
Message-ID: <20130722185343.GB3111@sgi.com>
References: <1374273098.8941.2075.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374273098.8941.2075.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Fri, Jul 19, 2013 at 05:31:38PM -0500, Chandra Seetharaman wrote:
> 
> While testing and rearranging pquota/gquota code, I stumbled
> on a xfs_shutdown() during a mount. But the mount just hung.
> 
> Debugged and found that there is a deadlock involving
> &log->l_cilp->xc_ctx_lock.
> 
> It is in a code path where &log->l_cilp->xc_ctx_lock is first
> acquired in read mode and some levels down the same semaphore
> is being acquired in write mode causing a deadlock.
> 
> This is the stack:
> xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
>   xlog_print_tic_res
>     xfs_force_shutdown
>       xfs_log_force_umount
>         xlog_cil_force
>           xlog_cil_force_lsn
>             xlog_cil_push_foreground
>               xlog_cil_push - tries to acquire same semaphore in write mode
> 
> This patch fixes the deadlock by changing the reason code for
> xfs_force_shutdown in xlog_print_tic_res() to SHUTDOWN_LOG_IO_ERROR.
> 
> SHUTDOWN_LOG_IO_ERROR is the right reason code to be set since
> we are in the log path.
> 
> Thanks to Dave for suggesting this solution.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
