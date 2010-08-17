Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7HH5C3A058871 for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 12:05:13 -0500
Received: from emh01.mail.saunalahti.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49577CCE98A
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 10:14:55 -0700 (PDT)
Received: from emh01.mail.saunalahti.fi (emh01.mail.saunalahti.fi
	[62.142.5.107]) by cuda.sgi.com with ESMTP id M27smDO8YGRgtbCW
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 10:14:55 -0700 (PDT)
From: Arto Jantunen <viiru@debian.org>
Subject: Re: Kernel BUG when running xfs_fsr with 2.6.35.1
References: <878w47yn36.fsf@viiru.iki.fi> <20100816220941.GK10429@dastard>
Date: Tue, 17 Aug 2010 20:05:35 +0300
In-Reply-To: <20100816220941.GK10429@dastard>
	(sfid-20100817_010956_232755_D2E8C8BA) (Dave Chinner's message
	of "Tue\, 17 Aug 2010 08\:09\:41 +1000")
Message-ID: <87zkwlxj8g.fsf@viiru.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--=-=-=

Dave Chinner <david@fromorbit.com> writes:
>> I had a kernel BUG yesterday when running xfs_fsr on my Debian Unstable
>> laptop. The kernel is upstream 2.6.35.1. I'm attaching the backtrace
>> below. I haven't tried reproducing the problem yet and don't know if it is
>> reproducible. I can try that, and test patches etc. if it is useful. Let me
>> know if there is any other information I can provide to help with debugging.
>
> It's not obvious what has gone wrong at all - I haven't seen
> anything like this in all my recent testing, so it's something new.
> The first oops implies the inode has not been joined to the
> transaction, but from code inspection I cannot see how that can
> happen.

I tried to reproduce the problem, and this time xfs_fsr finished without
reporting errors, but the kernel output the following two lines (one of which
is essentially empty):

[ 6372.878945] Filesystem "sda4": Access to block zero in inode 67203861
start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 2
[ 6372.878950]

I decided to boot from a usb stick and try xfs_repair -n, I have attached the
output of that. There were errors reported. Is this simply a case of random
(possibly hardware related) fs corruption, or were the errors actually caused
by the xfs_fsr run that crashed the system? Is there a way to tell from this
data, is there anything else I can provide?

-- 
Arto Jantunen


--=-=-=
Content-Disposition: inline; filename=xfsrep
Content-Description: xfs_repair -n

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
error following ag 0 unlinked list
error following ag 2 unlinked list
error following ag 3 unlinked list
        - process known inodes and perform inode discovery...
        - agno = 0
b766fb90: Badness in key lookup (length)
bp=(bno 208, len 16384 bytes) key=(bno 208, len 8192 bytes)
b766fb90: Badness in key lookup (length)
bp=(bno 720, len 16384 bytes) key=(bno 720, len 8192 bytes)
b766fb90: Badness in key lookup (length)
bp=(bno 752, len 16384 bytes) key=(bno 752, len 8192 bytes)
b766fb90: Badness in key lookup (length)
bp=(bno 14224, len 16384 bytes) key=(bno 14224, len 8192 bytes)
b766fb90: Badness in key lookup (length)
bp=(bno 15440, len 16384 bytes) key=(bno 15440, len 8192 bytes)
b766fb90: Badness in key lookup (length)
bp=(bno 127952, len 16384 bytes) key=(bno 127952, len 8192 bytes)
b766fb90: Badness in key lookup (length)
bp=(bno 178096, len 16384 bytes) key=(bno 178096, len 8192 bytes)
b766fb90: Badness in key lookup (length)
bp=(bno 282256, len 16384 bytes) key=(bno 282256, len 8192 bytes)
b766fb90: Badness in key lookup (length)
bp=(bno 283888, len 16384 bytes) key=(bno 283888, len 8192 bytes)
b766fb90: Badness in key lookup (length)
bp=(bno 380176, len 16384 bytes) key=(bno 380176, len 8192 bytes)
        - agno = 1
b6e6fb90: Badness in key lookup (length)
bp=(bno 29853904, len 16384 bytes) key=(bno 29853904, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 29854000, len 16384 bytes) key=(bno 29854000, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 29854032, len 16384 bytes) key=(bno 29854032, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 29854320, len 16384 bytes) key=(bno 29854320, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 29855120, len 16384 bytes) key=(bno 29855120, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 29855632, len 16384 bytes) key=(bno 29855632, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 29860912, len 16384 bytes) key=(bno 29860912, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 29861328, len 16384 bytes) key=(bno 29861328, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 29865328, len 16384 bytes) key=(bno 29865328, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 30082480, len 16384 bytes) key=(bno 30082480, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 30153392, len 16384 bytes) key=(bno 30153392, len 8192 bytes)
b6e6fb90: Badness in key lookup (length)
bp=(bno 30156400, len 16384 bytes) key=(bno 30156400, len 8192 bytes)
        - agno = 2
b4cecb90: Badness in key lookup (length)
bp=(bno 44738944, len 16384 bytes) key=(bno 44738944, len 8192 bytes)
b4cecb90: Badness in key lookup (length)
bp=(bno 44756544, len 16384 bytes) key=(bno 44756544, len 8192 bytes)
b4cecb90: Badness in key lookup (length)
bp=(bno 44910976, len 16384 bytes) key=(bno 44910976, len 8192 bytes)
b4cecb90: Badness in key lookup (length)
bp=(bno 44917376, len 16384 bytes) key=(bno 44917376, len 8192 bytes)
b4cecb90: Badness in key lookup (length)
bp=(bno 44991680, len 16384 bytes) key=(bno 44991680, len 8192 bytes)
b4cecb90: Badness in key lookup (length)
bp=(bno 45189120, len 16384 bytes) key=(bno 45189120, len 8192 bytes)
b4cecb90: Badness in key lookup (length)
bp=(bno 45241856, len 16384 bytes) key=(bno 45241856, len 8192 bytes)
        - agno = 3
        - agno = 4
        - agno = 5
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 475, would move to lost+found
disconnected inode 1457, would move to lost+found
disconnected inode 1462, would move to lost+found
disconnected inode 1515, would move to lost+found
disconnected inode 1527, would move to lost+found
disconnected inode 12936, would move to lost+found
disconnected inode 28462, would move to lost+found
disconnected inode 28486, would move to lost+found
disconnected inode 30897, would move to lost+found
disconnected inode 30900, would move to lost+found
disconnected inode 255910, would move to lost+found
disconnected inode 356253, would move to lost+found
disconnected inode 564550, would move to lost+found
disconnected inode 564552, would move to lost+found
disconnected inode 564558, would move to lost+found
disconnected inode 564560, would move to lost+found
disconnected inode 567818, would move to lost+found
disconnected inode 760356, would move to lost+found
disconnected inode 67167339, would move to lost+found
disconnected inode 67167345, would move to lost+found
disconnected inode 67167367, would move to lost+found
disconnected inode 67167377, would move to lost+found
disconnected inode 67167381, would move to lost+found
disconnected inode 67167523, would move to lost+found
disconnected inode 67167530, would move to lost+found
disconnected inode 67167540, would move to lost+found
disconnected inode 67167567, would move to lost+found
disconnected inode 67167589, would move to lost+found
disconnected inode 67167590, would move to lost+found
disconnected inode 67167611, would move to lost+found
disconnected inode 67167995, would move to lost+found
disconnected inode 67168188, would move to lost+found
disconnected inode 67168199, would move to lost+found
disconnected inode 67169785, would move to lost+found
disconnected inode 67169805, would move to lost+found
disconnected inode 67170769, would move to lost+found
disconnected inode 67170784, would move to lost+found
disconnected inode 67181371, would move to lost+found
disconnected inode 67181372, would move to lost+found
disconnected inode 67181399, would move to lost+found
disconnected inode 67182212, would move to lost+found
disconnected inode 67190216, would move to lost+found
disconnected inode 67624500, would move to lost+found
disconnected inode 67766334, would move to lost+found
disconnected inode 67772371, would move to lost+found
disconnected inode 100667199, would move to lost+found
disconnected inode 100702371, would move to lost+found
disconnected inode 101011291, would move to lost+found
disconnected inode 101024061, would move to lost+found
disconnected inode 101026567, would move to lost+found
disconnected inode 101172659, would move to lost+found
disconnected inode 101567559, would move to lost+found
disconnected inode 101567560, would move to lost+found
disconnected inode 101567561, would move to lost+found
disconnected inode 101567563, would move to lost+found
disconnected inode 101673003, would move to lost+found
disconnected inode 101673004, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 475 nlinks from 0 to 1
would have reset inode 1457 nlinks from 0 to 1
would have reset inode 1462 nlinks from 0 to 1
would have reset inode 1515 nlinks from 0 to 1
would have reset inode 1527 nlinks from 0 to 1
would have reset inode 12936 nlinks from 0 to 1
would have reset inode 28462 nlinks from 0 to 1
would have reset inode 28486 nlinks from 0 to 1
would have reset inode 30897 nlinks from 0 to 1
would have reset inode 30900 nlinks from 0 to 1
would have reset inode 255910 nlinks from 0 to 1
would have reset inode 356253 nlinks from 0 to 1
would have reset inode 564550 nlinks from 0 to 1
would have reset inode 564552 nlinks from 0 to 1
would have reset inode 564558 nlinks from 0 to 1
would have reset inode 564560 nlinks from 0 to 1
would have reset inode 567818 nlinks from 0 to 1
would have reset inode 760356 nlinks from 0 to 1
would have reset inode 67167339 nlinks from 0 to 1
would have reset inode 67167345 nlinks from 0 to 1
would have reset inode 67167367 nlinks from 0 to 1
would have reset inode 67167377 nlinks from 0 to 1
would have reset inode 67167381 nlinks from 0 to 1
would have reset inode 67167523 nlinks from 0 to 1
would have reset inode 67167530 nlinks from 0 to 1
would have reset inode 67167540 nlinks from 0 to 1
would have reset inode 67167567 nlinks from 0 to 1
would have reset inode 67167589 nlinks from 0 to 1
would have reset inode 67167590 nlinks from 0 to 1
would have reset inode 67167611 nlinks from 0 to 1
would have reset inode 67167995 nlinks from 0 to 1
would have reset inode 67168188 nlinks from 0 to 1
would have reset inode 67168199 nlinks from 0 to 1
would have reset inode 67169785 nlinks from 0 to 1
would have reset inode 67169805 nlinks from 0 to 1
would have reset inode 67170769 nlinks from 0 to 1
would have reset inode 67170784 nlinks from 0 to 1
would have reset inode 67181371 nlinks from 0 to 1
would have reset inode 67181372 nlinks from 0 to 1
would have reset inode 67181399 nlinks from 0 to 1
would have reset inode 67182212 nlinks from 0 to 1
would have reset inode 67190216 nlinks from 0 to 1
would have reset inode 67624500 nlinks from 0 to 1
would have reset inode 67766334 nlinks from 0 to 1
would have reset inode 67772371 nlinks from 0 to 1
would have reset inode 100667199 nlinks from 0 to 1
would have reset inode 100702371 nlinks from 0 to 1
would have reset inode 101011291 nlinks from 0 to 1
would have reset inode 101024061 nlinks from 0 to 1
would have reset inode 101026567 nlinks from 0 to 1
would have reset inode 101172659 nlinks from 0 to 1
would have reset inode 101567559 nlinks from 0 to 1
would have reset inode 101567560 nlinks from 0 to 1
would have reset inode 101567561 nlinks from 0 to 1
would have reset inode 101567563 nlinks from 0 to 1
would have reset inode 101673003 nlinks from 0 to 1
would have reset inode 101673004 nlinks from 0 to 1
No modify flag set, skipping filesystem flush and exiting.

--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-=-=--
