Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FBFE7F56
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 17:24:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B6E9304039
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 15:24:54 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KCB5GZVOtkQNkA3X for <xfs@oss.sgi.com>;
	Sun, 10 Feb 2013 15:24:51 -0800 (PST)
Date: Mon, 11 Feb 2013 10:24:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 1/2] xfs: recheck buffer pinned status after push
	trylock failure
Message-ID: <20130210232448.GD8257@dastard>
References: <1360335067-59999-1-git-send-email-bfoster@redhat.com>
	<1360335067-59999-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360335067-59999-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 08, 2013 at 09:51:06AM -0500, Brian Foster wrote:
> The buffer pinned check and trylock sequence in xfs_buf_item_push()
> can race with an active transaction on marking the buffer pinned.
> This can result in the buffer becoming pinned and stale after the
> initial check and the trylock failure, but before the check in
> xfs_buf_trylock() that issues a log force. If the log force is
> issued from this context, a spinlock recursion occurs on xa_lock.
> 
> Prepare xfs_buf_item_push() to handle the race by detecting a
> pinned buffer after the trylock failure so xfsaild issues a log
> force from a safe context. This, along with various previous fixes,
> renders the log force in xfs_buf_trylock() redundant.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 9c4c050..4e3a059 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -469,8 +469,15 @@ xfs_buf_item_push(
>  
>  	if (xfs_buf_ispinned(bp))
>  		return XFS_ITEM_PINNED;
> -	if (!xfs_buf_trylock(bp))
> +	if (!xfs_buf_trylock(bp)) {
> +		/*
> +		 * Check whether we've raced with the buffer being pinned so
> +		 * xfsaild will pend up a log force.

"pend up": never heard that one before. ;P

Perhaps "queue up" would be better?

As it is, the comment describes what the code is doing, not why we
are doing this check. i.e. "if we just raced with a buffer being
pinned and the buffer has been marked stale, we could end up
stalling until someone else issues a log force to unpin the stale
buffer. Hence, do an optimistic check for the race condition to get
this buffer moving along quickly if we hit it..."


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
