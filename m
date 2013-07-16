Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F3DD7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 19:27:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3087530404E
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 17:27:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bvE0iOSax7h3B5C9 for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 17:27:26 -0700 (PDT)
Date: Tue, 16 Jul 2013 10:27:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file:
	fs/xfs/xfs_dir2_sf.c, line: 358
Message-ID: <20130716002703.GB3920@dastard>
References: <20130712023930.GA6473@redhat.com> <20130713020030.GG3438@dastard>
	<20130715195800.GD1706@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130715195800.GD1706@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jul 15, 2013 at 03:58:00PM -0400, Dave Jones wrote:
> On Sat, Jul 13, 2013 at 12:00:30PM +1000, Dave Chinner wrote:
>  
>  > > [   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
>  > ....
>  > 
>  > So, it's not clear what has caused this yet. Is it reproducable?
> 
> Just hit it again on the same machine.
> 
>  > would be good to get a trace of lookup vs addname events from XFS,
>  > too (i.e. all the xfs_dir* and xfs_da* events) so we can see if the
>  > correct lookups were done prior to the failing addname operation...
>  
> <- xfs tracing noob. Got a recipe I can cut-n-paste ?
> Or a patch if that's necessary..

Just use your usual method of pulling tracepoints out of the kernel,
be it with perf or (my preferred method) trace-cmd:

# trace-cmd record -e xfs_dir\* -e xfs_da\* <command that dies>
....
# trace-cmd report > trace.report.out

The trace.report.out file is what I'd like to see. The report file
could be large, so compressing it might be an idea...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
