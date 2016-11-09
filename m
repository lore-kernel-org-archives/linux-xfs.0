Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752730AbcKIJNr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Nov 2016 04:13:47 -0500
Date: Wed, 9 Nov 2016 17:13:44 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 8/9] xfs: fuzz every field of every structure
Message-ID: <20161109091344.GX27776@eguan.usersys.redhat.com>
References: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
 <147830508036.1919.9626426021774095650.stgit@birch.djwong.org>
 <20161109080924.GT27776@eguan.usersys.redhat.com>
 <20161109085236.GE16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161109085236.GE16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Nov 09, 2016 at 12:52:36AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 09, 2016 at 04:09:24PM +0800, Eryu Guan wrote:
> > On Fri, Nov 04, 2016 at 05:18:00PM -0700, Darrick J. Wong wrote:
> > > Previously, our XFS fuzzing efforts were limited to using the xfs_db
> > > blocktrash command to scribble garbage all over a block.  This is
> > > pretty easy to discover; it would be far more interesting if we could
> > > fuzz individual fields looking for unhandled corner cases.  Since we
> > > now have an online scrub tool, use it to check for our targeted
> > > corruptions prior to the usual steps of writing to the FS, taking it
> > > offline, repairing, and re-checking.
> > > 
> > > These tests use the new xfs_db 'fuzz' command to test corner case
> > > handling of every field.  The 'print' command tells us which fields
> > > are available, and the fuzz command can write zeroes or ones to the
> > > field; set the high, middle, or low bit; add or subtract numbers; or
> > > randomize the field.  We loop through all fields and all fuzz verbs to
> > > see if we can trip up the kernel.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The first test gave me a kernel crash :) xfs/1300 crashed your kernel
> > djwong-devel branch. I appended the console log at the end of this mail
> > if you have interest to see it.
> > 
> > And another xfs/1300 run gave me this failure message:
> > 
> >     +/mnt/testarea/scratch: Kernel lacks GETFSMAP; scrub will be less efficient. (xfs.c line 661)
> >     +/mnt/testarea/scratch: Kernel cannot help scrub metadata; scrub will be incomplete. (xfs.c line 661)
> >     +/mnt/testarea/scratch: Kernel cannot help scrub inodes; scrub will be incomplete. (xfs.c line 661)
> >     +/mnt/testarea/scratch: Kernel cannot help scrub extent map; scrub will be less efficient. (xfs.c line 661)
> > 
> > Is this known issue or something should be filtered out in the test?
> 
> That's strange, the djwong-devel branch should have getfsmap & scrub in it...
> 
> ...are you running the djwong-devel kernel and xfsprogs code?  The scrub
> ioctl structure has shifted some over the past few months, though GETFSMAP
> hasn't changed in ages.
> 
> Wait, "another xfs/1300 run" ... so after the first crash, did you go
> back to a vanilla kernel without all my crazypatches? :)

Ahh, you're right! It booted into 4.9-rc4 vanilla kernel, sorry about
that.. But xfs/1300 crashed djwong-devel for the second time in my
second try, seems the crash is reliable reproduced, with reflink
enabled.

> 
> > And ext4/1300 generated large .out.bad file (51M), containing something
> > like:
> > 
> > +/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101381632/2469888/4096) ends past end of filesystem at 31457280. (generic.c line 272)
> > +/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101389824/2478080/4096) starts past end of filesystem at 31457280. (generic.c line 264)
> > +/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101389824/2478080/4096) ends past end of filesystem at 31457280. (generic.c line 272)
> > +/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101398016/2486272/4096) starts past end of filesystem at 31457280. (generic.c line 264)
> > +/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101398016/2486272/4096) ends past end of filesystem at 31457280. (generic.c line 272)
> > +/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101406208/2494464/4096) starts past end of filesystem at 31457280. (generic.c line 264)
> > +/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101406208/2494464/4096) ends past end of filesystem at 31457280. (generic.c line 272)
> > +/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101414400/2502656/4096) starts past end of filesystem at 31457280. (generic.c line 264)
> > +/mnt/testarea/scratch/test/68/S_IFREG.FMT_ETREE: extent (1101414400/2502656/4096) ends past end of filesystem at 31457280. (generic.c line 272)
> > 
> > Seems like scrub found something wrong (real problems) and became very
> > noisy?
> 
> Hmm that's even stranger.  I'll try to reproduce tomorrow.

So this ext4 noise came from the vanilla kernel too, retested with
djwong-devel kernel & userspace ext4/1300 passed without problems. Sorry
for my noise..

Thanks,
Eryu
