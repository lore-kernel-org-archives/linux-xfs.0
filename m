Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATD6Xsr163820 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 07:06:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC1E91AFC9E
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 05:08:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hJGnF6xJs6GU3eVh for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 05:08:15 -0800 (PST)
Date: Mon, 29 Nov 2010 08:08:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: connect up buffer reclaim priority hooks
Message-ID: <20101129130815.GB22293@infradead.org>
References: <1290992339-20849-1-git-send-email-david@fromorbit.com>
	<1290992339-20849-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290992339-20849-4-git-send-email-david@fromorbit.com>
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

On Mon, Nov 29, 2010 at 11:58:59AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the buffer reclaim infrastructure can handle different reclaim
> priorities for different types of buffers, reconnect the hooks in the
> XFS code that has been sitting dormant since it was ported to Linux. This
> should finally give use reclaim prioritisation that is on a par with the
> functionality that Irix provided XFS 15 years ago.

I think we really should call the buffer type macro fragments, but that
can be left for another patch.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
