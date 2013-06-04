Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54DC87CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 23:16:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F7098F8033
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 21:16:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AsdazXjixNW8tz8u for <xfs@oss.sgi.com>;
	Mon, 03 Jun 2013 21:16:21 -0700 (PDT)
Date: Tue, 4 Jun 2013 14:16:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.4 Oops running xfstests (WAS Re: 3.9.3: Oops running xfstests)
Message-ID: <20130604041617.GF29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1588848128.8530921.1369885528565.JavaMail.root@redhat.com>
	<20130530052049.GK29466@dastard>
	<1824023060.8558101.1369892432333.JavaMail.root@redhat.com>
	<1462663454.9294499.1369969415681.JavaMail.root@redhat.com>
	<20130531060415.GU29466@dastard>
	<1517224799.10311874.1370228651422.JavaMail.root@redhat.com>
	<20130603040038.GX29466@dastard>
	<1317567060.11044929.1370315696270.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317567060.11044929.1370315696270.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 03, 2013 at 11:14:56PM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: xfs@oss.sgi.com, stable@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>
> > Sent: Monday, June 3, 2013 12:00:38 PM
> > Subject: Re: 3.9.4 Oops running xfstests (WAS Re: 3.9.3: Oops running xfstests)
> > 
> > On Sun, Jun 02, 2013 at 11:04:11PM -0400, CAI Qian wrote:
> > > 
> > > > There's memory corruption all over the place.  It is most likely
> > > > that trinity is causing this - it's purpose is to trigger corruption
> > > > issues, but they aren't always immediately seen.  If you can trigger
> > > > this xfs trace without trinity having been run and without all the
> > > > RCU/idle/scheduler/cgroup issues occuring at the same time, then
> > > > it's likely to be caused by XFS. But right now, I'd say XFS is just
> > > > an innocent bystander caught in the crossfire. There's nothing I can
> > > > do from an XFS persepctive to track this down...
> > > OK, this can be reproduced by just running LTP and then xfstests without
> > > trinity at all...
> > 
> > Cai, can you be more precise about what is triggering it?  LTP and
> > xfstests do a large amount of stuff, and stack traces do not do not
> > help narrow down the cause at all.  Can you provide the follwoing
> > information and perform the follwoing steps:
> > 
> > 	1. What xfstest is tripping over it?
> Test #20.
> > 	2. Can you reproduce it just by running that one specific test
> > 	  on a pristine system (i.e. freshly mkfs'd filesystems,
> > 	  immediately after boot)
> Yes, it was reproduced without LTP at all.
> [   98.534402] XFS (dm-0): Mounting Filesystem
> [   98.586673] XFS (dm-0): Ending clean mount
> [   99.741704] XFS (dm-2): Mounting Filesystem
> [  100.117248] XFS (dm-2): Ending clean mount
> [  100.723228] XFS (dm-0): Mounting Filesystem
> [  100.775965] XFS (dm-0): Ending clean mount
> [  101.980250] BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
> [  101.988136] IP: [<ffffffff81098cac>] tg_load_down+0x4c/0x80

first bug, in scheduler

> [  102.312714] BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
> [  102.312719] IP: [<ffffffff81098cac>] tg_load_down+0x4c/0x80

second bug, in scheduler

> [  102.312842] ---[ end trace ba964230a74993ff ]---
> [  102.312866] general protection fault: 0000 [#3] SMP 

Third bug

> [  102.312903] Pid: 1999, comm: attr Tainted: G      D      3.9.4 #1 Hewlett-Packard HP Z210 Workstation/1587h
> [  102.312908] RIP: 0010:[<ffffffff810983a9>]  [<ffffffff810983a9>] irqtime_account_process_tick.isra.2+0x239/0x3c0

In the timer tick code.

> [  102.312909] =============================================================================
> [  102.312910] RSP: 0018:ffff88007d083e08  EFLAGS: 00010003
> [  102.312912] BUG kmalloc-1024 (Tainted: G      D     ): Padding overwritten. 0xffff88005b4e7ec0-0xffff88005b4e7fff
> [  102.312913] RAX: ffff88005b656288 RBX: ffff880079b43c80 RCX: 00000000000000a7
> [  102.312914] -----------------------------------------------------------------------------

And a memory overwrite.

> [  102.313009] Padding ffff88005b4e7ec0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  102.313010] Padding ffff88005b4e7ed0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  102.313011] Padding ffff88005b4e7ee0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  102.313013] Padding ffff88005b4e7ef0: 00 00 00 00 00 00 00 00 00 00 00 00 00 29 01 00  .............)..
> [  102.313014] Padding ffff88005b4e7f00: 07 1b 04 73 65 6c 69 6e 75 78 73 79 73 74 65 6d  ...selinuxsystem
> [  102.313015] Padding ffff88005b4e7f10: 5f 75 3a 6f 62 6a 65 63 74 5f 72 3a 75 73 72 5f  _u:object_r:usr_
> [  102.313032] Padding ffff88005b4e7f20: 74 3a 73 30 00 00 00 00 49 4e 81 a4 02 02 00 00  t:s0....IN......
> [  102.313033] Padding ffff88005b4e7f30: 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00  ................
> [  102.313033] Padding ffff88005b4e7f40: 00 00 00 00 00 00 00 02 51 47 09 00 00 00 00 00  ........QG......
> [  102.313043] Padding ffff88005b4e7f50: 51 47 09 00 00 00 00 00 51 ac 1e 27 21 f1 4e ad  QG......Q..'!.N.
> [  102.313043] Padding ffff88005b4e7f60: 00 00 00 00 00 00 00 f2 00 00 00 00 00 00 00 01  ................
> [  102.313044] Padding ffff88005b4e7f70: 00 00 00 00 00 00 00 01 00 00 0e 01 00 00 00 00  ................
> [  102.313053] Padding ffff88005b4e7f80: 00 00 00 00 c1 6d 78 44 ff ff ff ff 00 00 00 00  .....mxD........
> [  102.313054] Padding ffff88005b4e7f90: 00 00 00 00 00 00 08 10 36 a0 00 01 00 00 00 00  ........6.......
> [  102.313062] Padding ffff88005b4e7fa0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  102.313063] Padding ffff88005b4e7fb0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  102.313072] Padding ffff88005b4e7fc0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  102.313073] Padding ffff88005b4e7fd0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  102.313074] Padding ffff88005b4e7fe0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  102.313082] Padding ffff88005b4e7ff0: 00 00 00 00 00 00 00 00 00 00 00 00 00 29 01 00  .............)..

Oh, look, that contains attributes, and being at the top of a page,
that tallies with the attribute code copying data from the top of
the block down....


> [  102.313013]  [<ffffffff813022f6>] ? memmove+0x46/0x1a0
> [  102.313032]  [<ffffffffa02801a1>] ? xfs_attr_leaf_moveents.isra.2+0x91/0x280 [xfs]
> [  102.313042]  [<ffffffffa0280467>] xfs_attr_leaf_compact+0xd7/0x130 [xfs]

And the attribute code is writing into a block sized buffer that is
allocated in xfs_attr_leaf_compact().

So, whatever page got handed to xfs_attr_leaf_compact() is actually
referenced by the 1024 byte and supposed to be free. So, did XFS ask
for a 1k block, or something else?

Cai, I did ask you for the information that would have answered this
question:

> > 	3. if you can't reproduce it like that, does it reproduce on
> > 	  an xfstest run on a pristine system? If so, what command
> > 	  line are you running, and what are the filesystem
> > 	  configurations?

So, I need xfstests command line and the xfs_info output from the
filesystems in use at the time this problem occurs..

That said, this still looks like something has corrupted the heap
and XFS is just tripping over it....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
