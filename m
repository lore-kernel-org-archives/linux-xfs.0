Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C9A57F53
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 11:23:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6CE0F304051
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 09:23:53 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hU7d7g6syToZ1QXS for <xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 09:23:51 -0700 (PDT)
Date: Wed, 17 Apr 2013 02:24:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
Message-ID: <20130416162417.GC13938@destitution>
References: <516C89DF.4070904@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <516C89DF.4070904@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: sandeen@sandeen.net, yongtaofu@gmail.com, xfs@oss.sgi.com

On Mon, Apr 15, 2013 at 07:14:39PM -0400, Brian Foster wrote:
> Hi,
> 
> Thanks for the data in the previous thread:
> 
> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
> 
> I'm spinning off a new thread specifically for this because the original
> thread is already too large and scattered to track. As Eric stated,
> please try to keep data contained in as few messages as possible.
> 
> The data confirms Dave's theory where we are going off the end of the
> unlinked list when attempting to remove an inode, pass in NULLAGINO to
> xfs_inotobp() and the attempted conversion to a global inode number
> leads to EINVAL. The next question here is why wasn't the inode listed
> in the probe output on the unlinked inode list?
> 
> Unfortunately we're probably going to require to start making some
> debug-level changes to the kernel to make progress on this issue. If you
> are able to recompile a kernel and/or xfs module (which you referred to
> doing in the previous thread), could you start with the patch appended
> to this message[1] and collect the xfs_iunlink and xfs_iunlink_remove
> tracepoint data the next time the problem occurs? E.g.,
> 
> 	echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_iunlink/enable
> 	echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_iunlink_remove/enable
> 	... reproduce ...
> 	cat /sys/kernel/debug/tracing/trace > trace.output

It's better to use trace-cmd for this. it will result in less
dropped events. i.e.:

	$ trace-cmd record -e xfs_iunlink\*
	... reproduce ...
	^C
	$ trace-cmd report > trace.output

> --- a/fs/xfs/linux-2.6/xfs_trace.h
> +++ b/fs/xfs/linux-2.6/xfs_trace.h
> @@ -581,6 +581,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
>  DEFINE_INODE_EVENT(xfs_destroy_inode);
>  DEFINE_INODE_EVENT(xfs_write_inode);
>  DEFINE_INODE_EVENT(xfs_clear_inode);
> +DEFINE_INODE_EVENT(xfs_iunlink);
> +DEFINE_INODE_EVENT(xfs_iunlink_remove);
> 
>  DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
>  DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 796edce..a43bec5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1670,6 +1670,8 @@ xfs_iunlink(
>  		(sizeof(xfs_agino_t) * bucket_index);
>  	xfs_trans_log_buf(tp, agibp, offset,
>  			  (offset + sizeof(xfs_agino_t) - 1));
> +
> +	trace_xfs_iunlink(ip);
>  	return 0;
>  }
> 
> @@ -1820,6 +1822,8 @@ xfs_iunlink_remove(
>  				  (offset + sizeof(xfs_agino_t) - 1));
>  		xfs_inobp_check(mp, last_ibp);
>  	}
> +
> +	trace_xfs_iunlink_remove(ip);
>  	return 0;

I would suggest that the the tracing shoul dbe at entry of the
function, otherwise we won't get a tracepoint for the operation that
triggers the shutdown. (That's the reason most tracepoints in XFS
are at function entry...)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
