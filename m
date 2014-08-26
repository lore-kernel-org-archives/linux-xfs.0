Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F2FFD7F3F
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 07:42:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E18C730404E
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 05:42:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HwuN3GuPgcFXTGuh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Aug 2014 05:42:00 -0700 (PDT)
Date: Tue, 26 Aug 2014 08:41:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: recovery of XLOG_UNMOUNT_TRANS leaks memory
Message-ID: <20140826124156.GC52815@bfoster.bfoster>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
	<1409016101-9511-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409016101-9511-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 26, 2014 at 11:21:39AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It aborts recovery without freeing the current trans structure that
> we are decoding.
> 

What do you mean by "aborts recovery?" I don't see anything in the code
that reflects that behavior. Do you mean it's an on-disk marker for
completion?

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_recover.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1970732f..460cf98 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3587,8 +3587,9 @@ xlog_recovery_process_ophdr(
>  	/* unexpected flag values */
>  	case XLOG_UNMOUNT_TRANS:
>  		xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
> -		error = 0;
> -		break;
> +		xlog_recover_free_trans(trans);
> +		return 0;
> +

The change to return here seems superfluous. It's fine, but just to
check, were you intending to alter behavior in some way (e.g., return
from xlog_recover_process_data())?

Brian

>  	case XLOG_START_TRANS:
>  		xfs_warn(log->l_mp, "%s: bad transaction 0x%x", __func__, tid);
>  		ASSERT(0);
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
