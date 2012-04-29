Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3T0ldIR066574 for <xfs@oss.sgi.com>; Sat, 28 Apr 2012 19:47:39 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XoXEEDgdz4BHjnKT for <xfs@oss.sgi.com>;
	Sat, 28 Apr 2012 17:47:10 -0700 (PDT)
Date: Sun, 29 Apr 2012 10:35:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem recovering XFS filesystem
Message-ID: <20120429003539.GP9541@dastard>
References: <CAK6JqP3ze2pocsgoKUTZx_J6w-Zc9V=StqDnqG0Gx0v5hw=FGQ@mail.gmail.com>
	<18818650.cGNyynGa9I@saturn>
	<CAK6JqP3Da7E6dumOuvF12uLKXeTKAWdLw3gYs6ZtEhw3WEDQeg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAK6JqP3Da7E6dumOuvF12uLKXeTKAWdLw3gYs6ZtEhw3WEDQeg@mail.gmail.com>
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
To: Aaron Williams <aaron.w2@gmail.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Fri, Apr 27, 2012 at 07:04:48PM -0700, Aaron Williams wrote:
> On Fri, Apr 27, 2012 at 2:31 PM, Michael Monnerie <
> michael.monnerie@is.it-management.at> wrote:
> 
> > Am Donnerstag, 26. April 2012, 13:00:06 schrieb Aaron Williams:
> > > I was able to recover the filesystem.
> >
> > So your RAID busted the filesystem. Maybe the devs could want an
> > xfs_metadump of the FS before your repair, so they can inspect it and
> > improve xfs_repair.
> >
> > Hi Michael,

<snip story of woe>

> Once that was done Linux refused to mount the XFS partition, I think due to
> corruption in the log.

The reason will be in the log. e.g dmesg |tail -100 usually tells
you why it failed to mount.

> I have an image of my pre-repaired filesystem by using dd and can try and
> do a meta dump. The filesystem is 1.9TB in size with about 1.2TB of data in
> use.

ISTR that metadump needs the log to be clean first, too.

> It looks like I was able to recover everything fine after blowing away the
> log. I see a bunch of files recovered in lost+found but those all appear to
> be files like cached web pages, etc.
> 
> I also dumped the log to a file (128M).
> 
> So far it looks like any actual data loss is minimal (thankfully) and was a
> good wakeup call to start doing more frequent backups.
> 
> I also upgraded xfsprogs from 3.1.6-2.1.2 to 3.1.8 which did a much better
> job at recovery than my previous attempt.

That's good to know ;)

> It would be nice if xfs_db would allow me to continue when the log is dirty
> instead of requiring me to mount the filesystem first.

Log recovery is done by the kernel code, not userspace, which is why
there is this requirement. If the kernel can't replay it, then you
have to use xfs_repair to zero it. Unforutnately, you can't just
zero the log with xfs_repair - you could do it hackily by terminatin
xfs_reapir just after it has zeroed the log....

> It also would be
> nice if xfs_logprint could try and identify the filenames of the inodes
> involved.

xfs_logprint just analyses the log transactions - it knows nothing
about the structure of the filesystem and doesn't even mount it. If
you want to know the names of the inodes, then use xfs_db once you
have the inode numbers in question. That requires a full filesystem
traversal to find the name for the inode number in question, so can
be *very* slow. Given that there can be hundreds of thousands of
unique inodes in the log, that sort of translation woul dbe
*extremely* expensive.

> I understand that there are plans to update XFS to include the UID

UUID, not UID.

> in all of the on-disk structures. Any idea on when this will
> happen?

When it is ready. And then you'll have to mkfs a new filesystem to
use it because it can't be retro-fitted to existing filesystems....

I'm already pushing infrastructure changes needed to support all the
new on-disk functionality into the kernel, so the timeframe is
months for experimental support on the new on-disk format....

Cheers,

Dave.
> 
> -Aaron

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
