Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 85B957F50
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 11:14:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E44DAC002
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 09:14:29 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	6LXn9vVWjhR9b9yL for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 09:14:28 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 3C26F1F001DF
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 12:14:28 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 1WLguSPHC2RR for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 12:14:22 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id F3BAA1F003C3
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 12:14:21 -0400 (EDT)
Date: Sun, 14 Jul 2013 12:14:21 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <11307192.1374.1373818461931.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <51E2C912.8080305@sandeen.net>
Subject: Re: XFS filesystem triggering assert in _repair 3.1.11
MIME-Version: 1.0
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

----- Original Message -----
> From: "Eric Sandeen" <sandeen@sandeen.net>

> On 7/13/13 4:29 PM, Jay Ashworth wrote:
> ...
> 
> > That's where I am right now: the drive was throwing a kernel oops if
> > I mounted it,
> 
> That shouldn't happen, for starters - was this on the older 2.6.37
> kernel?

Correct.  It also threw btree errors on that kernel *and* the 3.7 liveCD, 
but never oopsed the 3.7.

> > and xfs_repair would just lock up. I had to do a -L on
> > it
> 
> ok, so much for debugging the oops ...

Yeah, sorry.  Thankfully, it's summer hiatus, but it is a production
box, which sometimes limits how long I can keep problems around before
brute forcing them.  I *have* the oops, but no longer the FS that caused
it.

> > after which it would mount and unmount cleanly, and xfs_repair runs
> > and finds problems, but then fails an assert at the end and dies.
> >
> > Here's that entire repair run:
> >
> > =============================================================
> > plaintain:/var/log/mythtv # xfs_repair /dev/sdc2
> > Phase 1 - find and verify superblock...
> > Not enough RAM available for repair to enable prefetching.
> 
> ...
> 
> > entry "1011_20130509205900.mpg" at block 13 offset 4016 in directory
> > inode 1073789184 references free inode 1137017084
> >         clearing inode number in entry at offset 4016...
> > bad back (left) sibling pointer (saw 16140901064495857663 should be
> > NULL (0))
> ^^^ 0xDFFFFFFFFFFFFFFF i.e. -2
> 
> #define HOLESTARTBLOCK ((xfs_fsblock_t)-2LL) ?
> 
> >         in inode 1115989006 (data fork) bmap btree block 107963248
> > xfs_repair: dinode.c:2136: process_inode_data_fork: Assertion `err
> > == 0' failed.
> 
> This means we were in the check_dups path, and one of the process_*()
> functions
> failed. Due to that "bad back (left) sibling pointer ..."
> 
> If I had time to work on this, I'd ask for an xfs_metadump image of
> the filesystem to be able to reproduce it and look further into the
> problem...
> 
> It might shed some light on things to use xfs_db to look at inode
> 1115989006
> 
> # xfs_db /dev/sdc2
> xfs_db> inode 1115989006
> xfs_db> p


xfs_db> inode 1115989006
xfs_db> p
core.magic = 0x494e
core.mode = 0100666
core.version = 2
core.format = 3 (btree)
core.nlinkv2 = 1
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 111
core.gid = 33
core.flushiter = 18
core.atime.sec = Wed Jul  3 19:28:22 2013
core.atime.nsec = 956870002
core.mtime.sec = Tue Jan 29 20:00:10 2013
core.mtime.nsec = 466912274
core.ctime.sec = Fri Jul 12 13:37:43 2013
core.ctime.nsec = 217838130
core.size = 916961916
core.nblocks = 223869
core.extsize = 0
core.nextents = 16
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 3501711335
next_unlinked = null
u.bmbt.level = 1
u.bmbt.numrecs = 1
u.bmbt.keys[1] = [startoff] 1:[0]
u.bmbt.ptrs[1] = 1:107963248

> looking at bmap btree block 107963248 might also be interesting; like
> this I think but I'm rusty:
> 
> xfs_db> fsblock 107963248
> xfs_db> type bmapbt

Well, the manpage says that's a type, but my xfs_db, v 3.1.11, says it's not.  Huh?

> xfs_db> p
> 
> > Aborted
> > =============================================================
> >
> > This is xfs_repair 3.1.11, from xfsprogs 3.1.11 from tarball,
> > compiled on
> > the machine in question, which is a 32-bit OS with 512MB of ram (the
> > mobo, an old MSI KT6V, pukes if we try to put more ram on it for
> > some
> > reason). I have run memtest+ on the ram and multiple passes come
> > back clean as a whistle; the SATA controller is a SiI 3114, which we
> > had to buy to talk to the 3TB drives; boot is from the VT6420 on the
> > motherboard and a dedicated 40G Samsung.
> >
> > I have done some work on this repair booted from a Suse 12.1 rescue
> > disk
> > with a 3.7 kernel, on the theory that the XFS drivers in the kernel
> > might help; I found that mounting and unmounting in between multiple
> > repair runs made me have to do less of them -- though I'm sure more
> > than two dirty runs before one sees a clean one ought to be Right
> > Out
> > anyway.
> 
> Eek, so you thrashed about, in other words. ;)

I've been at this over a week.  Yes, there's been some thrashing.  I have a
2TB that I need to dedupe and re-mkfs, so I have space to work on; that 
process itself is hanging against a *different* XFS problem on a different 
filesystem.  (Specifically, I have one bad inode on that FS that repair
doesn't seem to want to touch.  It's been lower priority cause that data's
duped, but as I need the free space more, its priority is rising.)

I hate power supplies.


> > I've seen suggestions on the mailing list archives and other places
> > that (some) assertion fails were for things fixed in earlier tools
> > releases, but that one's not helping me...
> 
> well, not always true, esp. in userspace.
> 
> > I have space to move this data off and remake the filesystem,
> > if I can get it to mount reliably and stay that way long enough.
> 
> you can always mount it & copy as much as possible until you hit
> corruption. But until repair succeeds you'll have corruption lurking
> that you'll hit which will probably cause the fs to shut down
> (gracefully, in theory).

Well, the bottom half shuts down, but then the top half keeps going, 
throwing error 5's all night.  

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
