Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14G9fIf073359 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 10:09:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91F85137AB36
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 08:10:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id azdAHOhWzQHyNbWh for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 08:10:51 -0800 (PST)
Date: Thu, 4 Feb 2010 11:10:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-2.6.33] xfs: flush all log buffers in xlog_dealloc_log
Message-ID: <20100204161050.GB11206@infradead.org>
References: <20100201220813.GA3519@infradead.org>
	<20100203105545.GA1047@infradead.org>
	<20100204081422.GF5332@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100204081422.GF5332@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Feb 04, 2010 at 07:14:22PM +1100, Dave Chinner wrote:
> On Wed, Feb 03, 2010 at 05:55:45AM -0500, Christoph Hellwig wrote:
> > Actually I'll take this one back - the log buffers aren't delwri
> > so xfs_flush_buftarg probably only helped by timing or the
> > xfs_buf_runall_queues on xfslogd_workqueue.  Need to think about
> > this a bit more.
> 
> Can you point me at the bug report? IIRC I've seen this in the
> past where we freed the log before we've done all the correct
> shutdown processing and they got fixed by correcting the
> order of shutdown to ensure the log is idle before freeing
> it...

Yes, that I was going to look into next.  The recent report
is http://bugzilla.kernel.org/show_bug.cgi?id=15150 and there's
also a very similar one from Ed Cashin <ecashin@coraid.com> in
mail archives from November.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
