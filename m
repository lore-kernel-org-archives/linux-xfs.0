Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4I4JH9F027289 for <xfs@oss.sgi.com>; Mon, 17 May 2010 23:19:18 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D1B713F6816
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 21:21:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	UbKxcwA1GCyUT5kW for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 21:21:34 -0700 (PDT)
Date: Tue, 18 May 2010 14:21:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mounting hixfs (Hitachi "tuned" XFS) on 2.6 kernel
Message-ID: <20100518042130.GC2150@dastard>
References: <AANLkTikek9K8-BqNgee_tXz72beHpWEUl41YtDPrD-3P@mail.gmail.com>
	<4BF1EC44.7070803@hardwarefreak.com>
	<AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>
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
To: big beer <bigbeerjr@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 17, 2010 at 08:34:14PM -0700, big beer wrote:
> >On Mon, May 17, 2010 at 6:24 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> > big beer put forth on 5/17/2010 7:08 PM:
> >
> >> If anyone has any ideas on what to do, and/or where to start, I'd
> >> greatly appreciate it.
> >
> > Why are you avoiding the obvious solution in favor of hacking?
> 
> The obvious solution for me would be a backup or rsync. Unfortunately
> both of those have issues with this particular setup.
> 
> Using a backup over the network to migrate will be way too slow
> (days). There are way too many files to index and this poor little nas
> box is already falling over with cpu load from daily activities. I can
> quickly make a mirror on the storage, and move it over to another
> larger host quickly (minutes). Mounting the FS on another machine will
> greatly improve the time and accuracy, as I won't have to worry about
> inconsistencies as it's a block level copy.
> 
> The black-box solution is also very painful to work with, no gcc, no
> automake, no rsync, etc.
> I would also think that for some reason I can't think of, it would be
> nice to have support for this version of XFS be available for free for
> others. Some other poor sap might find some value.
> 
> So I went and changed the magic number to 0x58465342 by dumping the
> 1st 512 bytes off the volume, editing, and writing back, now I'm
> getting "Can't verify primary superblock". Using xfs_db to look at the
> other superblocks indeed still shows HXFS. Any advise how I can
> find/dump/re-write one of the other superblocks? I'd like to see if I
> can change another one of them if xfs_repair will run.

There's no guarantee that mainline tools will work on this
filesystem. As a matter of principle, I'd be asking Hitachi for the
source code to their kernel module and userland tools and they are
required by the GPL to do supply it on request. If we have the
source code then any hidden surprises (i.e more than superblock
magic number changes) can be dealt with

Start by running 'xfs_check -F <dev>' on an unmodified image of the
filesystem. This will ignore bad superblock magic numbers. If this
does not find any significant problems or stuff it doesn't
understand, then it _might_ be safe to modify each secondary
superblock and run a modern xfs_repair on.

If you get this far modify the secondary superblocks by finding the
disk address of each superblock with xfs_db:

# for i in `seq 0 1 3`; do sudo xfs_db -x -c "sb $i" -c daddr /dev/vda; done
current daddr is 0
current daddr is 2097152
current daddr is 4194304
current daddr is 6291456
#

Just replace the "seq 0 1 3" with "seq 0 1 <number of AGs - 1>" to
suite your filesystem and "/dev/vda" with your block device.

And they can then be read via:

# dd if=/dev/vda of=sb_1.img bs=512 skip=2097152 count=1

modified, and then written by

# dd of=/dev/vda if=sb_1.img bs=512 seek=2097152 count=1

[ /me still wonders WTF the dd maintainers were thinking when they
removed iseek/oseek in favour of skip/seek - I use it these all the
time and I still have to look up the man page every time to make
sure I'm seeking on the correct stream... ]

Assuming everything is OK at this point, run 'xfs_repair -n <dev>'
first (no modify mode), and if it doesn't report anything
uncorrectable, then run without the '-n'.

Good luck!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
