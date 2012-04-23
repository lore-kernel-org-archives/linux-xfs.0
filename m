Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NFdp03207295 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 10:39:51 -0500
Message-ID: <4F9577C4.90903@sgi.com>
Date: Mon, 23 Apr 2012 10:39:48 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/37] xfs: remove log item from AIL in xfs_iflush after
	a shutdown
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/23/12 00:58, Dave Chinner wrote:
> From: Christoph Hellwig<hch@infradead.org>
>
> If a filesystem has been forced shutdown we are never going to write inodes
> to disk, which means the inode items will stay in the AIL until we free
> the inode. Currently that is not a problem, but a pending change requires us
> to empty the AIL before shutting down the filesystem. In that case leaving
> the inode in the AIL is lethal. Make sure to remove the log item from the AIL
> to allow emptying the AIL on shutdown filesystems.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
