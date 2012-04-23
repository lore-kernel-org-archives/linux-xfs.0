Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NFeXRc207391 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 10:40:33 -0500
Message-ID: <4F9577F1.6080603@sgi.com>
Date: Mon, 23 Apr 2012 10:40:33 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/37] xfs: implement freezing by emptying the AIL
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-5-git-send-email-david@fromorbit.com>
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
> Now that we write back all metadata either synchronously or through
> the AIL we can simply implement metadata freezing in terms of
> emptying the AIL.
>
> The implementation for this is fairly simply and straight-forward:
> A new routine is added that asks the xfsaild to push the AIL to the
> end and waits for it to complete and send a wakeup. The routine will
> then loop if the AIL is not actually empty, and continue to do so
> until the AIL is compeltely empty.
>
> We keep an inode reclaim pass in the freeze process to avoid having
> memory pressure have to reclaim inodes that require dirtying the
> filesystem to be reclaimed after the freeze has completed. This
> means we can also treat unmount in the exact same way as freeze.
>
> As an upside we can now remove the radix tree based inode writeback
> and xfs_unmountfs_writesb.
>
> [ Dave Chinner:
> 	- Cleaned up commit message.
> 	- Added inode reclaim passes back into freeze.
> 	- Cleaned up wakeup mechanism to avoid the use of a new
> 	  sleep counter variable. ]
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
