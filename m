Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34141 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdGUNb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 09:31:59 -0400
Received: by mail-oi0-f46.google.com with SMTP id q4so51857301oif.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 06:31:58 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <CAPh1sj5oU6QRyH_cnzrkGJb6ed3XO4fGABJ4yJLPnb-ppqVJeg@mail.gmail.com>
In-Reply-To: <CAPh1sj5oU6QRyH_cnzrkGJb6ed3XO4fGABJ4yJLPnb-ppqVJeg@mail.gmail.com>
MIME-Version: 1.0
Date: Fri, 21 Jul 2017 19:01:58 +0530
Message-ID: <4381c2b04c11a81f9203d5595651c64a@mail.gmail.com>
Subject: RE: Metadata corruption detected at xfs_attr3_leaf_write_verify
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi Eric et al,

I'am pulling from an old thread. From time to time we hit an xfs corruption
when xattr leaf is attempted to be written when it has ichdr.count==0.

We are on an old kernel 3.18.19. We managed to capture xfs trace buffer
closer to the problem time.

This is the corruption report
	Jul 20 05:22:27.189727 node1 kernel: [466290.765299] XFS (dm-78): Metadata
corruption detected at xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs], block
0x9698734d8
	Jul 20 05:22:27.189741 node1 kernel: [466290.767279] XFS (dm-78): Unmount
and run xfs_repair
	Jul 20 05:22:27.189743 node1 kernel: [466290.768022] XFS (dm-78): First 64
bytes of corrupted metadata buffer:
	Jul 20 05:22:27.191635 node1 kernel: [466290.768832] ffff88002b4bf000: 00
00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
	Jul 20 05:22:27.192949 node1 kernel: [466290.770163] ffff88002b4bf010: 10
00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
	Jul 20 05:22:27.192953 node1 kernel: [466290.771264] ffff88002b4bf020: 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	Jul 20 05:22:27.195921 node1 kernel: [466290.772815] ffff88002b4bf030: 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

>From xfs xattr debug trace, it appears that a file is created within a
directory having default ACL set. This causes file creation to insert xattr
leaf during file creation. This completes queuing an AIL. Immediately after
this an explicit xfs_setattr is being done on the same file which alters the
default ACL & this causes default ACL to be removed/added. It looks like
this 2nd set attr is somehow influencing the first AIL entry that it is
being seen with ichr.count==0 during the write. Any pointers/input to check
this further is greatly appreciated. I can pass the full xfs debug trace if
required. Here is the snippet of debug trace causing the issue

           <...>-18953 [004] ...1 466290.749358: xfs_attr_sf_create: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.749359: xfs_attr_sf_addname: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.749361: xfs_attr_sf_lookup: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.749362: xfs_attr_sf_to_leaf: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.749430: xfs_attr_leaf_create: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.749454: xfs_attr_leaf_addname: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.749456: xfs_attr_leaf_lookup: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.749457: xfs_attr_leaf_add: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.749458: xfs_attr_leaf_add_work: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.749649: xfs_getattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.749908: xfs_attr_leaf_get: dev
253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 1024 hashval
0xea9061c8 op_flags
           <...>-18953 [004] ...1 466290.749910: xfs_attr_leaf_lookup: dev
253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 1024 hashval
0xea9061c8 op_flags
           <...>-18953 [004] ...1 466290.749918: xfs_getattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.749931: xfs_attr_leaf_get: dev
253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 1024 hashval
0x487716dd op_flags
           <...>-18953 [004] ...1 466290.749932: xfs_attr_leaf_lookup: dev
253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 1024 hashval
0x487716dd op_flags
           <...>-18953 [004] ...1 466290.749984: xfs_getattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.749990: xfs_getattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.750063: xfs_setattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.750257: xfs_attr_leaf_addname: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750260: xfs_attr_leaf_lookup: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750261: xfs_attr_leaf_replace: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750262: xfs_attr_leaf_add: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags RENAME|ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750262: xfs_attr_leaf_add_work: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags RENAME|ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750270: xfs_attr_leaf_flipflags:
dev 253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100
hashval 0x275b19c4 op_flags RENAME|ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750275: xfs_attr_leaf_remove: dev
253:78 ino 0x1749833903 name SGI_ACL_FILE namelen 12 valuelen 100 hashval
0x275b19c4 op_flags RENAME|ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750461: xfs_attr_leaf_removename:
dev 253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 0 hashval
0xea9061c8 op_flags OKNOENT
           <...>-18953 [004] ...1 466290.750463: xfs_attr_leaf_lookup: dev
253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 0 hashval 0xea9061c8
op_flags OKNOENT
           <...>-18953 [004] ...1 466290.750474: xfs_attr_leaf_addname: dev
253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 49 hashval
0x487716dd op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750475: xfs_attr_leaf_lookup: dev
253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 49 hashval
0x487716dd op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750476: xfs_attr_leaf_add: dev
253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 49 hashval
0x487716dd op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750476: xfs_attr_leaf_add_work: dev
253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 49 hashval
0x487716dd op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750645: xfs_getattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.750648: xfs_getattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.750645: xfs_getattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.750648: xfs_getattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.750659: xfs_attr_leaf_get: dev
253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 1024 hashval
0x487716dd op_flags
           <...>-18953 [004] ...1 466290.750661: xfs_attr_leaf_lookup: dev
253:78 ino 0x1749833903 name SAMBA_PAI namelen 9 valuelen 1024 hashval
0x487716dd op_flags
           <...>-18953 [004] ...1 466290.750744: xfs_getattr: dev 253:78 ino
0x1749833903
           <...>-18953 [004] ...1 466290.750791: xfs_attr_leaf_addname: dev
253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 444 hashval 0xea9061c8
op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750793: xfs_attr_leaf_lookup: dev
253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 444 hashval 0xea9061c8
op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750794: xfs_attr_leaf_add: dev
253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 444 hashval 0xea9061c8
op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.750794: xfs_attr_leaf_add_work: dev
253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 444 hashval 0xea9061c8
op_flags ADDNAME|OKNOENT
           <...>-18953 [004] ...1 466290.751029: xfs_attr_leaf_get: dev
253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 1024 hashval
0xea9061c8 op_flags
           <...>-18953 [004] ...1 466290.751031: xfs_attr_leaf_lookup: dev
253:78 ino 0x1749833903 name NTACL namelen 5 valuelen 1024 hashval
0xea9061c8 op_flags


Thanks.

--Shyam

On Tue, Apr 26, 2016 at 4:10 PM, Shyam Kaushik <shyam@zadarastorage.com>
wrote:
Hi Eric,

Yes this is a non-CRC FS. The workload is we a custom application that
does several (16 threads) file create/read/writes/update xattrs on a XFS
mounted over raw disk.

There is no messages prior to this & we hit this once in a few days (like
every 4-5 days). I will try your suggestion of running with xfs_attr_*
tracepoints all the time so that when we hit this error we have better
info. Please let me know if you prefer to add further debug prints.
Thanks.

--Shyam

> Eric Sandeen sandeen at sandeen.net wrote:
> On Mon Apr 25 16:57:11 CDT 2016
>
> Is this a non-crc filesystem?
>
>
> XFS_ATTR_LEAF_MAGIC is ok (if it's a non-crc filesystem)
>
> Looks the same as the other report, tripping on:
>
>        if (ichdr.count == 0)
>                return false;
>
> A reproducer would be super here.  At least maybe a description of the
> workload that hits it?
>
> Count is manipulated in things like attr leaf compaction...
> Any other messages prior to this?
>
> How often do you hit it?
>
> You could also turn on xfs_attr_* tracepoints, maybe.
>
> -Eric

-----Original Message-----
From: Shyam Kaushik [mailto:shyam@zadarastorage.com]
Sent: 25 April 2016 22:22
To: 'xfs@oss.sgi.com'
Cc: Alex Lyakas
Subject: Metadata corruption detected at
xfs_attr3_leaf_write_verify+0xe5/0x100

Hi Dave et al,

We are periodically hitting the below metadata corruption with XFS over a
raw disk running several file copies with xattr operations on kernel
3.18.19. Unmounting & running xfs_repair doesn't report any corruption. I
see that this was last reported here
http://oss.sgi.com/archives/xfs/2015-12/msg00224.html

Unfortunately we dont have a reproducer, but this issue happens
periodically. We can add more debug prints & allow this issue to happen
again. Can you pls suggest any options to debug this further? Thanks

Apr 20 21:58:03 node1 kernel: [16736.286370] XFS (dm-26): Metadata
corruption detected at xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs], block
0x19c5c728
Apr 20 21:58:03 node1 kernel: [16736.289084] XFS (dm-26): Unmount and run
xfs_repair
Apr 20 21:58:03 node1 kernel: [16736.290257] XFS (dm-26): First 64 bytes
of corrupted metadata buffer:
Apr 20 21:58:03 node1 kernel: [16736.291797] ffff880123668000: 00 00 00 00
00 00 00 00 fb ee 00 00 00 00 00 00  ................
Apr 20 21:58:03 node1 kernel: [16736.293823] ffff880123668010: 10 00 00 00
00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Apr 20 21:58:03 node1 kernel: [16736.297504] ffff880123668020: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Apr 20 21:58:03 node1 kernel: [16736.299343] ffff880123668030: 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00  ................
Apr 20 21:58:03 node1 kernel: [16736.301465] XFS (dm-26):
xfs_do_force_shutdown(0x8) called from line 1244 of file fs/xfs/xfs_buf.c.
Return address = 0xffffffffc095cee0
Apr 20 21:58:03 node1 kernel: [16736.301469] ------------[ cut here
]------------
Apr 20 21:58:03 node1 kernel: [16736.301551] XFS(dm-26): SHUTDOWN!!!
old_flags=0x0 new_flags=0x8
Apr 20 21:58:03 node1 kernel: [16736.301703] CPU: 1 PID: 7857 Comm:
xfsaild/dm-26 Tainted: G           OE  3.18.19 #1
Apr 20 21:58:03 node1 kernel: [16736.301705] Hardware name: Bochs Bochs,
BIOS Bochs 01/01/2011
Apr 20 21:58:03 node1 kernel: [16736.301707]  0000000000000009
ffff88020c5ffb38 ffffffff81710c85 0000000000000000
Apr 20 21:58:03 node1 kernel: [16736.301711]  ffff88020c5ffb88
ffff88020c5ffb78 ffffffff81072df1 2e2e202030302030
Apr 20 21:58:03 node1 kernel: [16736.301715]  0000000000000000
0000000000000008 ffff88020c127000 0000000000000000
Apr 20 21:58:03 node1 kernel: [16736.301718] Call Trace:
Apr 20 21:58:03 node1 kernel: [16736.301769]  [<ffffffff81710c85>]
dump_stack+0x4e/0x71
Apr 20 21:58:03 node1 kernel: [16736.301780]  [<ffffffff81072df1>]
warn_slowpath_common+0x81/0xa0
Apr 20 21:58:03 node1 kernel: [16736.301784]  [<ffffffff81072e56>]
warn_slowpath_fmt+0x46/0x50
Apr 20 21:58:03 node1 kernel: [16736.301860]  [<ffffffffc09693f3>]
xfs_do_force_shutdown+0x33/0x170 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.301921]  [<ffffffffc095cee0>] ?
_xfs_buf_ioapply+0xa0/0x430 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.301951]  [<ffffffffc095ee4b>] ?
__xfs_buf_delwri_submit+0x22b/0x290 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302066]  [<ffffffffc095cee0>]
_xfs_buf_ioapply+0xa0/0x430 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302137]  [<ffffffff8109e260>] ?
wake_up_state+0x20/0x20
Apr 20 21:58:03 node1 kernel: [16736.302162]  [<ffffffffc095ee4b>] ?
__xfs_buf_delwri_submit+0x22b/0x290 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302183]  [<ffffffffc095ea78>]
xfs_buf_submit+0x68/0x210 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302241]  [<ffffffffc095ee4b>]
__xfs_buf_delwri_submit+0x22b/0x290 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302267]  [<ffffffffc095fc60>] ?
xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302291]  [<ffffffffc098f440>] ?
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302308]  [<ffffffffc095fc60>]
xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302333]  [<ffffffffc098f66b>]
xfsaild+0x22b/0x630 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302513]  [<ffffffffc098f440>] ?
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
Apr 20 21:58:03 node1 kernel: [16736.302518]  [<ffffffff810911b9>]
kthread+0xc9/0xe0
Apr 20 21:58:03 node1 kernel: [16736.302522]  [<ffffffff810910f0>] ?
kthread_create_on_node+0x180/0x180
Apr 20 21:58:03 node1 kernel: [16736.302530]  [<ffffffff81717918>]
ret_from_fork+0x58/0x90
Apr 20 21:58:03 node1 kernel: [16736.302549]  [<ffffffff810910f0>] ?
kthread_create_on_node+0x180/0x180
Apr 20 21:58:03 node1 kernel: [16736.302551] ---[ end trace
0bb81b88fdd6a298 ]---

--Shyam
