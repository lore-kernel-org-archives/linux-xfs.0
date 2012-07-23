Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6NNswHK258064 for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 18:54:58 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fg21rtOmeu44Rr4t for <xfs@oss.sgi.com>;
	Mon, 23 Jul 2012 16:54:56 -0700 (PDT)
Date: Tue, 24 Jul 2012 09:54:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Assert in xfs_repair (Phase 7) and other xfs_restore problems
Message-ID: <20120723235442.GM23387@dastard>
References: <alpine.LRH.2.02.1207202022300.7993@floggle-toggle.damtp.cam.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1207202022300.7993@floggle-toggle.damtp.cam.ac.uk>
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
To: Jon Peatfield <J.S.Peatfield@damtp.cam.ac.uk>
Cc: xfs@oss.sgi.com

On Fri, Jul 20, 2012 at 09:59:11PM +0100, Jon Peatfield wrote:
> I have been trying and failing to repair an xfs filesystem.
> Originally I was using the Scientific-Linux (like RHEL) provided
> xfs_repair (2.9.4) but when that failed I built the latest tarball
> (3.1.8)...

So it's an old filesystem, and you had some unknown corruption
event.

> Anyway all of the later runs now end with:
> 
> ...
> disconnected dir inode 3892327224, moving to lost+found
> disconnected dir inode 3892327225, moving to lost+found
> disconnected dir inode 3892327226, moving to lost+found
> disconnected dir inode 3892327227, moving to lost+found
> disconnected dir inode 3892327229, moving to lost+found
> disconnected dir inode 3892327231, moving to lost+found
> Phase 7 - verify and correct link counts...
> resetting inode 256 nlinks from 8 to 5
> resetting inode 261 nlinks from 2 to 13006001
> xfs_repair: phase7.c:47: set_nlinks: Assertion `fs_inode_nlink' failed.

It's trying to set the link count to ~13M.

> Now in phase7.c it asserts if nlinks is over 65536 which 13006001
> clearly is:
> 
>            do_warn(_("resetting inode %" PRIu64 " nlinks from %u to %u\n"),
>                    ino, dinoc->di_nlink, nrefs);
> 
>            if (dinoc->di_version == 1 && nrefs > XFS_MAXLINK_1)  {
>                    ASSERT(fs_inode_nlink);
>                    do_warn(
> _("nlinks %u will overflow v1 ino, ino %" PRIu64 " will be converted to version 2\n"),
>                            nrefs, ino);
> 
>            }
>            dinoc->di_nlink = nrefs;

And that is saying that your superblock does not have the NLINK
feature bit set, so it can't use version 2 inodes which support link
counts of up to 2^32.  Use xfs_db to set the NLINK bit, and re-run
repair.

FWIW, the mkfs default is to set the NLINK. That got changed some
4-5 years ago, IIRC...

> Mounting the fs now shows almost nothing, and worryingly the df
> output shows that the number of inodes in use has gone down by a lot
> - was ~60M inodes in use and now shows as 49M though that may simply
> be because 13M should be in lost+found ...

Yes, those 13M inodes are still disconnected because lost+found
couldn't reference them all.

> Have I completely destroyed this filesystem or is there any hope of
> getting any of the files back ? (all the error messages I have seen
> were about problems with the directories so some or all of the files
> and structures may still be present)...

Possibly.

> If it is destroyed (it only contained backup trees so I can live
> with it being lost), what should I have done differently?  ie what
> was my first mistake ?

Always keep your filesystem tools up to date, and not running a
trial reapir on a metadump image to find out what the damage was
before your tried to repair it on your only copy. Indeed, if it's
only 3TB of filesystem, you coul dhave easily spent a coupl eof
hundred dollars on a single disk and imaged the entire broken
filesystem before doing anything else....

> I ran an xfs_metadump but the result is pretty big - 12G - while
> running it seems to only think there are going to be ~23M inodes in
> the dump, maybe that number changes later.
> 
> Is there some fraction of this dump which would be of any use for
> any debugging ?

Probably not at this point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
