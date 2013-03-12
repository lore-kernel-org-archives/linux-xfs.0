Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 600EE7F55
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 15:27:41 -0500 (CDT)
Message-ID: <513F8FBD.4080805@sgi.com>
Date: Tue, 12 Mar 2013 15:27:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests #111 + XFS debug = infinite-loop oops
References: <CAJzLF9nAQvXCRoNqVw7jiTqmNugau_nK9KTT1ChsrwAv502gTA@mail.gmail.com>
In-Reply-To: <CAJzLF9nAQvXCRoNqVw7jiTqmNugau_nK9KTT1ChsrwAv502gTA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 03/12/13 13:46, Michael L. Semon wrote:
> Hi!  I was running xfstests #111 under the following conditions...
>
> (*) zeroed partitions, and
> (*) a fresh mkfs.xfs for each file system, and
>
> (1) CONFIG_XFS_DEBUG used, rtdev used, external logdev used, or
> (2) CONFIG_XFS_DEBUG used, external logdev used, or
> (3) CONFIG_XFS_DEBUG used, all internal, mkfs.xfs called with no options
>
> ...and I get a trace like the one below (from (3)).  The trace is from
> kernel 3.9.0-rc2 on an old Pentium III, using a normal VGA console on
> the test PC, captured by another PC over serial cable.  The trace is
> part of an infinite loop that becomes finite only if I rip out the
> console and VGA entirely.  Overall, more is in play here than just
> XFS, but I don't know to whom I should write.  [A relevant question
> for which I don't know the answer:  Are there critical sections where
> you should not use assertions or call BUG() in debug code?]  Something
> in XFS debug is fighting the console/VGA/framebuffer system, and I
> don't know where to go from here.
>
> You'll know you've reproduced this one because you'll need the power
> button to shut the PC off, so be careful.
>
> This is crash report; no fix is requested.  I'm using the simple
> workarounds "don't run xfstests #111 with XFS debugging enabled" and
> "Backups!  Backups!  Backups!"   All is well.
>
> Thanks!
>
> Michael
>
> [ 1399.347056] XFS (sda12): Corruption detected. Unmount and run xfs_repair
> [ 1399.353815] XFS (sda12): bad inode magic/vsn daddr 64 #8 (magic=5858)

0x58 == 'X'

> [ 1399.360277] XFS: Assertion failed: 0, file: fs/xfs/xfs_inode.c, line: 416


Thanks for the report, but there is no bug here. Maybe we should list 
test 111 as "dangerous".

xfstests 111 trashes the inode see xfstests/src/itrash.c:

void nuke()
{
	int i;
	for (i = 2048; i < 32768-1; i++)
		if (buffer[i] == 'I' && buffer[i+1] == 'N') {
			buffer[i] = buffer[i+1] = 'X';
			printf("Overwrote IN @offset %d\n", i);
		}
}

The inode verifiers are doing their job.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
