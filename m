Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E3F77CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 07:28:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1D58E8F8035
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 05:28:55 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JBhMWWZDCPeWZ20z for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 05:28:52 -0800 (PST)
Date: Tue, 16 Feb 2016 00:28:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] [RFC] xfs: allocate log vector buffers outside CIL
	context lock
Message-ID: <20160215132824.GH14668@dastard>
References: <1453177919-17849-1-git-send-email-david@fromorbit.com>
	<20160120015853.GU6033@dastard>
	<20160126141733.GA48264@bfoster.bfoster>
	<CADr68Wa9vG=ZOn4gbHezEyOeM+tCo69s3WVqcVXnZrn+=DdoVA@mail.gmail.com>
	<20160214001645.GF14668@dastard>
	<CADr68WZZHSEexV4aBDNhLjE1oNAHftfORCGCA-q7WH2DY8X9xg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADr68WZZHSEexV4aBDNhLjE1oNAHftfORCGCA-q7WH2DY8X9xg@mail.gmail.com>
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
To: Jens Rosenboom <j.rosenboom@x-ion.de>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Feb 15, 2016 at 12:57:51PM +0100, Jens Rosenboom wrote:
> 2016-02-14 1:16 GMT+01:00 Dave Chinner <david@fromorbit.com>:
> > On Sat, Feb 13, 2016 at 06:09:17PM +0100, Jens Rosenboom wrote:
> >> 2016-01-26 15:17 GMT+01:00 Brian Foster <bfoster@redhat.com>:
> >> > On Wed, Jan 20, 2016 at 12:58:53PM +1100, Dave Chinner wrote:
> >> We have seen this issue on our production Ceph cluster sporadically
> >> and have tried a long time to reproduce it in a lab environment.
> > ....
> >> kmem_alloc (mode:0x2408240)
> >> Feb 13 10:51:57 storage-node35 kernel: [10562.614089] XFS:
> >> ceph-osd(10078) possible memory allocation deadlock size 32856 in
> >> kmem_alloc (mode:0x2408240)
> >
> > High order allocation of 32k. That implies a buffer size of at least
> > 32k is in use. Can you tell me what the output of xfs_info <mntpt>
> > is for one of your filesystems?
> 
> $ xfs_info /tmp/cbt/mnt/osd-device-0-data/
> meta-data=/dev/sda2              isize=2048   agcount=4, agsize=97370688 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=389482752, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=65536  ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=190177, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

OK, so 64k directory block size.

> > I suspect you are using a 64k directory block size, in which case
> > I'll ask "are you storing millions of files in a single directory"?
> > If your answer is no, then "don't do that" is an appropriate
> > solution because large directory block sizes are slower than the
> > default (4k) for almost all operations until you get up into the
> > millions of files per directory range.
> 
> These options are kind of standard folklore for setting up Ceph
> clusters, I must admit that I delayed testing their performance
> implications up to now, so many knobs to turn, so little time.
> 
>   mkfs_opts: '-f -i size=2048 -n size=64k'
>   mount_opts: '-o inode64,noatime,logbsize=256k'

/me shakes his head sadly.

Can you please go nuke where ever you read that from orbit?  Please?
It's the only way to be sure that the contagious cargo-cult
stupidity doesn't spread further.

> It turns out that when running with '-n size=4k'

i.e. the default.

> , indeed I do not get
> any warnings during a 10h test run. I'll try to come up with some more
> detailed benchmarking of the possible performance impacts, too.

No surprise there. :/

FWIW, for small file Ceph workloads (e.g swift stores) we've found
that 8k directory block sizes give marginal improvements over the
default 4k, but it's all down hill from there.

> Am I right in assuming that this parameter can not be tuned after the
> initial mkfs?

That's right.

> In that case getting a production-ready version of your
> patch would probably still be valuable for cluster admins wanting to
> avoid having to move all of their data to new filesystems.

Well, yes, that's why I'm working on it. But it's critical core
code, it's also damn tricky and complex, and if I get it wrong it
will corrupt filesystems. So I'm not going to rush a prototype fix
out into production systems no matter how much pressure people put
on me to ship a fix.

> >> Soon after this, operations get so slow that the OSDs die because of
> >> their suicide timeouts.
> >>
> >> Then I installed onto 3 servers this patch (applied onto kernel
> >> v4.4.1). The bad news is that I am still getting the kernel messages
> >> on these machines. The good news, though, is that they appear at a
> >> much lower frequency and also the impact on performance seems to be
> >> lower, so the OSD processes on these three nodes did not get killed.
> >
> > Right, the patch doesn't fix the underlying issue that memory
> > fragmentation can prevent high order allocation from succeeding for
> > long periods.  However, it does ensure that the filesystem does not
> > immediately deadlock memory reclaim when it happens so the system
> > has a chance to recover. It still can deadlock the filesystem,
> > because if we can't commit the transaction we can't unlock the
> > objects in the transaction and everything can get stuck behind that
> > if there's something sufficiently important in the blocked
> > transaction.
> 
> So how would your success criteria for getting this patch into
> upstream look like?

It's already "successful". I've proved locally that it avoids a memory
reclaim deadlock that many people have reported over the past year.
So there's no question that we need a fix to the problem; it's now
just a matter of determining if the issues with this fix (e.g.
doubling memory usage of the CIL) are an acceptible tradeoff for
production workloads, or whether I've got to go back and prototype a
fourth attempt at fixing the problem...

And, of course, there's only some many hours int eh day. I'm into my
19th right now, and I havent' got through everything on my list for
today yet. Tomorrow's list is even longer, and when I get through
that, I hit the big one: "read, understand and review 10000 lines of
complex new code"....

> Would a benchmark of the 64k directory block size
> case on machines all running with patched kernels be interesting? Or
> would that scenario disqualify itself as being mistuned in the first
> place?

Not really - I've confirmed it doesn't cause performance issues on
my usual tranche of benhmarks, so I'mnot conerned about that (it;s
the same amount of work being done, anyway).  Correctness is much
more important right now, and that takes time, effort and focus to
verify.

And speaking of focus, it's now time for me to sleep.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
