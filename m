Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1147CoQ186936 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 22:07:12 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WL1uzpCpsRc7l4Ie for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 20:07:10 -0800 (PST)
Date: Wed, 1 Feb 2012 15:07:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: several 274 fixups
Message-ID: <20120201040707.GT9090@dastard>
References: <4F271967.10308@sandeen.net> <20120131224152.GP9090@dastard>
	<4F28A32C.9030706@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F28A32C.9030706@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: WuBo <wu.bo@cn.fujitsu.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jan 31, 2012 at 08:27:56PM -0600, Eric Sandeen wrote:
> On 1/31/12 4:41 PM, Dave Chinner wrote:
> > On Mon, Jan 30, 2012 at 04:27:51PM -0600, Eric Sandeen wrote:
> >> -dd if=/dev/zero of=tmp1 bs=1M >/dev/null 2>&1
> >> -dd if=/dev/zero of=tmp2 bs=4K >/dev/null 2>&1
> >> +# Fill the rest of the fs completely
> >> +dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=1M >>$seq.full 2>&1
> >> +dd if=/dev/zero of=$SCRATCH_MNT/tmp2 bs=4K >>$seq.full 2>&1
> >>  sync
> >> +# Last effort, use O_SYNC
> >> +dd if=/dev/zero of=$SCRATCH_MNT/tmp3 bs=4K oflag=sync >>$seq.full 2>&1
> >> +# Save space usage info
> >> +echo "Post-fill space:" >> $seq.full
> >> +df $SCRATCH_MNT >>$seq.full 2>&1
> >>  
> >> -dd if=/dev/zero of=test seek=1 bs=4K count=2 conv=notrunc >/dev/null 2>&1
> >> +# Now attempt a write into all of the preallocated space 
> >> +dd if=/dev/zero of=$SCRATCH_MNT/test seek=1 bs=4K count=1024 conv=notrunc >>$seq.full 2>&1
> >>  if [ $? -ne 0 ]
> >>  then
> >> -	echo "fill prealloc range err"
> >> +	echo "fill prealloc range error"
> >>  	status=1
> >>  	exit
> >>  fi
> > 
> > I'd still like to see this write attempt to trigger nasty behaviours
> > like needing to allocate a metadata block for the extent list. I
> > suggested randholes, but perhaps this would be easier:
> > 
> > for i in `seq 1 2 1023`; do
> > 	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
> > 		>>$seq.full 2>&1 || _fail "failed to write test file"
> > done
> > 
> > which will write every second block and so only convert every second
> > block from unwritten to written and hence blow out the size of the
> > extent list and require extent map block allocation and potentially
> > trigger ENOSPC that way....
> 
> but will also only write half the actual preallocated space.  I guess it
> depends on what we are trying to test - reservations for metadata or proper
> accounting of prealloc'd space itself...?

So then go back and fill in the unwritten blocks. i.e:

for i in `seq 1 2 1023`; do
	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
		>>$seq.full 2>&1 || _fail "failed to write test file"
done
sync
for i in `seq 2 2 1023`; do
	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
		>>$seq.full 2>&1 || _fail "failed to fill test file"
done
sync

> (and really, what is the proper amount of preallocated metadata space; if
> I subbed 2G for 4M, would anything survive the test above?)

Given that the test is only using a 1GB filesystem.... ;)

But even if it was 2GB, then I'm pretty sure that XFS would handle
it fine. Take a long to run, though, with all those individual 4k
IOs. My point was simply to determine if the filesystem will be able
to hold up the guarantees posix_fallocate() tries to give
applications, and so enough extents simple to force a single
metadata block allocation is all that is required. Having a 1000
extent state changes shoul dbe sufficient to cause that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
