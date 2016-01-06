Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 47BC87F3F
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 16:10:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0094AC001
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 14:10:09 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xTgtMVdcmQBqFFOT for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 14:10:06 -0800 (PST)
Date: Thu, 7 Jan 2016 09:10:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and swift
Message-ID: <20160106221004.GJ21461@dastard>
References: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
	<20160106220454.GI21461@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160106220454.GI21461@dastard>
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
To: Mark Seger <mjseger@gmail.com>
Cc: Laurence Oberman <loberman@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

On Thu, Jan 07, 2016 at 09:04:54AM +1100, Dave Chinner wrote:
> On Wed, Jan 06, 2016 at 10:15:25AM -0500, Mark Seger wrote:
> > I've recently found the performance our development swift system is
> > degrading over time as the number of objects/files increases.  This is a
> > relatively small system, each server has 3 400GB disks.  The system I'm
> > currently looking at has about 70GB tied up in slabs alone, close to 55GB
> > in xfs inodes and ili, and about 2GB free.  The kernel
> > is 3.14.57-1-amd64-hlinux.
> 
> So you go 50M cached inodes in memory, and a relatively old kernel.
> 
> > Here's the way the filesystems are mounted:
> > 
> > /dev/sdb1 on /srv/node/disk0 type xfs
> > (rw,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=8,logbsize=256k,sunit=512,swidth=1536,noquota)
> > 
> > I can do about 2000 1K file creates/sec when running 2 minute PUT tests at
> > 100 threads.  If I repeat that tests for multiple hours, I see the number
> > of IOPS steadily decreasing to about 770 and the very next run it drops to
> > 260 and continues to fall from there.  This happens at about 12M files.
> 
> According to the numbers you've provided:
> 
> 	lookups		creates		removes
> Fast:	1550		1350		300
> Slow:	1000		 900		250
> 
> This is pretty much what I'd expect on the XFS level when going from
> a small empty filesystem to one containing 12M 1k files.
> 
> That does not correlate to your numbers above, so it's not at all
> clear that there is realy a problem here at the XFS level.
> 
> > The directory structure is 2 tiered, with 1000 directories per tier so we
> > can have about 1M of them, though they don't currently all exist.
> 
> That's insane.
> 
> The xfs directory structure is much, much more space, time, IO and
> memory efficient that a directory hierachy like this. The only thing
> you need a directory hash hierarchy for is to provide sufficient
> concurrency for your operations, which you would probably get with a
> single level with one or two subdirs per filesystem AG.

BTW, you might want to read the section on directory block size for
a quick introduction to XFS directory design and scalability:

https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
