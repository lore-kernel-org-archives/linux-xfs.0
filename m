Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0FCC7F50
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 19:02:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B15FF8F8039
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 17:02:06 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id i5jK0y7YcBBHwuyb
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 17:02:05 -0700 (PDT)
Subject: Re: inode64 directory placement determinism
MIME-Version: 1.0
Date: Mon, 18 Aug 2014 19:02:04 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
In-Reply-To: <20140818224853.GD26465@dastard>
References: <e1eeba7b0fb97c63e41f40ed9ac162d7@localhost>
	<20140818070153.GL20518@dastard>
	<bc34a576d2b3e8c431633574deaa37cc@localhost>
	<20140818224853.GD26465@dastard>
Message-ID: <ed7598d015f5a1d3576e6b03f3ef3116@localhost>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 19 Aug 2014 08:48:53 +1000, Dave Chinner <david@fromorbit.com>
wrote:
> On Mon, Aug 18, 2014 at 11:16:12AM -0500, Stan Hoeppner wrote:
>> On Mon, 18 Aug 2014 17:01:53 +1000, Dave Chinner <david@fromorbit.com>
>> wrote:
>> > On Sun, Aug 17, 2014 at 10:29:21PM -0500, Stan Hoeppner wrote:
>> >> Say I have a single 4TB disk in an md linear device.  The md device
>> >> has
>> a
>> >> filesystem on it formatted with defaults.  It has 4 AGs, 0-3.  I
have
>> >> created 4 directories.  Each should reside in a different AG, the
>> >> first
>> >> in
>> >> AG0.  Now I expand the linear device with an identical 4TB disk and
>> >> execute
>> >> xfs_growfs.  I now have 4 more AGs, 4-7.  I create 4 more
directories.
>> >> 
>> >> Will these 4 new dirs be created sequentially in AGs 4-7, or in the
>> first
>> >> 4 AGs?  Is this deterministic, or is there any chance involved?  On
>> >> the
>> > 
>> > Deterministic, assuming single threaded *file-system-wide* directory
>> > creation. Completely unpredictable under concurrent directory
>> > creations.  See xfs_ialloc_ag_select/xfs_ialloc_next_ag.
>> > 
>> > Note that the rotor used to select the next AG is set to
>> > zero at mount.
>> > 
>> > i.e. single threaded behaviour at agcount = 4:
>> > 
>> > dir number	rotor value	  destination AG
>> >  1		  0			0
>> >  2		  1			1
>> >  3		  2			2
>> >  4		  3			3
>> >  5		  0			0
>> >  6		  1			1
>> > ....
>> > 
>> > So, if you do what you suggest, and grow *after* the first 4 dirs
>> > are created, the above is what you'll get because the rotor goes
>> > back to zero on the fourth directory create. Now, with changing from
>> > 4 to 8 AGs after the first 4:
>> > 
>> > dir number	rotor value	  new inode location (AG)
>> >  1		  0			0
>> >  2		  1			1
>> >  3		  2			2
>> >  4		  3			3
>> > <grow to 8 AGs>
>> >  5		  0			0
>> >  6		  1			1
>> >  7		  2			2
>> >  8		  3			3
>> >  9		  4			4
>> >  10		  5			5
>> >  11		  6			6
>> >  13		  7			7
>> >  14		  0			0
>> > 
>> >> real system these 4TB drives are actually 48TB LUNs.  I'm after
>> >> deterministic parallel bandwidth to subsequently added RAIDs after
>> >> each
>> >> grow operation by simply writing to the proper directory.
>> > 
>> > Just create new directories and use the inode number to
>> > determine their location. If the directory is not in the correct AG,
>> > remove it and create a new one, until you have directories located
>> > in the AGs you want.
>> > 
>> > Cheers,
>> > 
>> > Dave.
>> 
>> 
>> Thanks for the info Dave.  Was hoping it would be more straightforward.

>> Modifying the app for this is out of the question.  They've spent 3+
>> years
>> developing with EXT4 and decided to try XFS at the last minute. 
Product
>> is
>> to ship in October, so optimizations I can suggest are limited.
> 
> Perhaps you could actually tell us what the requirement for
> layout/separation is, and how they are acheiving it with ext4. We
> really need a more "directed" allocation ability, but it's not clear
> exactly what requirements need to drive that.
> 
> Cheers,
> 
> Dave.

The test harness app writes to thousands of preallocated files in hundreds
of directories.  The target is ~250MB/s at the application per array, more
if achievable, writing a combination of fast and slow streams from up to
~1000 threads, to different files, circularly.  The mix of stream rates and
the files they write will depend on the end customers' needs.  Currently
they have 1 FS per array with 3 top level dirs each w/3 subdirs, 2 of these
with ~100 subdirs each, and hundreds files in each of those.  Simply doing
a concat, growing and just running with it might work fine.  The concern is
ending up with too many fast stream writers hitting AGs on a single array
which won't be able to keep up.  Currently they simply duplicate the layout
on each new filesystem they mount.  The application duplicates the same
layout on each filesystem and does its own load balancing among the group
of them.

Ideally they'd obviously like to simply add files to existing directories
after growing, but that won't achieve scalable bandwidth.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
