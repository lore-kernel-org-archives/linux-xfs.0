Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34392 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965278AbdGTUPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 16:15:06 -0400
Received: by mail-io0-f176.google.com with SMTP id l7so15870143iof.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 13:15:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e632fff1-e72a-7b51-1431-aa0903dec5b4@sandeen.net>
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
 <20170717234814.GK17762@dastard> <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
 <bcb651de-75bf-97a6-7ed8-c083d2a440e5@sandeen.net> <CAAxjCEzZ2Q0wL=nhGVHVtK3M5Ws3MQdrUNKm3jJKO+1y-wxTkw@mail.gmail.com>
 <cb16e0b4-2ef2-cdef-e0e3-cf04abd3d4c6@sandeen.net> <CAAxjCEwjU+gMszjCWWpv8Vpc+Cx+_b0v9Vvi81d+HC8uy=FGuA@mail.gmail.com>
 <e632fff1-e72a-7b51-1431-aa0903dec5b4@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Thu, 20 Jul 2017 22:15:04 +0200
Message-ID: <CAAxjCEzCgKi_r8XY-xOQ2iKKa8RmRPjL9WRXQBi9zzNXa_9WKw@mail.gmail.com>
Subject: Re: Collecting aged XFS profiles
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 4:27 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 07/20/2017 02:52 AM, Stefan Ring wrote:
>> On Thu, Jul 20, 2017 at 12:00 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> ok, that shoulda worked... I wonder how to debug this, if you can't
>>> legally share the problematic image with me to investigate...
>>>
>>> I put a lot of effort into selectively zeroing out unused portions
>>> of metablocks a couple years back, I am surprised that this much remains.
>>>
>>> I wonder if something regressed ...
>>
>> I will try if I can find out which code paths lead to the content
>> being dumped out.
>
> Perhaps you could send xfs_info output and offsets of the "safe" strings,
> and maybe look at block or sector boundaries of the blocks containing
> those "safe" strings to identify magic numbers which would identify
> the metadata types ...
>

Ok,

I'm using the for-next branch now (0602fbe880) and inserted something
like this so I can set a breakpoint on my_break.

--- a/db/metadump.c
+++ b/db/metadump.c
@@ -169,6 +169,10 @@ write_index(void)
        return 0;
 }

+void my_break()
+{
+}
+
 /*
  * Return 0 for success, -errno for failure.
  */
@@ -184,6 +188,8 @@ write_buf_segment(
        for (i = 0; i < len; i++, off++, data += BBSIZE) {
                block_index[cur_index] = cpu_to_be64(off);
                memcpy(&block_buffer[cur_index << BBSHIFT], data, BBSIZE);
+               if (memmem(data, BBSIZE, "_mkstemp_inner", 14))
+                       my_break();
                if (++cur_index == num_indices) {
                        ret = write_index();
                        if (ret)

The backtraces are quite similar except for the "stray filenames"
case. I've repeated the exercise for every snippet I've highlighted in
the previous e-mail (in the same order):

"MasterShellCommand"
#0  my_break () at metadump.c:174
#1  0x000000000041e2a6 in write_buf_segment (data=0xe26c00 "XD2F",
off=134667936, len=8) at metadump.c:192
#2  0x000000000041e3d3 in write_buf (buf=0x7fd7b0) at metadump.c:238
#3  0x000000000042163d in process_single_fsb_objects (o=16777216,
s=16833492, c=1, btype=TYP_DIR2, last=16777217)
    at metadump.c:1829
#4  0x0000000000421cdd in process_bmbt_reclist (rp=0xdf5628,
numrecs=34, btype=TYP_DIR2) at metadump.c:1997
#5  0x0000000000421e22 in scanfunc_bmap (block=0xdf5400, agno=0,
agbno=57273, level=0, btype=TYP_BMAPBTD,
    arg=0x7fffffffd994) at metadump.c:2031
#6  0x000000000041eb6c in scan_btree (agno=0, agbno=57273, level=1,
btype=TYP_BMAPBTD, arg=0x7fffffffd994,
    func=0x421d40 <scanfunc_bmap>) at metadump.c:427
#7  0x000000000042236b in process_btinode (dip=0xdd3700,
itype=TYP_DIR2) at metadump.c:2125
#8  0x000000000042276f in process_inode_data (dip=0xdd3700,
itype=TYP_DIR2) at metadump.c:2186
#9  0x00000000004228b0 in process_inode (agno=0, agino=900491,
dip=0xdd3700, free_inode=false) at metadump.c:2231
#10 0x0000000000422e15 in copy_inode_chunk (agno=0, rp=0xafee40) at
metadump.c:2373
#11 0x0000000000422fd5 in scanfunc_ino (block=0xafea00, agno=0,
agbno=25, level=0, btype=TYP_INOBT, arg=0x7fffffffdc44)
    at metadump.c:2433
#12 0x000000000041eb6c in scan_btree (agno=0, agbno=25, level=1,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#13 0x000000000042317e in scanfunc_ino (block=0x78d200, agno=0,
agbno=63095, level=1, btype=TYP_INOBT,
    arg=0x7fffffffdc44) at metadump.c:2456
#14 0x000000000041eb6c in scan_btree (agno=0, agbno=63095, level=2,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#15 0x0000000000423274 in copy_inodes (agno=0, agi=0x6cd400) at metadump.c:2489
#16 0x00000000004238b3 in scan_ag (agno=0) at metadump.c:2613
#17 0x00000000004244be in metadump_f (argc=5, argv=0x6cd310) at metadump.c:2895
#18 0x000000000041a544 in main (argc=<value optimized out>,
argv=<value optimized out>) at init.c:207


"MANPATH_MAP"
#0  my_break () at metadump.c:174
#1  0x000000000041e2a6 in write_buf_segment (
    data=0xe38000 " nearby files and
directories.\n#\nMANPATH_MAP\t/bin\t\t\t/usr/share/man\nMANPATH_MAP\t/sbin\t\t\t/usr/share/man\nMANPATH_MAP\t/usr/bin\t\t/usr/share/man\nMANPATH_MAP\t/usr/sbin\t\t/usr/share/man\nMANPATH_MAP\t/usr/local/"...,
off=67559158, len=8) at metadump.c:192
#2  0x000000000041e3d3 in write_buf (buf=0x7fd750) at metadump.c:238
#3  0x000000000042163d in process_single_fsb_objects (o=8388608,
s=8444894, c=1, btype=TYP_DIR2, last=8388609)
    at metadump.c:1829
#4  0x0000000000421cdd in process_bmbt_reclist (rp=0xe2ff84,
numrecs=3, btype=TYP_DIR2) at metadump.c:1997
#5  0x00000000004226db in process_exinode (dip=0xe2ff00,
itype=TYP_DIR2) at metadump.c:2157
#6  0x000000000042275c in process_inode_data (dip=0xe2ff00,
itype=TYP_DIR2) at metadump.c:2183
#7  0x00000000004228b0 in process_inode (agno=0, agino=900611,
dip=0xe2ff00, free_inode=false) at metadump.c:2231
#8  0x0000000000422e15 in copy_inode_chunk (agno=0, rp=0xafee50) at
metadump.c:2373
#9  0x0000000000422fd5 in scanfunc_ino (block=0xafea00, agno=0,
agbno=25, level=0, btype=TYP_INOBT, arg=0x7fffffffdc44)
    at metadump.c:2433
#10 0x000000000041eb6c in scan_btree (agno=0, agbno=25, level=1,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#11 0x000000000042317e in scanfunc_ino (block=0x78d200, agno=0,
agbno=63095, level=1, btype=TYP_INOBT,
    arg=0x7fffffffdc44) at metadump.c:2456
#12 0x000000000041eb6c in scan_btree (agno=0, agbno=63095, level=2,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#13 0x0000000000423274 in copy_inodes (agno=0, agi=0x6cd400) at metadump.c:2489
#14 0x00000000004238b3 in scan_ag (agno=0) at metadump.c:2613
#15 0x00000000004244be in metadump_f (argc=5, argv=0x6cd310) at metadump.c:2895
#16 0x000000000041a544 in main (argc=<value optimized out>,
argv=<value optimized out>) at init.c:207


"RPM-GPG-KEY-beta"
#0  my_break () at metadump.c:174
#1  0x000000000041e2a6 in write_buf_segment (data=0xf1b600
"INA\375\002\002", off=451728, len=32) at metadump.c:192
#2  0x000000000041e3d3 in write_buf (buf=0x7fd6f0) at metadump.c:238
#3  0x0000000000422e4b in copy_inode_chunk (agno=0, rp=0xafef80) at
metadump.c:2380
#4  0x0000000000422fd5 in scanfunc_ino (block=0xafea00, agno=0,
agbno=25, level=0, btype=TYP_INOBT, arg=0x7fffffffdc44)
    at metadump.c:2433
#5  0x000000000041eb6c in scan_btree (agno=0, agbno=25, level=1,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#6  0x000000000042317e in scanfunc_ino (block=0x78d200, agno=0,
agbno=63095, level=1, btype=TYP_INOBT,
    arg=0x7fffffffdc44) at metadump.c:2456
#7  0x000000000041eb6c in scan_btree (agno=0, agbno=63095, level=2,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#8  0x0000000000423274 in copy_inodes (agno=0, agi=0x6cd400) at metadump.c:2489
#9  0x00000000004238b3 in scan_ag (agno=0) at metadump.c:2613
#10 0x00000000004244be in metadump_f (argc=5, argv=0x6cd310) at metadump.c:2895
#11 0x000000000041a544 in main (argc=<value optimized out>,
argv=<value optimized out>) at init.c:207


"_mkstemp_inner"
#0  my_break () at metadump.c:174
#1  0x000000000041e2a6 in write_buf_segment (
    data=0x1388e00 "le.py\", line 300, in mkstemp\n2015-04-15 16:25:34
(140466167215872)     return _mkstemp_inner(dir, prefix, suffix,
flags)\n2015-04-15 16:25:34 (140466167215872)   File
\"/opt/vtse/lib/python2.7/tempfile."...,
    off=67568243, len=8) at metadump.c:192
#2  0x000000000041e3d3 in write_buf (buf=0x7fd750) at metadump.c:238
#3  0x000000000042163d in process_single_fsb_objects (o=8388608,
s=8446030, c=1, btype=TYP_DIR2, last=8388609)
    at metadump.c:1829
#4  0x0000000000421cdd in process_bmbt_reclist (rp=0x1382b84,
numrecs=3, btype=TYP_DIR2) at metadump.c:1997
#5  0x00000000004226db in process_exinode (dip=0x1382b00,
itype=TYP_DIR2) at metadump.c:2157
#6  0x000000000042275c in process_inode_data (dip=0x1382b00,
itype=TYP_DIR2) at metadump.c:2183
#7  0x00000000004228b0 in process_inode (agno=0, agino=918921,
dip=0x1382b00, free_inode=false) at metadump.c:2231
#8  0x0000000000422e15 in copy_inode_chunk (agno=0, rp=0x117bbd0) at
metadump.c:2373
#9  0x0000000000422fd5 in scanfunc_ino (block=0x117b800, agno=0,
agbno=57301, level=0, btype=TYP_INOBT,
    arg=0x7fffffffdc44) at metadump.c:2433
#10 0x000000000041eb6c in scan_btree (agno=0, agbno=57301, level=1,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#11 0x000000000042317e in scanfunc_ino (block=0x78d200, agno=0,
agbno=63095, level=1, btype=TYP_INOBT,
    arg=0x7fffffffdc44) at metadump.c:2456
#12 0x000000000041eb6c in scan_btree (agno=0, agbno=63095, level=2,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#13 0x0000000000423274 in copy_inodes (agno=0, agi=0x6cd400) at metadump.c:2489
#14 0x00000000004238b3 in scan_ag (agno=0) at metadump.c:2613
#15 0x00000000004244be in metadump_f (argc=5, argv=0x6cd310) at metadump.c:2895
#16 0x000000000041a544 in main (argc=<value optimized out>,
argv=<value optimized out>) at init.c:207

SVG
#0  my_break () at metadump.c:174
#1  0x000000000041e2a6 in write_buf_segment (data=0x132f400 "",
off=67567736, len=8) at metadump.c:192
#2  0x000000000041e3d3 in write_buf (buf=0x7fd750) at metadump.c:238
#3  0x000000000042163d in process_single_fsb_objects (o=8388608,
s=8445967, c=1, btype=TYP_DIR2, last=8388609)
    at metadump.c:1829
#4  0x0000000000421cdd in process_bmbt_reclist (rp=0x132b874,
numrecs=2, btype=TYP_DIR2) at metadump.c:1997
#5  0x00000000004226db in process_exinode (dip=0x132b800,
itype=TYP_DIR2) at metadump.c:2157
#6  0x000000000042275c in process_inode_data (dip=0x132b800,
itype=TYP_DIR2) at metadump.c:2183
#7  0x00000000004228b0 in process_inode (agno=0, agino=917784,
dip=0x132b800, free_inode=false) at metadump.c:2231
#8  0x0000000000422e15 in copy_inode_chunk (agno=0, rp=0x117bb50) at
metadump.c:2373
#9  0x0000000000422fd5 in scanfunc_ino (block=0x117b800, agno=0,
agbno=57301, level=0, btype=TYP_INOBT,
    arg=0x7fffffffdc44) at metadump.c:2433
#10 0x000000000041eb6c in scan_btree (agno=0, agbno=57301, level=1,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#11 0x000000000042317e in scanfunc_ino (block=0x78d200, agno=0,
agbno=63095, level=1, btype=TYP_INOBT,
    arg=0x7fffffffdc44) at metadump.c:2456
#12 0x000000000041eb6c in scan_btree (agno=0, agbno=63095, level=2,
btype=TYP_INOBT, arg=0x7fffffffdc44,
    func=0x422ecd <scanfunc_ino>) at metadump.c:427
#13 0x0000000000423274 in copy_inodes (agno=0, agi=0x6cd400) at metadump.c:2489
#14 0x00000000004238b3 in scan_ag (agno=0) at metadump.c:2613
#15 0x00000000004244be in metadump_f (argc=5, argv=0x6cd310) at metadump.c:2895
#16 0x000000000041a544 in main (argc=<value optimized out>,
argv=<value optimized out>) at init.c:207


Is this helpful?

Now I also know that I have proceeded to inode 21440 of 11857664 with
my visual inspection, so it is a good thing that I stopped early ;).
