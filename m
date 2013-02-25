Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D7987F72
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 16:16:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F283AC007
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:16:42 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EOGa9P28DKvaeLzx for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 14:16:40 -0800 (PST)
Date: Tue, 26 Feb 2013 09:16:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Consistent throughput challenge -- fragmentation?
Message-ID: <20130225221639.GJ5551@dastard>
References: <CAEWpfG_DKJt1MmWS1tARH4OmYwpSt=A-DzwKkGcD67LuR6k=Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEWpfG_DKJt1MmWS1tARH4OmYwpSt=A-DzwKkGcD67LuR6k=Bg@mail.gmail.com>
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
To: Brian Cain <brian.cain@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 25, 2013 at 10:01:53AM -0600, Brian Cain wrote:
> All,
> 
> I have been observing some odd behavior regarding write throughput to an
> XFS partition (the baseline kernel version is 2.6.32.27).  I see
> consistently high write throughput (close to the performance of the raw
> block device) to the filesystem immediately after a mkfs, but after a few
> test cycles, there is sporadic poor performance.
> 
> The test mechanism is like so:
> 
> [mkfs.xfs <blockdev>] (no flags/options, xfsprogs ver 3.1.1-0.1.36)
> ...
> 1. remove a previous test cycle's directory
> 2. create a new directory
> 3. open/write/close a small file (4kb) in this directory
> 4. open/read/close this same small file (by the local NFS server)
> 5. open[O_DIRECT]/write/write/write/.../close a large file (anywhere from
> ~100MB to 200GB)
> 
> Step #5 contains the high-throughput metrics which becomes an order of
> magnitude worse several test cycles after a mkfs.  Omitting steps 1-3 does
> not show the poor performance behavior.
> 
> Can anyone provide any suggestions as to an explanation for the behavior or
> a way to mitigate it?  Running xfs_fsr didn't seem to improve the results.
> 
> I'm happy to share benchmarks, specific results data, or describe the
> hardware being used for the measurements if it's helpful.

Post your benchmark script, along with the results you see, and all
the other information listed here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
