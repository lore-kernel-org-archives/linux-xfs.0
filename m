Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BK9KYQ003204 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 15:09:20 -0500
Subject: Re: [PATCH 1/2] xfs: don't serialise direct IO reads on page cache
	checks
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1312785628-10561-2-git-send-email-david@fromorbit.com>
References: <1312785628-10561-1-git-send-email-david@fromorbit.com>
	<1312785628-10561-2-git-send-email-david@fromorbit.com>
Date: Thu, 11 Aug 2011 15:09:14 -0500
Message-ID: <1313093354.2899.91.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-08-08 at 16:40 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is no need to grab the i_mutex of the IO lock in exclusive
> mode if we don't need to invalidate the page cache. Taking these
> locks on every direct IO effective serialises them as taking the IO
> lock in exclusive mode has to wait for all shared holders to drop
> the lock. That only happens when IO is complete, so effective it
> prevents dispatch of concurrent direct IO reads to the same inode.
> 
> Fix this by taking the IO lock shared to check the page cache state,
> and only then drop it and take the IO lock exclusively if there is
> work to be done. Hence for the normal direct IO case, no exclusive
> locking will occur.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Tested-by: Joern Engel <joern@logfs.org>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
