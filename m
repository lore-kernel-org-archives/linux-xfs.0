Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59628 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757142AbdEKQjI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 12:39:08 -0400
Subject: Re: permanent XFS volume corruption
References: <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <591493D00200007800158EA3@prv-mh.provo.novell.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a185194a-af56-cd53-cfb9-653e3b5f81b7@sandeen.net>
Date: Thu, 11 May 2017 11:39:01 -0500
MIME-Version: 1.0
In-Reply-To: <591493D00200007800158EA3@prv-mh.provo.novell.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Beulich <JBeulich@suse.com>, linux-xfs@vger.kernel.org

On 5/11/17 9:39 AM, Jan Beulich wrote:
> Hello,
> 
> It is now on two systems that I'm getting
> 
> XFS (sda1): corrupt dinode 576254627, has realtime flag set.
> ffff88042ea63300: 49 4e 81 a4 02 02 00 00 00 00 03 e8 00 00 00 64  IN.............d
> ffff88042ea63310: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> ffff88042ea63320: 59 14 0e 9f 0f a7 7c 2f 59 14 0e 9f 18 f3 db 2f  Y.....|/Y....../
> ffff88042ea63330: 59 14 0e 9f 18 f3 db 2f 00 00 00 00 00 00 80 80  Y....../........

...

> XFS (sda1): Corruption detected. Unmount and run xfs_repair
> 
> after a crash with a 4.11-based kernel. I didn't try xfs_repair-ing
> the volume in this second instance, as the result from doing so in
> the first instance was only permanent re-occurrence (and
> apparently spreading) of the problem. It may be interesting that
> xfs_check finds only this one corrupted inode, while the kernel
> also finds at least one more:
> 
> XFS (sda1): corrupt dinode 104812066, has realtime flag set.
> ffff88042e88f200: 49 4e 41 ed 02 01 00 00 00 00 03 e8 00 00 00 64  INA............d
> ffff88042e88f210: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00  ................
> ffff88042e88f220: 59 01 c7 96 00 16 1e 50 59 14 0e a2 15 60 54 2f  Y......PY....`T/
> ffff88042e88f230: 59 14 0e a2 15 60 54 2f 00 00 00 00 00 00 00 8e  Y....`T/........
> XFS (sda1): Internal error xfs_iformat(realtime) at line 133 of file .../fs/xfs/xfs_inode_fork.c.  Caller xfs_iread+0xea/0x2e0 [xfs]
> 
> The kernel used after the crash doesn't appear to matter, all report
> the same issues, but I've experienced similar crashes in the past
> without ever having seen such corruption before.
> 
> In any event I think there are two problems: The corruption itself
> (possibly an issue with recent enough upstream kernels only) and
> the fact that running xfs_repair doesn't help in these cases.

FWIW, recent xfs_repair (v4.11.0) finds several bad inodes on the
sdb8 metadump you sent, and apparently fixes* them without problems.

inode 764 has RT flag set but there is no RT device
directory flags set on non-directory inode 764
inode 2068 has RT flag set but there is no RT device
directory flags set on non-directory inode 2068
inode 268448674 has RT flag set but there is no RT device
directory flags set on non-directory inode 268448674

these are:

764: lib/xenstored/tdb
2068: log/messages
268448674: lib/sudo/jbeulich/0

and after repair, I can read all the inodes on the device w/o
further errors (upstream linus kernel)

As for the original corruption problem, I'm not sure.

*Each of the 3 problematic inodes has an odd assortment of flags
set (think chattr type flags) - some have immutable, some have
noatime, some have nodump, etc.  These are what cause xfs_repair
t ocomplain.  It seems unlikely that any of these were actually set
on your filesystem, as these are the only ones with any flags set.
After repair, they're showing:

--S---dA----------- mnt/log/messages
--S-i--A----------- mnt/lib/sudo/jbeulich/0
--S----A----------- mnt/lib/xenstored/tdb

Did you happen to set chattr flags on these files intentionally?

Two if the problematic inodes also have a generation number
of 0, which also seems a bit odd.

-Eric

> I'm
> attaching xfs_check and xfs_metadump warning output for both
> affected volumes in this second instance. The full files
> xfs_metadump -agow produced can be provided upon request
> (500Mb and 80Mb uncompressed respectively).
> 
> Thanks for any advice / fix,
> Jan
> 
