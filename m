Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F7AD7F62
	for <xfs@oss.sgi.com>; Mon,  8 Apr 2013 15:59:19 -0500 (CDT)
Message-ID: <51632FA8.8020703@sgi.com>
Date: Mon, 08 Apr 2013 15:59:20 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Update xfs_log_commit_cil() comments
References: <515D34B2.9050807@oracle.com>
In-Reply-To: <515D34B2.9050807@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 04/04/13 03:07, Jeff Liu wrote:
> xfs_log_commit_iclog() function has been removed by commits 93b8a585:
> 	xfs: remove the deprecated nodelaylog option
>
> Beginning from Linux 3.3, only delayed logging is supported so that
> we call xfs_log_commit_cil() at xfs_trans_commit() only, remove the
> useless comments so.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---
>   fs/xfs/xfs_log_cil.c |    4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index ddc4529..e3d0b85 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -668,10 +668,6 @@ xlog_cil_push_foreground(
>    * transaction to the checkpoint context so we carry the busy extents through
>    * to checkpoint completion, and then unlock all the items in the transaction.
>    *
> - * For more specific information about the order of operations in
> - * xfs_log_commit_cil() please refer to the comments in
> - * xfs_trans_commit_iclog().
> - *
>    * Called with the context lock already held in read mode to lock out
>    * background commit, returns without it held once background commits are
>    * allowed again.

And the log is documented in 
Documents/filesystems/xfs-delayed-logging-design.txt.

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
