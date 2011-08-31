Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VCk22e208202 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 07:46:02 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51A8F54452D
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 05:46:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xSOtFYTGOy1ioLhL for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 05:46:01 -0700 (PDT)
Date: Wed, 31 Aug 2011 22:45:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110831124558.GK32358@dastard>
References: <20110806122556.GB20341@schmorp.de> <201108091210.50204@zmi.at>
	<20110809111526.GA7631@schmorp.de> <201108100859.27576@zmi.at>
	<20110811220418.GB12808@schmorp.de>
	<20110812040530.GB26978@dastard>
	<20110826080841.GA24948@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110826080841.GA24948@schmorp.de>
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

On Fri, Aug 26, 2011 at 10:08:41AM +0200, Marc Lehmann wrote:
> On Fri, Aug 12, 2011 at 02:05:30PM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > It only does that if the pattern of writes are such that keeping the
> > preallocation around for longer periods of time will reduce
> > potential fragmentation.
> 
> That can only be false. Here is a an example that I saw *just now*:
> 
> I have a process that takes a directory with jpg files (in this case,
> all around 64kb in size) and loslessly recompresses them. This works
> by reading a file, writing it under another name (single write() call)
> and using rename to replace the original file *iff* it got smaller. The
> typical reduction is 5%. no allocsize option is used. Kernel used was
> 2.6.39.
> 
> This workload would obviously benefit most by having no preallocaiton
> anywhere, i.e. have all files tightly packed.
> 
> Here is a "du" on a big directory where this process is running, every few
> minutes:
> 
>    6439892 .
>    6439888 .
>    6620168 .
>    6633156 .
>    6697588 .
>    6729092 .
>    6755808 .
>    6852192 .
>    6816632 .
>    6250824 .
> 
> Instead of decreasing, the size increased, until just before the last
> du. Thats where I did echo 3 >drop_caches, which presumably cleared all
> those inodes that have not been used for an hour and would never have been
> used again for writing.

That's the case of the unlinked inode being reused immediately and
no having all it's state cleared correctly when recycled. That's the
problem that was diagnosed and fixed when you reported the first
problem. Can you tell me if your kernel has the bug fix or not, and
if not, does applying the fix make the problem go away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
