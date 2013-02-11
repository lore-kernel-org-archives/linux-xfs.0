Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A1667F73
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 15:53:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A929304053
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 13:53:27 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DIqJENc2Pe29but2 for <xfs@oss.sgi.com>;
	Mon, 11 Feb 2013 13:53:26 -0800 (PST)
Date: Tue, 12 Feb 2013 08:53:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 2/2] xfs: remove log force from xfs_buf_trylock()
Message-ID: <20130211215324.GG8257@dastard>
References: <1360595302-15865-1-git-send-email-bfoster@redhat.com>
	<1360595302-15865-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360595302-15865-3-git-send-email-bfoster@redhat.com>
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

On Mon, Feb 11, 2013 at 10:08:22AM -0500, Brian Foster wrote:
> The trylock log force invoked via xfs_buf_item_push() can attempt
> to acquire xa_lock, thus leading to a recursion bug when called
> with xa_lock held.
> 
> This log force was originally added to xfs_buf_trylock() to address
> xfsaild stalls due to pinned and stale buffers. Since the addition
> of this behavior, the log item pushing code had been reworked to
> detect and track pinned items to inform xfsaild to issue a log
> force itself when necessary. As such, the log force on trylock
> failure is redundant and safe to remove.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
