Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6OLf5ug198463 for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 16:41:05 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tJZhAlN58FWhbRhV for <xfs@oss.sgi.com>;
	Tue, 24 Jul 2012 14:41:03 -0700 (PDT)
Date: Wed, 25 Jul 2012 07:41:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Assert in xfs_repair (Phase 7) and other xfs_restore problems
Message-ID: <20120724214100.GP23387@dastard>
References: <alpine.LRH.2.02.1207202022300.7993@floggle-toggle.damtp.cam.ac.uk>
	<20120723235442.GM23387@dastard>
	<alpine.LRH.2.02.1207241927350.7993@floggle-toggle.damtp.cam.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1207241927350.7993@floggle-toggle.damtp.cam.ac.uk>
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

On Tue, Jul 24, 2012 at 07:28:48PM +0100, Jon Peatfield wrote:
> On Tue, 24 Jul 2012, Dave Chinner wrote:
> 
> ...
> >>Now in phase7.c it asserts if nlinks is over 65536 which 13006001
> >>clearly is:
> >>
> >>           do_warn(_("resetting inode %" PRIu64 " nlinks from %u to %u\n"),
> >>                   ino, dinoc->di_nlink, nrefs);
> >>
> >>           if (dinoc->di_version == 1 && nrefs > XFS_MAXLINK_1)  {
> >>                   ASSERT(fs_inode_nlink);
> >>                   do_warn(
> >>_("nlinks %u will overflow v1 ino, ino %" PRIu64 " will be converted to version 2\n"),
> >>                           nrefs, ino);
> >>
> >>           }
> >>           dinoc->di_nlink = nrefs;
> >
> >And that is saying that your superblock does not have the NLINK
> >feature bit set, so it can't use version 2 inodes which support link
> >counts of up to 2^32.  Use xfs_db to set the NLINK bit, and re-run
> >repair.
> >
> >FWIW, the mkfs default is to set the NLINK. That got changed some
> >4-5 years ago, IIRC...
> 
> Thanks for this.
> 
> The original filesystem is about 8 years old so it would have been
> created before that change even if we had the latest versions of the
> xfsprogs at the time.

....

> Am I missing the obvious way to set this bit?

xfs_repair shouldn't set or clear feature bits unless asked, and
this case is someting we haven't seen before. I can't recall ever
having seen this, even when nlink wasn't set by default....

xfs_db is the answer. i.e.

# xfs_db -x -c version nlink <dev>
versionnum [0xb584+0x8] = V4,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2

take the first version 0xb584, and or the nlink bit in:

#define XFS_SB_VERSION_NLINKBIT         0x0020

to give 0xb5a4, and run the command:

# xfs_db -x -c "sb 0" -c "write versionnum 0xb5a4" <dev>

And that will set the bit in the superblock and allow repair to
handle inodes with more than 64k links.

> BTW on a fresh fs made with and older mkfs.xfs (the one from RHEL5)
> the NLINK bit isn't set initially but seems to become set once I
> cause an inode to have more than 65536 links...

Right - that's the dynamic behaviour I mentioned.

> # xfs_db -c version /dev/SpudSnaps/Test2
> versionnum [0xb584+0x8] = V4,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2
> # mount /dev/SpudSnaps/Test2 /mnt/testing/
> # mkdir /mnt/testing/foo
> # for i in $(seq 1 65537); do mkdir /mnt/testing/foo/$i; done
> # umount /mnt/testing
> # xfs_db -c version /dev/SpudSnaps/Test2
> versionnum [0xb5b4+0x8] = V4,ATTR,NLINK,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2
> 
> So is it actually some other feature which needs to be set to allow
> NLINK to be set?

No, the kernel does it automatically. Like I said, old mkfs.xfs
binaries did not set the bit, relying on the kernel to automatically
add it when necessary. i.e. going back 15 years, you could upgrade
your Irix kernel an magically get >64k link count support in XFS
without doing anything else...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
