Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G9MGCU081688 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 04:22:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4A4819C197
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:21:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ALVggIs20PGnktVh for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:21:55 -0700 (PDT)
Date: Mon, 16 Mar 2009 05:21:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] XFS: Prevent unwritten extent conversion from
	blocking I/O completion
Message-ID: <20090316092124.GA21496@infradead.org>
References: <1237117243-25940-1-git-send-email-david@fromorbit.com>
	<1237117243-25940-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237117243-25940-2-git-send-email-david@fromorbit.com>
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

On Sun, Mar 15, 2009 at 10:40:42PM +1100, Dave Chinner wrote:
> Unwritten extent conversion can recurse back into the filesystem due
> to memory allocation. Memory reclaim requires I/O completions to be
> processed to allow the callers to make progress. If the I/O
> completion workqueue thread is doing the recursion, then we have a
> deadlock situation.
> 
> Move unwritten extent completion into it's own workqueue so it
> doesn't block I/O completions for normal delayed allocation or
> overwrite data.

Hmm.   That was the original reason behind splitting the data from
xfsbufd queue.  So maybe the split should be just unwritten vs the
rest and three queues?

Btw, do you have a testcase that can reproduce this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
