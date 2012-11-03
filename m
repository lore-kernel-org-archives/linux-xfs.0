Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA31rJaZ227376 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 20:53:19 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OVCQ93lp4ADtOCGE for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 18:55:11 -0700 (PDT)
Date: Sat, 3 Nov 2012 12:55:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: status of userspace release
Message-ID: <20121103015509.GF29378@dastard>
References: <20121025151501.GV1377@sgi.com> <20121102055102.GY29378@dastard>
	<20121102185923.GG9783@sgi.com> <20121102230334.GA29378@dastard>
	<20121103001639.GD29378@dastard> <509474E4.3060309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <509474E4.3060309@sandeen.net>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Fri, Nov 02, 2012 at 08:35:32PM -0500, Eric Sandeen wrote:
> On 11/2/12 7:16 PM, Dave Chinner wrote:
> > On Sat, Nov 03, 2012 at 10:03:34AM +1100, Dave Chinner wrote:
> >> On Fri, Nov 02, 2012 at 01:59:23PM -0500, Ben Myers wrote:
> >>> Hi Dave,
> >>>
> >>> On Fri, Nov 02, 2012 at 04:51:02PM +1100, Dave Chinner wrote:
> >>>> On Thu, Oct 25, 2012 at 10:15:01AM -0500, Ben Myers wrote:
> >>>>> Hi Folks,
> >>>>>
> >>>>> We're working toward a userspace release this month.  There are several patches
> >>>>> that need to go in first, including backing out the xfsdump format version bump
> >>>>> from Eric, fixes for the makefiles from Mike, and the Polish language update
> >>>>> for xfsdump from Jakub.  If anyone knows of something else we need, now is the
> >>>>> time to flame about it.  I will take a look around for other important patches
> >>>>> too.
> > ....
> >>> The TODO list for userspace release currently stands at:
> >>>
> >>> 1) fix the header checksum failures... which is resolved
> >>> 2) fix a futex hang in 059
> >>> 3) fix the golden output changes related to multistream support in xfsdump
> >>>    and --largefs
> >>
> >> Well, understand them first, then fix ;)
> >>
> >>> 4) test on more platforms
> > 
> > Another:
> > 
> > $ sudo xfs_info /mnt/scratch/
> > meta-data=/dev/vdc               isize=256    agcount=4, agsize=12800 blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=51200, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=1200, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > $ sudo xfs_db -r -c "sb 0" -c "version" /dev/vdc
> > versionnum [0xb4a4+0x8a] = V4,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT
> > $
> > 
> > xfs_info is not reporting the 32 bit project ID status.
> 
> Weird, I didn't realize that
> [PATCH 2/2] xfsprogs: report projid32 status in growfs output
> hadn't been pulled in.
> 
> > Yes, I know this requires the XFS_IOC_FSGEOM support for it, but I'd
> > like it this release to at least say "off or unknown" here.
> 
> Heh, ok, when you reviewed you said it was no big deal ;)  but I guess
> we can add the "or unknown" if you like.

It probably doesn't matter that much, because we'll know if it is
supporte dbyt the kernel the user is running. having it there is the
most important thing.

> > I say this, because this is the first thing I noticed when having a
> > look at a test 287 failure:
> 
> Hm that's pretty odd.

Yeah, Still need to get to the bottom of it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
