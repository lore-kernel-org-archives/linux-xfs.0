Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O3sand177194 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 21:54:37 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fC7HpqPjfYM5niNy for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 19:54:34 -0800 (PST)
Date: Tue, 24 Jan 2012 14:54:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: concurrent direct IO write in xfs
Message-ID: <20120124035431.GD6922@dastard>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<20120123051155.GI15102@dastard>
	<CAFLer82QxfgXEx7ofzOHOK2YKiA+ab+_Aizd10SWHvnC-mVUHg@mail.gmail.com>
	<CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
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
To: Zheng Da <zhengda1936@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 03:51:43PM -0500, Zheng Da wrote:
> Hello
> 
> On Mon, Jan 23, 2012 at 2:34 PM, Zheng Da <zhengda1936@gmail.com> wrote:
> >
> > > I build XFS on the top of ramdisk. So yes, there is a lot of small
> >> > concurrent writes in a second.
> >> > I create a file of 4GB in XFS (the ramdisk has 5GB of space). My test
> >> > program overwrites 4G of data to the file and each time writes a page of
> >> > data randomly to the file. It's always overwriting, and no appending.
> >> The
> >> > offset of each write is always aligned to the page size. There is no
> >> > overlapping between writes.
> >>
> >> Why are you using XFS for this? tmpfs was designed to do this sort
> >> of stuff as efficiently as possible....
> >>
> > OK, I can try that.
> >
> tmpfs doesn't support direct IO.

it doesn't need to. The ramdisk is copying data into it's own
private page cache and you are using direct Io to avoid the system
page cache (i.e. a double copy). tmpfs just uses the system page
cache, so tehre's only one copy and it has a much shorter and less
complex IO path than XFS.....

> >> > So the test case is pretty simple and I think it's easy to reproduce it.
> >> > It'll be great if you can try the test case.
> >>
> >> Can you post your test code so I know what I test is exactly what
> >> you are running?
> >>
> > I can do that. My test code gets very complicated now. I need to simplify
> > it.
> >
> Here is the code. It's still a bit long. I hope it's OK.
> You can run the code like "rand-read file option=direct pages=1048576
> threads=8 access=write/read".

With 262144 pages on a 2Gb ramdisk, the results I get on 3.2.0 are

Threads		Read	Write
    1		0.92s	1.49s
    2		0.51s	1.20s
    4		0.31s	1.34s
    8		0.22s	1.59s
   16		0.23s	2.24s

the contention is on the ip->i_ilock, and the newsize update is one
of the offenders It probably needs this change to
xfs_aio_write_newsize_update():

-        if (new_size == ip->i_new_size) {
+        if (new_size && new_size == ip->i_new_size) {

to avoid the lock being taken here.

But all that newsize crap is gone in the current git Linus tree,
so how much would that gains us:

Threads		Read	Write
    1		0.88s	0.85s
    2		0.54s	1.20s
    4		0.31s	1.23s
    8		0.27s	1.40s
   16		0.25s	2.36s

Pretty much nothing. IOWs, it's just like I suspected - you are
doing so many write IOs that you are serialising on the extent
lookup and write checks which use exclusive locking..

Given that it is 2 lock traversals per write IO, we're limiting at
about 4-500,000 exclusive lock grabs per second and decreasing as
contention goes up.

For reads, we are doing 2 shared (nested) lookups per read IO, we
appear to be limiting at around 2,000,000 shared lock grabs per
second. Ahmdals law is kicking in here, but it means if we could
make the writes to use a shared lock, it would at least scale like
the reads for this "no metadata modification except for mtime"
overwrite case.

I don't think that the generic write checks absolutely need
exclusive locking - we probably could get away with a shared lock
and only fall back to exclusive when we need to do EOF zeroing.
Similarly, for the block mapping code if we don't need to do
allocation, a shared lock is all we need. So maybe in that case for
direct IO when create == 1, we can do a read lookup first and only
grab the lock exclusively if that falls in a hole and requires
allocation.....

Let me think about it for a bit....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
