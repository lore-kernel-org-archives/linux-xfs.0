Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D45ED7F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 10:51:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CDFCAC003
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 08:51:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WBFYYrXtoZBkCBDm for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 08:51:47 -0700 (PDT)
Message-ID: <51E2C912.8080305@sandeen.net>
Date: Sun, 14 Jul 2013 10:51:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem triggering assert in _repair 3.1.11
References: <10640767.1356.1373750975524.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <10640767.1356.1373750975524.JavaMail.root@benjamin.baylink.com>
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
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On 7/13/13 4:29 PM, Jay Ashworth wrote:
...

> That's where I am right now: the drive was throwing a kernel oops if I 
> mounted it, 

That shouldn't happen, for starters - was this on the older 2.6.37 kernel?

> and xfs_repair would just lock up.  I had to do a -L on
> it

ok, so much for debugging the oops ...

> after which it would mount and unmount cleanly, and xfs_repair runs 
> and finds problems, but then fails an assert at the end and dies.
> 
> Here's that entire repair run:
> 
> =============================================================
> plaintain:/var/log/mythtv # xfs_repair /dev/sdc2
> Phase 1 - find and verify superblock...
> Not enough RAM available for repair to enable prefetching.

...

> entry "1011_20130509205900.mpg" at block 13 offset 4016 in directory inode 1073789184 references free inode 1137017084
>         clearing inode number in entry at offset 4016...
> bad back (left) sibling pointer (saw 16140901064495857663 should be NULL (0))
                                       ^^^ 0xDFFFFFFFFFFFFFFF i.e. -2

#define HOLESTARTBLOCK  ((xfs_fsblock_t)-2LL) ?

>         in inode 1115989006 (data fork) bmap btree block 107963248
> xfs_repair: dinode.c:2136: process_inode_data_fork: Assertion `err == 0' failed.

This means we were in the check_dups path, and one of the process_*() functions
failed.  Due to that "bad back (left) sibling pointer ..."

If I had time to work on this, I'd ask for an xfs_metadump image of
the filesystem to be able to reproduce it and look further into the problem...

It might shed some light on things to use xfs_db to look at inode 1115989006

# xfs_db /dev/sdc2
xfs_db> inode 1115989006
xfs_db> p

for starters.

looking at bmap btree block 107963248 might also be interesting; like this
I think but I'm rusty:

xfs_db> fsblock 107963248
xfs_db> type bmapbt
xfs_db> p

> Aborted
> =============================================================
> 
> This is xfs_repair 3.1.11, from xfsprogs 3.1.11 from tarball, compiled on
> the machine in question, which is a 32-bit OS with 512MB of ram (the
> mobo, an old MSI KT6V, pukes if we try to put more ram on it for some
> reason).  I have run memtest+ on the ram and multiple passes come
> back clean as a whistle; the SATA controller is a SiI 3114, which we
> had to buy to talk to the 3TB drives; boot is from the VT6420 on the
> motherboard and a dedicated 40G Samsung.
> 
> I have done some work on this repair booted from a Suse 12.1 rescue disk 
> with a 3.7 kernel, on the theory that the XFS drivers in the kernel
> might help; I found that mounting and unmounting in between multiple
> repair runs made me have to do less of them -- though I'm sure more
> than two dirty runs before one sees a clean one ought to be Right Out
> anyway.

Eek, so you thrashed about, in other words. ;)

> I've seen suggestions on the mailing list archives and other places
> that (some) assertion fails were for things fixed in earlier tools
> releases, but that one's not helping me...

well, not always true, esp. in userspace.

> I have space to move this data off and remake the filesystem,
> if I can get it to mount reliably and stay that way long enough.

you can always mount it & copy as much as possible until you hit
corruption.  But until repair succeeds you'll have corruption lurking
that you'll hit which will probably cause the fs to shut down (gracefully,
in theory).

-Eric

> Any assistance cheerfully appreciated.  :-)
> 
> Cheers,
> -- jra
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
