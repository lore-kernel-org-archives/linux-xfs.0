Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E5137F89
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 22:50:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E658C8F8033
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:50:48 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zlgnKvyvIlgiyTMc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 20:50:47 -0800 (PST)
Message-ID: <5285A7FF.1000901@oracle.com>
Date: Fri, 15 Nov 2013 12:50:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/6] jfs: simplify lmLogSync() via
	list_last_entry_or_null()
References: <5285A483.3040009@oracle.com>
In-Reply-To: <5285A483.3040009@oracle.com>
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
To: shaggy@kernel.org
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, oleg@redhat.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

Hi Dave and all,

Please ignore this patch from this series.

On 11/15 2013 12:35 PM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Simplify the code in lmLogSync() via list_last_entry_or_null().
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/jfs/jfs_logmgr.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 7b565d0..2f90779 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -963,13 +963,9 @@ static int lmLogSync(struct jfs_log * log, int hard_sync)
>  
>  	if (log->sync == log->syncpt) {
>  		LOGSYNC_LOCK(log, flags);
> -		if (list_empty(&log->synclist))
> -			log->sync = log->lsn;
> -		else {
> -			lp = list_entry(log->synclist.next,
> -					struct logsyncblk, synclist);
> -			log->sync = lp->lsn;
> -		}
> +		lp = list_last_entry_or_null(&log->synclist, struct logsyncblk,
> +					     synclist);
Here it could be simplified via list_first_entry_or_null(), my apology for this mistake.
> +		log->sync = lp ? lp->lsn : log->lsn;
>  		LOGSYNC_UNLOCK(log, flags);
>  
>  	}
> 

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
