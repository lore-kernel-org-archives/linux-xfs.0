Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7MAR1JT243258 for <xfs@oss.sgi.com>; Sat, 22 Aug 2009 05:27:11 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 267C23EDD12
	for <xfs@oss.sgi.com>; Sat, 22 Aug 2009 03:27:30 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 3PEzIQCKICgeWw2g for
	<xfs@oss.sgi.com>; Sat, 22 Aug 2009 03:27:30 -0700 (PDT)
Date: Sat, 22 Aug 2009 06:27:30 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <alpine.DEB.2.00.0908171024380.12533@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0908220624440.30321@p34.internal.lan>
References: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan>
	<00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com>
	<alpine.DEB.2.00.0908090605080.16485@p34.internal.lan>
	<alpine.DEB.2.00.0908110624420.22426@p34.internal.lan>
	<20090816022331.GA2309@infradead.org>
	<alpine.DEB.2.00.0908171024380.12533@p34.internal.lan>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Mon, 17 Aug 2009, Justin Piszcz wrote:

>
>
> On Sat, 15 Aug 2009, Christoph Hellwig wrote:
>

On this system, I am running loop-aes, could that be the culprit?  On all 
other systems not using loop-aes with 2.6.30.x, I do not see this issue.

Kernel: 2.6.29.1 is unaffected.

Kernel 2.6.30.4 - 2.6.31-rc6-1 are affected

sysrq-t:

[144104.513619] grep          D 80000000     0 21201  21171 0x00000000
[144104.513619]  00000000 00000086 c0cfb200 80000000 00000000 c4b80700 00000000 cf2bd800
[144104.513619]  ce4d21a0 ce6270a0 00000000 cf2bd800 c1170ad4 00000002 01000000 c0723dc4
[144104.513619]  000000d4 c1b4fba4 ce6270e8 00000001 c0cfb200 c101a960 c072dc2c c04edd48
[144104.513619] Call Trace:
[144104.513619]  [<c1170ad4>] ? xlog_state_get_iclog_space+0x74/0x220
[144104.513619]  [<c101a960>] ? default_wake_function+0x0/0x10
[144104.513619]  [<c1170db8>] ? xlog_write+0x138/0x5f0
[144104.513619]  [<c1171417>] ? xfs_log_write+0x47/0xa0
[144104.513619]  [<c117e0d9>] ? _xfs_trans_commit+0x179/0x3b0
[144104.513619]  [<c1180aea>] ? xfs_trans_log_inode+0x7a/0xc0
[144104.513619]  [<c1164bf6>] ? xfs_itruncate_finish+0x556/0x680
[144104.513619]  [<c1184b83>] ? xfs_free_eofblocks+0x303/0x310
[144104.513619]  [<c118c43a>] ? xfs_file_release+0xa/0x10
[144104.513619]  [<c10658fa>] ? __fput+0xca/0x1c0
[144104.513619]  [<c10628c7>] ? filp_close+0x47/0x80
[144104.513619]  [<c1065361>] ? sys_read+0x41/0x80
[144104.513619]  [<c106296c>] ? sys_close+0x6c/0xa0
[144104.513619]  [<c1002b88>] ? sysenter_do_call+0x12/0x26

sysrq-w:

[144122.352339] grep          D 00000000     0 22392  22362 0x00000000
[144122.352339]  00000000 00000082 c0776760 00000000 00000000 c19d4040 cf58d0d4 00000000
[144122.352339]  c5c42534 c5c42534 c0785e3c c0785f5c c130133d c5c42538 c0776760 c0785e7c
[144122.352339]  c5c42534 c5c424c0 00000001 c0785f5c c130147a c5c42538 c077be3c c0776760
[144122.352339] Call Trace:
[144122.352339]  [<c130133d>] ? rwsem_down_failed_common+0x7d/0x170
[144122.352339]  [<c130147a>] ? rwsem_down_read_failed+0x1a/0x24
[144122.352339]  [<c130148b>] ? call_rwsem_down_read_failed+0x7/0xc
[144122.352339]  [<c1300c79>] ? down_read+0x9/0x10
[144122.352339]  [<c1160df0>] ? xfs_ilock+0x90/0xc0
[144122.352339]  [<c118fc14>] ? xfs_read+0x104/0x260
[144122.352339]  [<c118c652>] ? xfs_file_aio_read+0x62/0x70
[144122.352339]  [<c1064595>] ? do_sync_read+0xd5/0x120
[144122.352339]  [<c1047117>] ? __alloc_pages_nodemask+0xd7/0x530
[144122.352339]  [<c102d930>] ? autoremove_wake_function+0x0/0x50
[144122.352339]  [<c105a786>] ? page_add_new_anon_rmap+0x56/0x80
[144122.352339]  [<c1054156>] ? handle_mm_fault+0x416/0x510
[144122.352339]  [<c10644c0>] ? do_sync_read+0x0/0x120
[144122.352339]  [<c10651cd>] ? vfs_read+0x9d/0x160
[144122.352339]  [<c1065361>] ? sys_read+0x41/0x80
[144122.352339]  [<c1002b88>] ? sysenter_do_call+0x12/0x26

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
