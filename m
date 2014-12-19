Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 317F37F3F
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 22:41:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F4CB304066
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 20:41:42 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fUyPot6rc7utpAZ7 for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 20:41:40 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Y1pNV-0002LB-PQ
	for xfs@oss.sgi.com; Fri, 19 Dec 2014 15:41:25 +1100
Date: Fri, 19 Dec 2014 15:41:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] xfsprogs: libxfs update to current kernel code
Message-ID: <20141219044125.GE24183@dastard>
References: <20141209234122.GC9756@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141209234122.GC9756@dastard>
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
To: xfs@oss.sgi.com

On Wed, Dec 10, 2014 at 10:41:22AM +1100, Dave Chinner wrote:
> Hi folks,
> 
> I just pushed a libxfs-3.19-update branch to 
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> That contains an update of the libxfs code to match the current
> kernel libxfs code. It's in pretty rough shape right now, but it
> seems to work. It will get rebased as I refine the patchset.

I just rebased this branch with a more recent version. Top commit
is:

13ea6a1 libxfs: split out xfs->libxfs mappings

> 
> The stages of the update are:
> 
> 	- rework some libxfs definitions
> 	- update to 3.16 code
> 	- introduce libxfs error negation patches
> 	- restructure libxfs to match kernel code
> 	- update to the current for-next branch

This part of the branch is unchanged.

> In doing this update, there are a few things that need to be
> separated out to the head of the series and made explicit:
> 
> 	- support for anything pre- dir V2 goes away, so there's a
> 	  bunch of new "use and older xfsprogs" conditions that need
> 	  to be added and a significant amount of "handle old bugs"
> 	  code that needs to go away
> 	- the equivalent kernel code only supports v2 inodes - it
> 	  unconditionally sets the NLINK feature bit and converts v1
> 	  inodes to v2 inodes. All the userspace tools need to be
> 	  updated to match - they'll read v1 inodes, but they'll
> 	  unconditionally set NLINK and write only v2 inodes.
> 	- the SHARED superblock stuff goes away, so killing that
> 	  needs to be a standalone patch

i.e. none of this has been done yet.

> 
> Given these changes in supported functionality, I expect the first
> release with this update to be a 3.3.0 release, not a 3.2.x release.
> This probably makes it a good time to update mkfs default behaviour
> as well (i.e. to default to CRC enabled filesystems).
> 
> There is also more cleanup work to be done after the 3.19 update:
> 
> 	- the include file structure is somewhat cludgy. I simply
> 	  made the new libxfs structure link into the existing
> 	  include/xfs structure in a slightly different way, but
> 	  this needs substantial rework to clean it up.
> 	- there is a convoluted mess of include files between
> 	  include/ and libxfs/ that determine what code gets
> 	  compiled and how it is seen externally. The first commit
> 	  in the series sort of points out how messy this is, but
> 	  this really needs to be better sorted to separate internal
> 	  and externally visible libxfs functions, as well as
> 	  separate libxfs structures from userspace structures like
> 	  struct xfs_mount....

But this is starting to take shape. What I've changed in terms of
structure is that libxfs/ now has a libxfs/support subdirectory,
into which I've moved all the userspace specific libxfs code. i.e:

	libxfs/*[ch]
		- matches kernel size fs/xfs/libxfs/*[ch]
	libxfs/support/*
		- contains all userspace libxfs support code

I've also changed some of the include files - there are some
"kernel equivalent" header files in libxfs/support now, e.g.
xfs_mount.h and xfs_inode.h which contain the userspace definitions
of the structures (e.g. struct xfs_mount) used by the libxfs code.
This means that th elibxfs code can mostly use the same include
files and so reduce the differences between the two code bases.

I've renamed libxfs/xfs.h to libxfs/support/libxfs_priv.h to remove
the ambiguity with include/xfs.h.

I've also separated out all the xfs->libxfs mapping macros into
a libxfs/support/libxfs_api_defs.h file. This is included into both
libxfs/support/libxfs_priv.h and include/libxfs.h, allowing
include/libxfs.h to get rid of all the libxfs_* function prototypes
as everything is correctly mapped just by including the libxfs/xfs*h
header files after the mapping macros.

This has greatly simplified include/libxfs.h, and shown exactly
where we still have mismatches between userspace and kernel space.
There's still more work to do here, but the majority of the
userspace libxfs restructuring is present in the branch.

FYI, ignoring file movement, the diffstat so far looks like this:

$ git diff --stat -C -M origin/master..origin/libxfs-3.19-update
....
150 files changed, 8295 insertions(+), 7378 deletions(-)

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
