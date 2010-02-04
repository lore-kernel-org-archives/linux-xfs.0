Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o148DH75021666 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 02:13:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 070841ABBD5
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 00:14:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	ShmQjAKduy193ocu for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2010 00:14:25 -0800 (PST)
Date: Thu, 4 Feb 2010 19:14:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH for-2.6.33] xfs: flush all log buffers in xlog_dealloc_log
Message-ID: <20100204081422.GF5332@discord.disaster>
References: <20100201220813.GA3519@infradead.org>
	<20100203105545.GA1047@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100203105545.GA1047@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Feb 03, 2010 at 05:55:45AM -0500, Christoph Hellwig wrote:
> Actually I'll take this one back - the log buffers aren't delwri
> so xfs_flush_buftarg probably only helped by timing or the
> xfs_buf_runall_queues on xfslogd_workqueue.  Need to think about
> this a bit more.

Can you point me at the bug report? IIRC I've seen this in the
past where we freed the log before we've done all the correct
shutdown processing and they got fixed by correcting the
order of shutdown to ensure the log is idle before freeing
it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
