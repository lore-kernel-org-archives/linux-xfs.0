Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92MEVIF094944 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 17:14:31 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	olqH946jKUqF45Fy for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 15:15:54 -0700 (PDT)
Date: Wed, 3 Oct 2012 08:15:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: OOM on quotacheck (again?)
Message-ID: <20121002221525.GU23520@dastard>
References: <5059D2B4.8010300@blafoo.org> <20120919205924.GC31501@dastard>
	<505AE2A1.5060703@blafoo.org> <20120924132113.GL20960@dastard>
	<5060727D.4000009@blafoo.org> <506B1667.4010203@blafoo.org>
	<20121002200946.GP23520@dastard> <506B5357.6060609@blafoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506B5357.6060609@blafoo.org>
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
To: Volker <mail@blafoo.org>
Cc: xfs@oss.sgi.com

On Tue, Oct 02, 2012 at 10:49:27PM +0200, Volker wrote:
> Hi,
> 
> >> If its of any interest, i can supply the stack-traces.
> > 
> > Yes, it is of interest, can you post everything you found out about
> > the problem? (dmesg, stack traces, repair output, etc).
> 
> Everything posted here is from a single server and its chronologically
> top to bottom. Without having checked each and every stacktrace, it
> looked quite similar on the other servers.
> 
> http://pastebin.com/PXquE4sM

So you had a hang on 2.6.37 to do with dquot reclaim, you rebooted
the server into what I think is a 3.6 kernel.

Log recovery failed with "bad clientid 0x0", so no superblock
problem. It does tend to indicate that 2.6.37 wrote bad data to the
log, though. If you reboot into 2.6.37, does log recovery run
successfully? i.e. does the failure only occur on 2.6.37 -> 3.6
with a dirty log?

You then ran xfs_repair -P -L, which threw lots of metadata
away and moved lots of stuff to lost+found.

You them mounted the filesystem on the same kernel (has
xfs_trans_read_buf_map() in the trace, hence the 3.6 version), and
it appears to be hung waiting for IO to complete on a dquot buffer.
That tends to indicate that maybe there's a problem with IO
completion somewhere below the XFS layer.

And if there's a problem below XFS w.r.t. IO compeltion, that also
makes me wonder if the log recovery problem isn't also caused by
something below XFS...

What mount options are you using on the 2.6.37 kernel?

> Sidenote:
> The xfs_repair would not finish without supplying -P, otherwise the
> repair hang in phase 6 (might be related to this bug:
> http://oss.sgi.com/archives/xfs-masters/2011-01/msg00009.html)

If you are upgrading your kernel, you should also upgrade your
xfsprogs installation as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
