Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A80B47F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 20:23:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6995B30405F
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 18:23:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZEQr2zF3AaP9eku5 for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 18:23:28 -0700 (PDT)
Date: Mon, 15 Jul 2013 11:22:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: specify agsize?
Message-ID: <20130715012229.GF5228@dastard>
References: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
	<51E2092D.7090409@sandeen.net>
	<9AB8D1D3-29D7-4C43-A624-37024CA4EFD9@gmail.com>
	<51E2CE83.9080003@sandeen.net>
	<24AC7E60-49D1-4D6E-8B6F-531C46CDCF53@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <24AC7E60-49D1-4D6E-8B6F-531C46CDCF53@gmail.com>
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
To: aurfalien <aurfalien@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sun, Jul 14, 2013 at 10:14:15AM -0700, aurfalien wrote:
> On Jul 14, 2013, at 9:14 AM, Eric Sandeen wrote:
> > On 7/13/13 11:20 PM, aurfalien wrote:
> >> On Jul 13, 2013, at 7:13 PM, Eric Sandeen wrote:
> >>> On 7/13/13 7:11 PM, aurfalien wrote:
> >>>> Hello again,
> >>>> 
> >>>> I have a Raid 6 x16 disk array with 128k stripe size and a
> >>>> 512 byte block size.
> >>>> 
> >>>> So I do;
> >>>> 
> >>>> mkfs.xfs -f -l size=512m -d su=128k,sw=14
> >>>> /dev/mapper/vg_doofus_data-lv_data
> >>>> 
> >>>> And I get;
> >>>> 
> >>>> meta-data=/dev/mapper/vg_doofus_data-lv_data isize=256
> >>>> agcount=32, agsize=209428640 blks =
> >>>> sectsz=512   attr=2, projid32bit=0 data     =
> >>>> bsize=4096   blocks=6701716480, imaxpct=5 =
> >>>> sunit=32     swidth=448 blks naming   =version 2
> >>>> bsize=4096   ascii-ci=0 log      =internal log
> >>>> bsize=4096   blocks=131072, version=2 =
> >>>> sectsz=512   sunit=32 blks, lazy-count=1 realtime =none
> >>>> extsz=4096   blocks=0, rtextents=0
> >>>> 
> >>>> 
> >>>> All is fine but I was recently made aware of tweaking agsize.
> >>> 
> >>> Made aware by what?  For what reason?
> >> 
> >> Autodesk has this software called Flame which requires very
> >> very fast local storage using XFS. They have an entire write up
> >> on how to calc proper agsize for optimal performance.
> > 
> > http://wikihelp.autodesk.com/Creative_Finishing/enu/2012/Help/05_Installation_Guides/Installation_and_Configuration_Guide_for_Linux_Workstations/0118-Advanced118/0194-Manually194/0199-Creating199
> > 
> > I guess?
> > 
> > That's quite a procedure!  And I have to say, a slightly strange
> > one at first glance.
> > 
> > It'd be nice if they said what they were trying to accomplish
> > rather than just giving you a long recipe.
> 
> 
> Sorry to double reply to the same thread.
> 
> But the volume in question (regarding the Autodesk article) is
> used for very fast playback of image files.  So realtime
> performance for files of 2048x1556 resolution.  These files are
> being touched/retouched throughout the day by the person driving
> the Flame.

Sure - it's file per frame video that is being used here, and 2k
resolution is generally around 12.5MB per frame. If you are
concerned about playback rates, then it is far more important that
the frames are laid out sequentially on disk than anything else.
Tuning the number of AGs doesn't acheive that - increasing the
number of AGs is more likely to cause them to be written all over
the place, especially as the filesystem ages and AGs fill up.


> The fragmentation on these systems on a heavy day, meaning one
> were they are running at 98% full is about 5% on avg.  On any
> given day, the systems are about 80% full.

If they are running their filesystems to 98% full, they they have
already given up any hope they have of getting reliable layout of
their video files.

If you are concerned about low latency, high throughput playback,
then it's far more important to get the stripe width set up
correctly for the size of the file so each frame is stripe width
aligned and each frame takes a single physical IO to read from disk
and there is minimal seek between the two frames.

The only reason I can see for increasing the number of AGs here is
that they are trying to limit the number of video directories that
share the same AGs as they are specifying the inode64 mount option.
i.e. the assumption is that each video clip is sufficiently large
that with 128AGs it is unlikely that two video clips will end up in
the same AG and hence potentially interleave as they are
modified....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
