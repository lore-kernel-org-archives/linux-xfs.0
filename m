Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8N8q5e123286 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 17:08:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E217139C783
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 15:10:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id f67Me7BeavDJLCcw for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 15:10:20 -0800 (PST)
Date: Mon, 8 Nov 2010 18:10:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/16] xfs: convert pag_ici_lock to a spin lock
Message-ID: <20101108231019.GB13299@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-9-git-send-email-david@fromorbit.com>
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

On Mon, Nov 08, 2010 at 07:55:11PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> now that we are using RCU protection for the inode cache lookups,
> the lock is only needed on the modification side. Hence it is not
> necessary for the lock to be a rwlock as there are no read side
> holders anymore. Convert it to a spin lock to reflect it's exclusive
> nature.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Alex Elder <aelder@sgi.com>

Looks good, and this will make Thomas happy given that XFS is now
rwlock_t-free.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
