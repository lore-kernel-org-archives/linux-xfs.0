Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LCI5il070883 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 06:18:07 -0600
Date: Thu, 21 Jan 2010 07:19:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Obsolete config in kernel build system (XFS_TRACE)
Message-ID: <20100121121904.GA1082@infradead.org>
References: <20100120125249.GC3580@faui49.informatik.uni-erlangen.de>
	<20100120224626.GP14035@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100120224626.GP14035@discord.disaster>
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
Cc: Reinhard.Tartler@informatik.uni-erlangen.de, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, xfs-masters@oss.sgi.com, Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

On Thu, Jan 21, 2010 at 09:46:26AM +1100, Dave Chinner wrote:
> Christoph's conversion to use the kernel trace infrastructure is
> a work in progress. It's no small task - he's converted around 220
> trace points points so far.
> 
> However, the btree tracing code has not been converted yet. IIRC
> this is because the kernel trace code didn't have the required
> infrastructure at the time of initial conversion. Hence the old code
> has not yet been completely removed because the conversion is not
> yet complete.  It will go away when the conversion is completed.

The btree ones are rather difficult because it will require attaching
difference events to a single tracepoint and filter on which one
we want, so it may take a bit of time.

The existing xfs_btree_trace.c won't be much use for that and if we
really need it we can look at it in git history.

Christoph, can you send a properly signed off patch to kill
xfs_btree_trace.c and and the #ifdef XFS_BTREE_TRACE code in
xfs_btree_trace.h?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
