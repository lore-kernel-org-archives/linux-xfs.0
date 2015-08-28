Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFAC07F37
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 17:05:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF5FB8F8049
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 15:05:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Oe4lEBUeEwGdW8DJ for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2015 15:05:26 -0700 (PDT)
Date: Sat, 29 Aug 2015 08:04:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: timestamp updates cause excessive fdatasync log
	traffic
Message-ID: <20150828220454.GC26895@dastard>
References: <1440724990-25073-1-git-send-email-david@fromorbit.com>
	<20150828043253.GB26895@dastard>
	<alpine.DEB.2.00.1508280804040.13116@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1508280804040.13116@cobra.newdream.net>
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
To: Sage Weil <sage@newdream.net>
Cc: xfs@oss.sgi.com

On Fri, Aug 28, 2015 at 08:11:20AM -0700, Sage Weil wrote:
> Hi Dave,
> 
> On Fri, 28 Aug 2015, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Sage Weil reported that a ceph test workload was writing to the
> > log on every fdatasync during an overwrite workload. Event tracing
> > showed that the only metadata modification being made was the
> > timestamp updates during the write(2) syscall, but fdatasync(2)
> > is supposed to ignore them. The key observation was that the
> > transactions in the log all looked like this:
[....]

> > ---
> > Version 2:
> > - include the hunk from fs/xfs/xfs_trans_inode.c that I missed
> >   when committing the patch locally the first time.
> 
> I gave this a go on my machine but I'm still seeing the same symptom.  

OK, that implies the inode buffer has not been submitted for IO and
so the inode is being held in "flushing" state for an extended
period of time.

> I've gathered the trace, strace, and other useful bits at
> 
>    http://newdream.net/~sage/drop/rocksdb.2/
> 
> This is pretty easy to reproduce with the ceph_test_keyvaluedb binary 
> (built on fedora 22), also in that dir:
> 
>    rm -rf kv_test_temp_dir/
>    ./ceph_test_keyvaluedb --gtest_filter=KeyValueDB/KVTest.BenchCommit/1

I'll have a deeper look.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
