Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA89N9gZ091088 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 03:23:10 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E33971399054
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 01:24:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dClDXROI56yE3uYN for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 01:24:36 -0800 (PST)
Date: Mon, 8 Nov 2010 04:24:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/16] xfs: move delayed write buffer trace
Message-ID: <20101108092436.GC2806@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-3-git-send-email-david@fromorbit.com>
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

On Mon, Nov 08, 2010 at 07:55:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The delayed write buffer split trace currently issues a trace for
> every buffer it scans. These buffers are not necessarily queued for
> delayed write. Indeed, when buffers are pinned, there can be
> thousands of traces of buffers that aren't actually queued for
> delayed write and the ones that are are lost in the noise. Move the
> trace point to record only buffers that are split out for IO to be
> issued on.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
