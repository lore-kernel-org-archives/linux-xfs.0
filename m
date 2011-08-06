Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p76EKA8p168370 for <xfs@oss.sgi.com>; Sat, 6 Aug 2011 09:20:10 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A661151CCE1
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2011 07:21:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	3dc5DRjnK0b8Kv5v for <xfs@oss.sgi.com>;
	Sat, 06 Aug 2011 07:21:14 -0700 (PDT)
Date: Sun, 7 Aug 2011 00:20:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110806142005.GG3162@dastard>
References: <20110806122556.GB20341@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110806122556.GB20341@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Sat, Aug 06, 2011 at 02:25:56PM +0200, Marc Lehmann wrote:
> I get frequent (for servers) lockups and crashes when using 2.6.39. I saw the
> same problems using 3.0.0rc5, 5 and 6, and I think also 2.6.38. I don't see
> this lockups on 2.6.30 or 2.6.26 (all the respetcive latest debian kernels).
> 
> The symtpom slightly differs - sometimes I get thousands of backtraces
> before the machine locks up, usually I get only one, and either the
> machine locks up completely, or only the processes using the filesystem in
> question (presumably) lock - all unkillable.
> 
> The backtraces look all very similar:
> 
>    http://ue.tst.eu/85b9c9f66e36dda81be46892661c5bd0.txt

Tainted kernel. Please reproduce without the NVidia binary drivers.

> this is from a desktop system - it tends to be harder to get these from
> servers.
> 
> all the backtraces crash with a null pointer dereference in xfs_iget, or
> in xfs_trans_log_inode, and always for process xfs_fsr.

and when you do, please record an event trace of the
xfs_swap_extent* trace points while xfs_fsr is running and triggers
a crash. That will tell me if xfs_fsr is corrupting inodes,

> I haven't seen a crash without xfs_fsr.

Then don't use xfs_fsr until we know if it is the cause of the
problem (except to reproduce the problem).

And as I always ask - why do you need to run xfs_fsr so often?  Do
you really have filesystems that get quickly fragmented (or are you
just running it from a cron-job because having on-line
defragmentation is what all the cool kids do ;)? If you are getting
fragmentation, what is the workload that is causing it?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
