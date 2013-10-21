Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3B4B7F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:58:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C39BAC001
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 13:58:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YkmIZXci5HP6xtuG for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 13:58:25 -0700 (PDT)
Message-ID: <5265956F.4010700@sandeen.net>
Date: Mon, 21 Oct 2013 15:58:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix possible NULL dereference
References: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
In-Reply-To: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
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
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, kernel-br@googlegroups.com, XFS FILESYSTEM <xfs@oss.sgi.com>

On 10/21/13 1:32 PM, Geyslan G. Bem wrote:
> This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
> dereferencing.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Hm, yeah - cmn_err(CE_PANIC, " " ); used to BUG_ON, but the newer
xfs_emerg() doesn't.

Dave, was that intentional?

I wonder if there are more spots after xfs_emerg()'s which aren't
defensive, because the code used to just panic there.

-Eric


> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/xfs/xfs_log.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a2dea108..8cdeb7e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3703,8 +3703,10 @@ xlog_verify_iclog(
>  	spin_lock(&log->l_icloglock);
>  	icptr = log->l_iclog;
>  	for (i=0; i < log->l_iclog_bufs; i++) {
> -		if (icptr == NULL)
> +		if (!icptr) {
>  			xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
> +			break;
> +		}
>  		icptr = icptr->ic_next;
>  	}
>  	if (icptr != log->l_iclog)
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
