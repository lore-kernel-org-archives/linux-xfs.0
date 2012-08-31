Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7V5wW19109004 for <xfs@oss.sgi.com>; Fri, 31 Aug 2012 00:58:33 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	eEnjxY3wp7aYmHoT for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 22:59:25 -0700 (PDT)
Date: Fri, 31 Aug 2012 15:59:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Mount Recovery Failed on Root File System After Power Outage
Message-ID: <20120831055917.GI15292@dastard>
References: <0e85aee5ff82e567e872230ef416766a.squirrel@emailmg.netfirms.com>
	<20120830225826.GG15292@dastard>
	<5c63bed077c12fe7f7ad64237c767101.squirrel@emailmg.netfirms.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5c63bed077c12fe7f7ad64237c767101.squirrel@emailmg.netfirms.com>
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
To: Chin Gim Leong <CHIN_Gim_Leong@performance-computing.net>
Cc: xfs@oss.sgi.com

On Fri, Aug 31, 2012 at 12:24:21PM +0800, Chin Gim Leong wrote:
> Thanks Dave for the reply.
> 
> >> I just had a power outage and my Acer notebook computer running openSUSE
> >> 11.4 x86_64 with kernel 2.6.37 stopped as a result.
> >
> > What mount options? What is the output of /proc/mounts? What are the
> > messages in dmesg when you mount a partition?
> >
> 
> The dmesg messages after the mount failure are exactly as in
> /var/log/messages:
> 
> XFS: Invalid block length (0xfffffffc) given for buffer
> XFS: log mount/recovery failed: error 117
> 
> The mount options I used, I do not remember the fstab options I put in for
> root, but any way, whether with fstab or a manual mount, the mount fails.
> The OS actually starts with a read-only mount of root file system, and the
> rest of the system refuses to start of course.

You misunderstood. I was asking for the messages when it
successfully mounts and the contents of /proc/mounts is when it is
mounted to see if barriers were disabled or not supported on your
hardware.

> I will put in an upddate to this thread after I repair the file system,
> maybe tomorrow, about the mount options in fstab.
> 
> I can do a manual mount with ready only and no recovery option, and I can
> traverse the directories.  In fact the /var/log/message is still there and
> readable with entries up to 5 min before the power outage.
> 
> >
> >> I would like to know the cause of this log recovery failure and if there
> >
> > You've got an old, unsupported kernel that was going through
> > significant changes to the log code at the time, so it may not be
> > possible to work out what the problem was. It seems likely that the
> > power loss caused the disk not to write everything it should have to
> > the log - laptops are not supposed to just lose power because
> > they have a built in UPS (i.e. battery)....
> 
> My note book is connected to the mains, and there is no battery.  The Acer
> user manual advises removing the battery when one is connected to the
> mains, since repeated charging of battery will shorten its life span.

It's not charging Li-ion batteries that shortens their life - it's
high temperatures that shorten it. IOWs, the reason for removing the
battery when on AC is to prevent heat soak and the battery
sustaining elevated temperatures over long periods of time.

Even so, properly designed laptops don't suffer from heat soak or
charge cycle related battery life problems, and environmental
conditions play more of a part in determining battery life than
usage/charge patterns...

> > The files in lost+found are numbered by their inode number. You need
> > to look at the contents of them to determine where they came from.
> 
> Inode numbers are not informative, right?

Sure, but when you've had a directory corruption and the names have
been lost, what do you name the files and directories that are
found? All we can do is name them something unique, hence the use of
the inode number.

> Text files are readable, but binaries......, I will have no clue, and if I
> delete them, who knows if I am deleting some thing really important?

Only by looking at them can you know. Regardless of what filesystem
you are using, recovery of files and directories from lost+found is
the same process. e.g. do an rpm check to see if allteh installed
packages are intact. that will narrow down where all your binaries
came from. use of strings can also tell you what the binary is. e.g:

$ strings /sbin/xfs_repair |grep xfs_repair
re-running xfs_repair.  If you are unable to mount the filesystem, then use
Please run a more recent version of xfs_repair.
$

> Intuitively, the only files in root file system (by the way, root also
> contains /boot) that are open for writing are those in logs and /tmp and
> /var/tmp, I hope that is the case and I can safely discard those in
> lost+found.
> 
> I also hope that the inode link clean-ups done by xfs_repair do not
> actually remove any files that are really there.

Define "really there" when important metadata (i.e. the log) has
been corrupted and is not available any more.  Indeed, if things
like btree splits of merges occurred in the log, and they are
partially written to disk, it's entirely possible that you could
lose directory references to inodes that haven't been modified for
some time....

Remember, like all fsck programs, xfs_repair is a best effort
attempt at correcting the problems found  - there are no guarantees
given about what it can and can't recover when it runs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
