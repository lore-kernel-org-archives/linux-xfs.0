Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q05NsDeF227710 for <xfs@oss.sgi.com>; Thu, 5 Jan 2012 17:54:13 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	crJdoIk1rbu6c93V for <xfs@oss.sgi.com>;
	Thu, 05 Jan 2012 15:54:09 -0800 (PST)
Date: Fri, 6 Jan 2012 10:54:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs-trace-ilock-more
Message-ID: <20120105235406.GH24466@dastard>
References: <20111214024040.GA17780@infradead.org>
	<20111214182750.GH11114@wotan.suse.de>
	<20111218202734.GB20799@infradead.org>
	<20120105223859.GJ11114@wotan.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120105223859.GJ11114@wotan.suse.de>
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
To: Mark Fasheh <mfasheh@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Mahoney <jeffm@suse.com>, xfs@oss.sgi.com

On Thu, Jan 05, 2012 at 02:38:59PM -0800, Mark Fasheh wrote:
> On Sun, Dec 18, 2011 at 03:27:34PM -0500, Christoph Hellwig wrote:
> > Given that the patch is fairly clean can you send it to us for
> > inclusion?
> 
> Here goes. I updated the patch for 3.2 and of course gave it a quick test.
> 	--Mark
> 
> --
> Mark Fasheh
> 
> From: Mark Fasheh <mfasheh@suse.com>
> 
> [PATCH] xfs: add more ilock tracing
> 
> Let's get a trace of the amount of time spent in xfs_ilock(). This has
> helped us (SUSE) in investigating read/write performance issues in the past
> when ilock() contention has come up as a possibile issue.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

....

> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -507,32 +507,35 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
>  
>  DECLARE_EVENT_CLASS(xfs_lock_class,
>  	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags,
> -		 unsigned long caller_ip),
> -	TP_ARGS(ip,  lock_flags, caller_ip),
> +		 unsigned long start, unsigned long caller_ip),
> +	TP_ARGS(ip,lock_flags, start, caller_ip),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
>  		__field(int, lock_flags)
> +		__field(unsigned long, start)
>  		__field(unsigned long, caller_ip)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
>  		__entry->lock_flags = lock_flags;
> +		__entry->start = start;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pf",
> +	TP_printk("dev %d:%d ino 0x%llx flags %s wait %lu caller %pf",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS),
> +		  (jiffies - __entry->start),

I'm not sure this is valid - the printk format can be used by tools
outside the kernel at a later time (e.g. they read from the kernel
in binary format). If you want this to be done, the it needs to be
calculated in the TP_fast_assign() macro.

Indeed, you are printing is the time delta between the start of
the operation and the completion. in that case, the delta should be
what is recorded in the trace point, not calculated implicitly
inside the format string of the trace point. i.e callers do:

	trace_xfs_iunlock(ip, lock_flags, jiffies - start, _RET_IP_);

to pass an explicit delta value to the trace point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
