Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7EB0D7F5A
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 09:17:38 -0500 (CDT)
Message-ID: <52404D7F.1080308@sgi.com>
Date: Mon, 23 Sep 2013 09:17:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: lookaside cache for xfs_buf_find
References: <1378690396-15792-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1378690396-15792-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/08/13 20:33, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> CPU overhead of buffer lookups dominate most metadata intensive
> workloads. The thing is, most such workloads are hitting a
> relatively small number of buffers repeatedly, and so caching
> recently hit buffers is a good idea.
>
...

I think this needs more testing.

I get the following panic in a loop test after a few (3-8) iterations:

  while true
   do
    tar zxpf xfs.tar
    cd xfs
    make
    make modules
    cd ..
    rm -r xfs
  done


BUG: unable to handle kernel paging request at ffff880831c1d218
IP: [<ffffffffa01886c8>] _xfs_buf_find_lookaside+0x98/0xb0 [xfs]
PGD 1c5d067 PUD 85ffe0067 PMD 85fe51067 PTE 8000000831c1d060
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: xfs(O) e1000e exportfs libcrc32c ext3 jbd [last 
unloaded: xfs
]
CPU: 0 PID: 23423 Comm: tar Tainted: G           O 3.11.0-rc1+ #3
task: ffff880837f087a0 ti: ffff880831c46000 task.ti: ffff880831c46000
RIP: 0010:[<ffffffffa01886c8>]  [<ffffffffa01886c8>] 
_xfs_buf_find_lookaside+0x9
8/0xb0 [xfs]
RSP: 0018:ffff880831c47918  EFLAGS: 00010286
RAX: ffff880831c1d200 RBX: ffff8808372e0000 RCX: 0000000000000003
  RDX: 0000000000000011 RSI: 00000000000009c0 RDI: ffff8808372e0000
  RBP: ffff880831c47938 R08: ffff8808372e0000 R09: ffff8808376e8d80
  R10: 0000000000000010 R11: 00000000000009c0 R12: 00000000000009c0
  R13: 0000000000000010 R14: 0000000000000001 R15: 00000000000009c0
  FS:  00007fa4bc51f700(0000) GS:ffff88085bc00000(0000) 
knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff880831c1d218 CR3: 000000082ed00000 CR4: 00000000000007f0
  Stack:
   ffff880831c47938 ffff880831c47aa8 0000000000000010 ffff880834ab7900
   ffff880831c479b8 ffffffffa018a679 ffff8808372e00c0 ffff88082eed01a0
   0000000000000029 ffff8808372e01f0 0000000000000000 000200015bfe1c68
  Call Trace:
   [<ffffffffa018a679>] _xfs_buf_find+0x159/0x520 [xfs]
   [<ffffffffa018aea0>] xfs_buf_get_map+0x30/0x130 [xfs]
   [<ffffffffa018afc6>] xfs_buf_read_map+0x26/0xa0 [xfs]
   [<ffffffffa01fbf5d>] xfs_trans_read_buf_map+0x16d/0x4c0 [xfs]
   [<ffffffffa01e784c>] xfs_imap_to_bp+0x6c/0x120 [xfs]
   [<ffffffffa01e7975>] xfs_iread+0x75/0x2f0 [xfs]
   [<ffffffff8114eafb>] ? inode_init_always+0xfb/0x1c0
   [<ffffffffa019311a>] xfs_iget_cache_miss+0x5a/0x1e0 [xfs]
   [<ffffffffa01933db>] xfs_iget+0x13b/0x1c0 [xfs]
   [<ffffffffa01dfaad>] xfs_ialloc+0xbd/0x860 [xfs]
   [<ffffffffa01e02e7>] xfs_dir_ialloc+0x97/0x2e0 [xfs]
   [<ffffffffa01a2308>] ? xfs_trans_reserve+0x308/0x310 [xfs]

I got the same panic running xfstest 319 with the patch at:
    http://oss.sgi.com/archives/xfs/2013-09/msg00578.html
once it hung on a xfs_buf lock before the panic.

And these are the only tests that I threw at this patch.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
