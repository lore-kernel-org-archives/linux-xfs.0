Return-Path: <xfs-bounces@oss.sgi.com>
Date: Mon, 13 Feb 2012 15:10:27 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] XFS; xfs_trans_add_item() - don't assign in ASSERT()
	when compare is intended
Message-ID: <20120213211027.GV8262@sgi.com>
References: <alpine.LNX.2.00.1202132149270.16039@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202132149270.16039@swampdragon.chaosbits.net>
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
To: Jesper Juhl <jj@chaosbits.net>
Cc: xfs-masters@oss.sgi.com, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 09:51:05PM +0100, Jesper Juhl wrote:
> It looks to me like the two ASSERT()s in xfs_trans_add_item() really
> want to do a compare (==) rather than assignment (=).
> This patch changes it from the former to the latter.
                                 latter        former

I'll update your comment as you suggested.

> I must admit though, that I don't know this code well and have only
> compile tested this change. But if assignment is really intended it
> really seems strange to do it as part of an ASSERT...
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  fs/xfs/xfs_trans.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 329b06a..7adcdf1 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1151,8 +1151,8 @@ xfs_trans_add_item(
>  {
>  	struct xfs_log_item_desc *lidp;
>  
> -	ASSERT(lip->li_mountp = tp->t_mountp);
> -	ASSERT(lip->li_ailp = tp->t_mountp->m_ail);
> +	ASSERT(lip->li_mountp == tp->t_mountp);
> +	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);

Yeah, nice find...  ;)
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
