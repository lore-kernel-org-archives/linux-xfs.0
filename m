Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 443A929DF7
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 20:12:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2331B304032
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 18:12:18 -0800 (PST)
Received: from nihxway6out.hub.nih.gov (nihxway6out.hub.nih.gov
	[128.231.90.114]) by cuda.sgi.com with ESMTP id
	qD5LFvM5QnQVf0fd for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2014 18:12:16 -0800 (PST)
From: "Weber, Charles (NIH/NIA/IRP) [E]" <WeberC@grc.nia.nih.gov>
Subject: RE: weird quota issue
Date: Tue, 23 Dec 2014 02:12:15 +0000
Message-ID: <258BE536A650F646814BA46CC06568980F6A8AD7@msgb01.nih.gov>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<20141222204857.GK24183@dastard>
	<6F43BF63-A44E-43F6-A184-9AAC10DDDFDF@grc.nia.nih.gov>
	<20141222223540.GS15665@dastard>
	<2F3F57BB-59EA-4FF9-9254-6A598DE7AC46@grc.nia.nih.gov>,
	<20141223003237.GA4521@dastard>
In-Reply-To: <20141223003237.GA4521@dastard>
Content-Language: en-US
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

here you go

# xfs_db -c "inode 131" -c p /dev/dm-7
core.magic = 0x494e
core.mode = 0100000
core.version = 2
core.format = 3 (btree)
core.nlinkv2 = 1
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 0
core.gid = 0
core.flushiter = 4
core.atime.sec = Mon Dec  8 14:55:46 2014
core.atime.nsec = 555792066
core.mtime.sec = Mon Dec  8 14:55:46 2014
core.mtime.nsec = 555792066
core.ctime.sec = Mon Dec  8 14:55:46 2014
core.ctime.nsec = 555792066
core.size = 0
core.nblocks = 283
core.extsize = 0
core.nextents = 252
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
core.gen = 0
next_unlinked = null
u.bmbt.level = 1
u.bmbt.numrecs = 1
u.bmbt.keys[1] = [startoff] 1:[0]
u.bmbt.ptrs[1] = 1:2819


Charles Weber
NIA IRP NCTS
410-558-8001

________________________________________
From: Dave Chinner [david@fromorbit.com]
Sent: Monday, December 22, 2014 7:32 PM
To: Weber, Charles (NIH/NIA/IRP) [E]
Cc: xfs@oss.sgi.com
Subject: Re: weird quota issue

On Mon, Dec 22, 2014 at 05:46:42PM -0500, Weber, Charles (NIH/NIA/IRP) [C] wrote:
> I wonder if it is a thin-provision issue? ~40TB allocated by the SAN but setup to not really allocate space until it is claimed by the OS.
>
>  xfs_db -c "sb 0" -c p /dev/dm-7
>
....
> versionnum = 0xb5e4

So the quota bit is set (0x40) hence quotas will attempt to be
enabled.

> uquotino = 131
> gquotino = 0
> qflags = 0

But we have no quota enabled but a user quota inode allocated.
the quota flags would have been written to zero by the initial
failure, so this implies that reading the  user quota inode failed.
Output of 'xfs_db -c "inode 131" -c p /dev/dm-7', please?

-Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
