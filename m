Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EMQjih151004 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:26:46 -0500
Subject: Re: [PATCH 11/18] xfs: kill XBF_FS_MANAGED buffers
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-12-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-12-git-send-email-david@fromorbit.com>
Date: Tue, 14 Sep 2010 17:26:38 -0500
Message-ID: <1284503198.9701.94.camel@doink>
Mime-Version: 1.0
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

On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Filesystem level managed buffers are buffers that have their
> lifecycle controlled by the filesystem layer, not the buffer cache.
> We currently cache these buffers, which makes cleanup and cache
> walking somewhat troublesome. Convert the fs managed buffers to
> uncached buffers obtained by via xfs_buf_get_uncached(), and remove
> the XBF_FS_MANAGED special cases from the buffer cache.

Looks good.  Nicer with the xfs_buf_read_uncached() helper.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |   20 +++------------
>  fs/xfs/linux-2.6/xfs_buf.h |    4 ---
>  fs/xfs/xfs_mount.c         |   56 ++++++++++++-------------------------------
>  3 files changed, 20 insertions(+), 60 deletions(-)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
