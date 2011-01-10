Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AJGajN032860 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 13:16:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06C9D24C93E
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:18:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GDftRxKlnhyvat9V for
	<xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:18:48 -0800 (PST)
Date: Mon, 10 Jan 2011 14:18:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfs: ensure sync write errors are returned
Message-ID: <20110110191848.GC25029@infradead.org>
References: <1294399825-1157-1-git-send-email-david@fromorbit.com>
	<1294399825-1157-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294399825-1157-2-git-send-email-david@fromorbit.com>
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

On Fri, Jan 07, 2011 at 10:30:18PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_file_aio_write() only returns the error from synchronous
> flushing of the data and inode if error == 0. At the point where
> error is being checked, it is guaranteed to be > 0. Therefore any
> errors returned by the data or fsync flush will never be returned.
> Fix the checks so we overwrite the current error once and only if an
> error really occurred.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
