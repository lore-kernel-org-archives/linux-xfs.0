Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 326077F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 18:01:25 -0500 (CDT)
Date: Mon, 20 May 2013 18:01:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 11/14] xfs: remote attribute tail zeroing does too much
Message-ID: <20130520230121.GI20028@sgi.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369007481-15185-12-git-send-email-david@fromorbit.com>
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

On Mon, May 20, 2013 at 09:51:18AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When an attribute data does not fill then entire remote block, we
> zero the remaining part of the buffer. This, however, needs to take
> into account that the buffer has a header, and so the offset where
> zeroing starts and the length of zeroing need to take this into
> account. Otherwise we end up with zeros over the end of the
> attribute value when CRCs are enabled.
> 
> While there, make sure we only ask to map an extent that covers the
> remaining range of the attribute, rather than asking every time for
> the full length of remote data. If the remote attribute blocks are
> contiguous with other parts of the attribute tree, it will map those
> blocks as well and we can potentially zero them incorrectly. We can
> also get buffer size mistmatches when trying to read or remove the
> remote attribute, and this can lead to not finding the correct
> buffer when looking it up in cache.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_attr_remote.c |   37 ++++++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> index bcdc07c..e207bf0 100644
> --- a/fs/xfs/xfs_attr_remote.c
> +++ b/fs/xfs/xfs_attr_remote.c
> @@ -296,10 +296,7 @@ xfs_attr_rmtval_set(
>  	 * and we may not need that many, so we have to handle this when
>  	 * allocating the blocks below. 
>  	 */
> -	if (!crcs)
> -		blkcnt = XFS_B_TO_FSB(mp, args->valuelen);
> -	else
> -		blkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
> +	blkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);

Oh.  There you have it.  Nevermind.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
