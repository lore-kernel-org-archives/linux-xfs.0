Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1KLQx9I105582 for <xfs@oss.sgi.com>; Sun, 20 Feb 2011 15:26:59 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8F882EC263
	for <xfs@oss.sgi.com>; Sun, 20 Feb 2011 13:29:40 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UTwP253FGYn6xMxx for <xfs@oss.sgi.com>;
	Sun, 20 Feb 2011 13:29:40 -0800 (PST)
Date: Mon, 21 Feb 2011 08:29:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests 071 trips an ASSERT due to commit
	055388a3188f56676c21e92962fc366ac8b5cb72
Message-ID: <20110220212937.GC3166@dastard>
References: <1298078693.32230.398.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298078693.32230.398.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 18, 2011 at 05:24:53PM -0800, Chandra Seetharaman wrote:
> Hello,
> 
> In My POWER system, I saw 2 new ASSERTs when I ran the xfstests (071 and
> 087) on 2.6.38-rc4 that I did not see in 2.6.37.
> 
> I did a git bisect and the following commit is the one causes the ASSERT
> when 071 was run (still working on git-bisect of 087).
> 
> Note that the 512 byte sectors warning is printed when the pagesize is
> 64K. That message is not printed when I change the pagesize to 4K, but
> the ASSERT still trips.
> 
> -----------------------------------------
> commit 055388a3188f56676c21e92962fc366ac8b5cb72
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Tue Jan 4 11:35:03 2011 +1100
> 
>     xfs: dynamic speculative EOF preallocation
>     
>     Currently the size of the speculative preallocation during delayed
>     allocation is fixed by either the allocsize mount option of a
>     default size. We are seeing a lot of cases where we need to
>     recommend using the allocsize mount option to prevent fragmentation
>     when buffered writes land in the same AG.
> ------------------------------------------
> 
> and here is the log
> -------------------------------------------
> 
> Feb 18 16:25:40 test135 root: ======== starting XFS test 071 2.6.37-bad+ ========
> Feb 18 16:25:41 test135 kernel: SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
> Feb 18 16:25:41 test135 kernel: SGI XFS Quota Management subsystem
> Feb 18 16:25:41 test135 kernel: XFS: 512 byte sectors in use on device sda6.  This is suboptimal; 1024 or greater is ideal.
> Feb 18 16:25:41 test135 kernel: XFS mounting filesystem sda6
> Feb 18 16:25:42 test135 kernel: XFS: 512 byte sectors in use on device sda5.  This is suboptimal; 1024 or greater is ideal.
> Feb 18 16:25:42 test135 kernel: XFS mounting filesystem sda5
> Feb 18 16:25:42 test135 kernel: XFS: 512 byte sectors in use on device sda6.  This is suboptimal; 1024 or greater is ideal.
> Feb 18 16:25:42 test135 kernel: XFS mounting filesystem sda6
> Feb 18 16:25:43 test135 kernel: XFS: 512 byte sectors in use on device sda5.  This is suboptimal; 1024 or greater is ideal.
> Feb 18 16:25:43 test135 kernel: XFS mounting filesystem sda5
> Feb 18 16:25:44 test135 kernel: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/linux-2.6/xfs_super.c, line: 915

Yes, that is the assert failure I've spent the best part of the last
two weeks trying to track down. I'm getting test 083 and 104 hitting
this every so often (1 in 5 test runs). I think this is an existing
problem and the above commit has simply made them easier to hit, as
I've had these tests fail occasionallywith this assert prior to that
commit existing....

There seems to be a couple of different symptoms - the first appears
to be triggered by EOF zeroing and a sub-page block adjacent to the
EOF zeroing remaining in delalloc state after writeback. I haven't
been able to narrow this down further yet. The other case which I
haven't yet got any real idea on the cause is leaving large regions
of sequential blocks (I've seen up to ~150 blocks) in the delalloc
state.

In both cases, punching the delalloc blocks out just before the
assert makes the assert go away - I did this to walk all the
delalloc blocks remaining and print them out. Combining this with
the event tracing and a bunch of printk has got me the above
information, but I'm stil haven't isolated the code that exposes the
problem.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
