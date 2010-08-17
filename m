Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7H7DE5k031417 for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 02:13:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B5C8CC6254
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 00:22:53 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	dVFDLNCnR72tMctK for <xfs@oss.sgi.com>;
	Tue, 17 Aug 2010 00:22:53 -0700 (PDT)
Date: Tue, 17 Aug 2010 17:13:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump-3.0.4 problems
Message-ID: <20100817071337.GN10429@dastard>
References: <20100816182236.249a2a0f@x2.grafnetz>
	<20100816223021.GL10429@dastard>
	<20100817083227.06e23889@x2.grafnetz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100817083227.06e23889@x2.grafnetz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mario Bachmann <mbachman@stud.uni-frankfurt.de>
Cc: xfs@oss.sgi.com

On Tue, Aug 17, 2010 at 08:32:27AM +0200, Mario Bachmann wrote:
> Am Tue, 17 Aug 2010 08:30:21 +1000
> schrieb Dave Chinner <david@fromorbit.com>:
> =

> > On Mon, Aug 16, 2010 at 06:22:36PM +0200, Mario Bachmann wrote:
> > > Hello, =

> > > =

> > > my kernel is
> > > Linux x2 2.6.35.2 #1 SMP Sun Aug 15 00:32:14 CEST 2010 x86_64 AMD Ath=
lon(tm) 64 X2 Dual Core Processor 5600+ AuthenticAMD GNU/Linux
> > > =

> > > I get a lot of Warnings with xfsdump-3.0.4 (booth, gentoo package 3.0=
.4-r1 and git-version):
> > > =

> > > x2 ~/source/d/xfsdump/dump # ./xfsdump -l0 -L "Test" - /dev/sda2 |gzi=
p - > /mnt/data2/dump_text.gz
> > .....
> > > ./xfsdump: WARNING: could not stat dirent .crack-attack ino 100663674=
: Das Argument ist ung=FCltig: using null generation count in directory ent=
ry
> > =

> > bulkstat is failing, indicating an invalid option was passed.
> > =

> > > With the "old" version xfsdump-3.0.1, I get no warnings!
> > > xfsdump -l0 -L "Test" - /dev/sda2 |gzip - > /mnt/data2/dump301_test.gz
> > > xfsdump: using file dump (drive_simple) strategy
> > > xfsdump: version 3.0.1 (dump format 3.0) - Running single-threaded
> > ....
> > > xfsdump: Dump Status: SUCCESS
> > > =

> > > And the file is 4,8 GB. All seems to be correct!
> > =

> > I can't see any changes between 3.0.1 and 3.0.4 that would explain
> > this. Did you run them on the same machine and kernel? Did you build
> > them with the same compiler? If everything is the same, then perhaps
> > you could bisect (only a few changes so should be quick) to point
> > out the offending change.
> =

> After some testing, I think it is NOT a problem with xfsdump, but
> with the new kernel 2.6.35.2. First I must correct my last
> posting: xfsdump-3.0.1 DO have the same problem as xfsdump-3.0.4
> on kernel 2.6.35.2. It was just a coincidence that is worked one
> time without problems...
> =

> Machines: I have two x86_64 and one x86. All machines have the
> same problems after I upgraded all three Kernels from 2.6.34.x to
> 2.6.35.2. So I believe, it is a problem with 2.6.35.2 or the
> combination of [2.6.35.2 & xfsdump].
> =

> Compiler: I use "gcc (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) 4.4.4". =

> =

> Testing List (on one machine only):
> works:   x86_64, 2.6.34.4, xfsdump-3.0.1
> works:   x86_64, 2.6.34.4, xfsdump-3.0.4
> failure: x86_64, 2.6.35.2, xfsdump-3.0.1 (worked only one time)
> failure: x86_64, 2.6.35.2, xfsdump-3.0.4

Ok, that makes more sense - we changed the way bulkstat works in
from 2.6.34 to 2.6.35 to correctly validate inode numbers being
passed in via bulkstat, and hence files unlinked during the dump run
could return EINVAL when validating the directory structure (as they
no longer exist). Is you system completely idle while the dump
is running, or are files being removed while the dump is running?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
