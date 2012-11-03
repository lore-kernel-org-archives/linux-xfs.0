Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA30EnGR211280 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 19:14:49 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9AwQZAoxmLA8JKCa for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 17:16:41 -0700 (PDT)
Date: Sat, 3 Nov 2012 11:16:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: status of userspace release
Message-ID: <20121103001639.GD29378@dastard>
References: <20121025151501.GV1377@sgi.com> <20121102055102.GY29378@dastard>
	<20121102185923.GG9783@sgi.com> <20121102230334.GA29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121102230334.GA29378@dastard>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Nov 03, 2012 at 10:03:34AM +1100, Dave Chinner wrote:
> On Fri, Nov 02, 2012 at 01:59:23PM -0500, Ben Myers wrote:
> > Hi Dave,
> > 
> > On Fri, Nov 02, 2012 at 04:51:02PM +1100, Dave Chinner wrote:
> > > On Thu, Oct 25, 2012 at 10:15:01AM -0500, Ben Myers wrote:
> > > > Hi Folks,
> > > > 
> > > > We're working toward a userspace release this month.  There are several patches
> > > > that need to go in first, including backing out the xfsdump format version bump
> > > > from Eric, fixes for the makefiles from Mike, and the Polish language update
> > > > for xfsdump from Jakub.  If anyone knows of something else we need, now is the
> > > > time to flame about it.  I will take a look around for other important patches
> > > > too.
....
> > The TODO list for userspace release currently stands at:
> > 
> > 1) fix the header checksum failures... which is resolved
> > 2) fix a futex hang in 059
> > 3) fix the golden output changes related to multistream support in xfsdump
> >    and --largefs
> 
> Well, understand them first, then fix ;)
> 
> > 4) test on more platforms

Another:

$ sudo xfs_info /mnt/scratch/
meta-data=/dev/vdc               isize=256    agcount=4, agsize=12800 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=51200, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo xfs_db -r -c "sb 0" -c "version" /dev/vdc
versionnum [0xb4a4+0x8a] = V4,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT
$

xfs_info is not reporting the 32 bit project ID status.

Yes, I know this requires the XFS_IOC_FSGEOM support for it, but I'd
like it this release to at least say "off or unknown" here.

I say this, because this is the first thing I noticed when having a
look at a test 287 failure:

7 10s ... - output mismatch (see 287.out.bad)
--- 287.out     2012-10-05 11:38:08.000000000 +1000
+++ 287.out.bad 2012-11-03 10:55:15.000000000 +1100
@@ -2,22 +2,24 @@
 No 32bit project quotas:
 projid = 1234
 projid = 0
+xfs_quota: cannot set project on /mnt/scratch/pquota/32bit: Invalid argument
 With 32bit project quota support:
 projid = 1234
-projid = 2123456789
+projid = 0
+xfs_quota: cannot set project on /mnt/scratch/restore/pquota/32bitv2: Invalid argument
 The restored file system + one additional file:
 projid = 1234
-projid = 2123456789
-projid = 2123456789
+projid = 0
+projid = 0
 These two values of 16bit project quota ids shall be the same
-core.projid_lo = 1234
+core.projid_lo = 0
 core.projid_hi = 0
 core.projid_lo = 1234
 core.projid_hi = 0
 These three values of 32bit project quota ids shall be the same
-core.projid_lo = 24853
-core.projid_hi = 32401
-core.projid_lo = 24853
-core.projid_hi = 32401
-core.projid_lo = 24853
-core.projid_hi = 32401
+core.projid_lo = 0
+core.projid_hi = 0
+core.projid_lo = 0
+core.projid_hi = 0
+core.projid_lo = 0
+core.projid_hi = 0

Here's what's curious - this is failing on the 17TB filesystem, but
is not failing on 10-20GB filesystems. There seems to be a pattern
here....

Note that I only recently updated xfstests on the VM with the 17TB
filesystem (i.e. on wednesday), so this is probably the first time I
have run test 287 on a large filesystem like this. Same goes for
much of the other problems I'm reporting - xfstests on this machine
has been running out of dev branch I hadn't updated for a while, so
these problems might have been around for a while on large
filesystems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
