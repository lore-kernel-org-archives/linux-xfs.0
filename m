Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 53CF87F73
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 15:53:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E943AAC004
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 13:53:08 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TcU4XAGjQpMY7Gow for <xfs@oss.sgi.com>;
	Mon, 11 Feb 2013 13:53:07 -0800 (PST)
Date: Tue, 12 Feb 2013 08:53:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/2] xfs: recheck buffer pinned status after push
	trylock failure
Message-ID: <20130211215305.GF8257@dastard>
References: <1360595302-15865-1-git-send-email-bfoster@redhat.com>
	<1360595302-15865-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360595302-15865-2-git-send-email-bfoster@redhat.com>
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

On Mon, Feb 11, 2013 at 10:08:21AM -0500, Brian Foster wrote:
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

Looks good, doesn't seem to cause any problems I can see here.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
