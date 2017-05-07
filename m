Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:36469 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756209AbdEGWp2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 May 2017 18:45:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sun, 07 May 2017 21:09:49 +0200
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Locking problems with Linux 4.9 with NFSD and `fs/iomap.c`
Message-ID: <de171adc29600902515d1424fd800678@molgen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: it+linux-nfs@molgen.mpg.de

Dear Linux folks,


There seems to be a regression in Linux 4.9 compared to 4.4. Maybe you 
have an idea.

The system used 4.4.38 without issues, and was updated to 4.9.23 on 
April 24th. Since Friday, the NFS exports where not accessible anymore. 
Rebooting the system into 4.9.24, 4.9.24, and 4.9.25 didn’t change 
anything, and the system went into the some lock right away. Booting 
4.4.38 fixed the issue though.

Here is more information.

NFS doesn’t respond to a null call.

```
# tshark -r x.x
   1   0.000000 141.14.16.23 -> 141.14.26.2  TCP 74 1005 → 2049 [SYN] 
Seq=0 Win=29200 Len=0 MSS=1460 SACK_PERM=1 TSval=327954228 TSecr=0 
WS=512
   2   0.000245  141.14.26.2 -> 141.14.16.23 TCP 74 2049 → 1005 [SYN, 
ACK] Seq=0 Ack=1 Win=28960 Len=0 MSS=1460 SACK_PERM=1 TSval=1126765132 
TSecr=327954228 WS=512
   3   0.000269 141.14.16.23 -> 141.14.26.2  TCP 66 1005 → 2049 [ACK] 
Seq=1 Ack=1 Win=29696 Len=0 TSval=327954229 TSecr=1126765132
   4   0.000300 141.14.16.23 -> 141.14.26.2  NFS 110 V4 NULL Call
   5   0.202652 141.14.16.23 -> 141.14.26.2  TCP 110 [TCP Retransmission] 
1005 → 2049 [PSH, ACK] Seq=1 Ack=1 Win=29696 Len=44 TSval=327954432 
TSecr=1126765132
   6   0.410651 141.14.16.23 -> 141.14.26.2  TCP 110 [TCP Retransmission] 
1005 → 2049 [PSH, ACK] Seq=1 Ack=1 Win=29696 Len=44 TSval=327954640 
TSecr=1126765132
   7   0.818649 141.14.16.23 -> 141.14.26.2  TCP 110 [TCP Retransmission] 
1005 → 2049 [PSH, ACK] Seq=1 Ack=1 Win=29696 Len=44 TSval=327955048 
TSecr=1126765132
   8   1.012429  141.14.26.2 -> 141.14.16.23 TCP 74 [TCP Spurious 
Retransmission] 2049 → 1005 [SYN, ACK] Seq=0 Ack=1 Win=28960 Len=0 
MSS=1460 SACK_PERM=1 TSval=1126766144 TSecr=327955048 WS=512
   9   1.012448 141.14.16.23 -> 141.14.26.2  TCP 66 [TCP Dup ACK 3#1] 
1005 → 2049 [ACK] Seq=45 Ack=1 Win=29696 Len=0 TSval=327955241 
TSecr=1126765132
  10   1.674650 141.14.16.23 -> 141.14.26.2  TCP 110 [TCP Retransmission] 
1005 → 2049 [PSH, ACK] Seq=1 Ack=1 Win=29696 Len=44 TSval=327955904 
TSecr=1126765132
  11   3.060502  141.14.26.2 -> 141.14.16.23 TCP 74 [TCP Spurious 
Retransmission] 2049 → 1005 [SYN, ACK] Seq=0 Ack=1 Win=28960 Len=0 
MSS=1460 SACK_PERM=1 TSval=1126768193 TSecr=327955904 WS=512
  12   3.060521 141.14.16.23 -> 141.14.26.2  TCP 66 [TCP Dup ACK 3#2] 
1005 → 2049 [ACK] Seq=45 Ack=1 Win=29696 Len=0 TSval=327957289 
TSecr=1126765132
  13   3.338653 141.14.16.23 -> 141.14.26.2  TCP 110 [TCP Retransmission] 
1005 → 2049 [PSH, ACK] Seq=1 Ack=1 Win=29696 Len=44 TSval=327957568 
TSecr=1126765132
```

``
# tshark -r x.x
   1   0.000000 141.14.16.23 -> 141.14.26.2  TCP 74 690 → 2049 [SYN] 
Seq=0 Win=29200 Len=0 MSS=1460 SACK_PERM=1 TSval=328229577 TSecr=0 
WS=512
   2   0.000039  141.14.26.2 -> 141.14.16.23 TCP 74 2049 → 690 [SYN, ACK] 
Seq=0 Ack=1 Win=28960 Len=0 MSS=1460 SACK_PERM=1 TSval=1127040480 
TSecr=328229577 WS=512
   3   0.000155 141.14.16.23 -> 141.14.26.2  TCP 66 690 → 2049 [ACK] 
Seq=1 Ack=1 Win=29696 Len=0 TSval=328229577 TSecr=1127040480
   4   0.000180 141.14.16.23 -> 141.14.26.2  NFS 110 V4 NULL Call
   5   0.206937 141.14.16.23 -> 141.14.26.2  TCP 110 [TCP Retransmission] 
690 → 2049 [PSH, ACK] Seq=1 Ack=1 Win=29696 Len=44 TSval=328229784 
TSecr=1127040480
   6   0.414925 141.14.16.23 -> 141.14.26.2  TCP 110 [TCP Retransmission] 
690 → 2049 [PSH, ACK] Seq=1 Ack=1 Win=29696 Len=44 TSval=328229992 
TSecr=1127040480
   7   0.822928 141.14.16.23 -> 141.14.26.2  TCP 110 [TCP Retransmission] 
690 → 2049 [PSH, ACK] Seq=1 Ack=1 Win=29696 Len=44 TSval=328230400 
TSecr=1127040480
   8   1.056498  141.14.26.2 -> 141.14.16.23 TCP 74 [TCP Spurious 
Retransmission] 2049 → 690 [SYN, ACK] Seq=0 Ack=1 Win=28960 Len=0 
MSS=1460 SACK_PERM=1 TSval=1127041536 TSecr=328230400 WS=512
```

Looking at the stack traces of the nfsd process with

```
for p in $(pgrep 'nfsd$'); do echo $p; cat /proc/$p/stack; done
```

all but one have the trace below.


```
[<ffffffff813eded7>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffff8133aa1c>] xfs_file_buffered_aio_write+0x5c/0x2d0
[<ffffffff8133ad2e>] xfs_file_write_iter+0x9e/0x150
[<ffffffff81196b50>] do_iter_readv_writev+0xa0/0xf0
[<ffffffff81197d4a>] do_readv_writev+0x18a/0x230
[<ffffffff8119803c>] vfs_writev+0x3c/0x50
[<ffffffffa02826b5>] nfsd_vfs_write+0xc5/0x280 [nfsd]
[<ffffffffa028e48a>] nfsd4_write+0x17a/0x1d0 [nfsd]
[<ffffffffa02902f9>] nfsd4_proc_compound+0x369/0x5e0 [nfsd]
[<ffffffffa027e218>] nfsd_dispatch+0xa8/0x180 [nfsd]
[<ffffffffa01a66af>] svc_process_common+0x3ff/0x580 [sunrpc]
[<ffffffffa01a696b>] svc_process+0x13b/0x1b0 [sunrpc]
[<ffffffffa027dc7d>] nfsd+0xed/0x160 [nfsd]
[<ffffffff8107b0ba>] kthread+0xca/0xe0
[<ffffffff81a97092>] ret_from_fork+0x22/0x30
[<ffffffffffffffff>] 0xffffffffffffffff
```

The one problematic one has the stack trace below.

```
[<ffffffff811f6f6c>] iomap_write_begin+0x8c/0x120
[<ffffffff811f758b>] iomap_zero_range_actor+0xeb/0x210     # oder 
iomap_zero_range_actor+0x90/0x210
[<ffffffff811f77e2>] iomap_apply+0xa2/0x110
[<ffffffff811f79b8>] iomap_zero_range+0x58/0x80
[<ffffffff8133a38e>] xfs_zero_eof+0x4e/0xb0
[<ffffffff8133a58d>] xfs_file_aio_write_checks+0x19d/0x1c0
[<ffffffff8133aa39>] xfs_file_buffered_aio_write+0x79/0x2d0
[<ffffffff8133ad2e>] xfs_file_write_iter+0x9e/0x150
[<ffffffff81196b50>] do_iter_readv_writev+0xa0/0xf0
[<ffffffff81197d4a>] do_readv_writev+0x18a/0x230
[<ffffffff8119803c>] vfs_writev+0x3c/0x50
[<ffffffffa02826b5>] nfsd_vfs_write+0xc5/0x280 [nfsd]
[<ffffffffa028e48a>] nfsd4_write+0x17a/0x1d0 [nfsd]
[<ffffffffa02902f9>] nfsd4_proc_compound+0x369/0x5e0 [nfsd]
[<ffffffffa027e218>] nfsd_dispatch+0xa8/0x180 [nfsd]
[<ffffffffa01a66af>] svc_process_common+0x3ff/0x580 [sunrpc]
[<ffffffffa01a696b>] svc_process+0x13b/0x1b0 [sunrpc]
[<ffffffffa027dc7d>] nfsd+0xed/0x160 [nfsd]
[<ffffffff8107b0ba>] kthread+0xca/0xe0
[<ffffffff81a97092>] ret_from_fork+0x22/0x30
[<ffffffffffffffff>] 0xffffffffffffffff
```

Here is the corresponding lines in the source code.

```
info line *0xffffffff811f6f6c Line 124 of "fs/iomap.c" starts at address 
0xffffffff811f6f6c <iomap_write_begin+140> and ends at 
0xffffffff811f6f70 <iomap_write_begin+144>.
info line *0xffffffff811f758b Line 345 of "fs/iomap.c" starts at address 
0xffffffff811f758b <iomap_zero_range_actor+235> and ends at 
0xffffffff811f758f <iomap_zero_range_actor+239>.
info line *0xffffffff811f7530 Line 385 of "fs/iomap.c" starts at address 
0xffffffff811f7530 <iomap_zero_range_actor+144> and ends at 
0xffffffff811f7538 <iomap_zero_range_actor+152>.
```

Here is the code.

```
[…]
109 static int
110 iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, 
unsigned flags,
111                 struct page **pagep, struct iomap *iomap)
112 {
113         pgoff_t index = pos >> PAGE_SHIFT;
114         struct page *page;
115         int status = 0;
116
117         BUG_ON(pos + len > iomap->offset + iomap->length);
118
119         if (fatal_signal_pending(current))
120                 return -EINTR;
121
122         page = grab_cache_page_write_begin(inode->i_mapping, index, 
flags);
123         if (!page)
124                 return -ENOMEM;
125
126         status = __block_write_begin_int(page, pos, len, NULL, 
iomap);
127         if (unlikely(status)) {
128                 unlock_page(page);
129                 put_page(page);
130                 page = NULL;
131
132                 iomap_write_failed(inode, pos, len);
133         }
134
135         *pagep = page;
136         return status;
137 }
[…]
```

So it looks like insufficent memory? But the machine has 1 TB of RAM, 
and I didn’t see any suspicious running `htop`. Also it should have 
returned from with that error, shouldn’t it have?


Kind regards,

Paul
