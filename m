Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3BIUq7m105774 for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 13:30:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 548E53C3DB5
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 11:34:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ViKHpVhXZGAkBplc for
	<xfs@oss.sgi.com>; Mon, 11 Apr 2011 11:34:12 -0700 (PDT)
Date: Mon, 11 Apr 2011 14:34:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] bdi: mark the bdi flusher busy when being forked
Message-ID: <20110411183412.GC32346@infradead.org>
References: <1302157196-1988-1-git-send-email-david@fromorbit.com>
	<1302157196-1988-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302157196-1988-2-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Apr 07, 2011 at 04:19:55PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Recetn attempts to use writeback_inode_sb_nr_if_idle() in XFs from
> memory reclaim context have caused deadlocks because memory reclaim
> call be called from a failed allocation during forking a flusher
> thread. The shrinker then attempts to trigger writeback and the bdi
> is considered idle because writeback is not in progress yet and then
> deadlocks because bdi_queue_work() blocks waiting for the
> BDI_Pending bit to clear which will never happen because it needs
> the fork to complete.
> 
> To avoid this deadlock, consider writeback to be in progress if the
> flusher thread is being created. This prevents reclaim from blocking
> waiting for it be forked and hence avoids the deadlock.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
