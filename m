Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Dec 2007 22:36:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB56a3HG022599
	for <xfs@oss.sgi.com>; Tue, 4 Dec 2007 22:36:05 -0800
Message-ID: <47564761.9070805@sgi.com>
Date: Wed, 05 Dec 2007 17:38:25 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: 2.6.24-rc3 oopses while mounting fs
References: <20071128134523.GF7793@luba> <474E003A.7020000@sgi.com> <20071130223154.GB13589@luba> <47537709.9040406@sgi.com> <20071203220200.GC13667@luba> <47549B1A.4070508@sgi.com> <4754FCEC.30906@sgi.com> <47563B73.2030403@sgi.com>
In-Reply-To: <47563B73.2030403@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs@oss.sgi.com

Lachlan,

An aside...

I think I see why we couldn't get "xfs_logprint -t" to work on a file (-f).
   > xfs_logprint -t -f ~/debug/sdc.xlg
   xfs_logprint:
       data device: 0xffffffffffffffff
       log device: 0xffffffffffffffff daddr: 0 length: 262144

   XFS: Log inconsistent (didn't find previous header)
   XFS: failed to find log head
   xfs_logprint: failed to find head and tail, error: 5

The problem is that it is using the superblock to determine if it is version 1
or version 2 logs in order to find out the maximum size of the iclog (log record).
And for -f there is no superblock to look at. The version number is, however, in the
log record header.
So when it looks in the undefined data it comes up with _not_ version 2,
and so assumes to look back for the hdr to only 32K when it really needs
to look back to 64k (for v2 it would limit at 256K).
Hence, it can't find the magic# in the header.

The debugging...

====================================================
Breakpoint 1, xlog_find_verify_log_record (log=0x607ffffffea96be0, start_blk=5312, last_blk=0x607ffffffea96bc0, extra_bblks=0)
     at xfs_log_recover.c:234
234             if (!(bp = xlog_get_bp(log, num_blks))) {
(gdb) bt
#0  xlog_find_verify_log_record (log=0x607ffffffea96be0, start_blk=5312, last_blk=0x607ffffffea96bc0, extra_bblks=0) at xfs_log_recover.c:234
#1  0x4000000000092020 in xlog_find_head (log=0x607ffffffea96be0, return_head_blk=0x607ffffffea96bd0) at xfs_log_recover.c:527
#2  0x4000000000094000 in xlog_find_tail (log=0x607ffffffea96be0, head_blk=0x607ffffffea96bd0, tail_blk=0x607ffffffea96bd8, readonly=0)
     at xfs_log_recover.c:616
#3  0x40000000000100a0 in xfs_log_print_trans (log=0x607ffffffea96be0, print_block_start=-1) at log_print_trans.c:49
#4  0x4000000000003600 in main (argc=<value optimized out>, argv=<value optimized out>) at logprint.c:240

(gdb) print *last_blk
$1 = 5376

start_blk = 5312
last_blk = 5376
extra_bblks = 0

Goes from 5376..5312 looking for magic# at start of sector.
Errors out if can't find one.
Which is true since the next magic# is at 5248.

logprint -d output:
   4992 HEADER Cycle 154 tail 153:253056 len  61440 ops 105
   5120 HEADER Cycle 154 tail 153:253056 len  61440 ops 344
   5248 HEADER Cycle 154 tail 153:253056 len  61440 ops 303  <--- previous block
   5376 HEADER Cycle 153 tail 153:253056 len      0 ops 0    <--- hdr
[00000 - 05376] Cycle 0x0000009a New Cycle 0x00000099
   5377 HEADER Cycle 153 tail 153:253056 len      0 ops 0
   5378 HEADER Cycle 153 tail 153:253056 len      0 ops 0

So why is it using a start_blk of 5312?


     522         num_scan_bblks = XLOG_REC_SHIFT(log);
     523         if (head_blk >= num_scan_bblks) {
     524                 start_blk = head_blk - num_scan_bblks; /* don't read head_blk */
     525
     526                 /* start ptr at last block ptr before head_blk */
  ->527                 if ((error = xlog_find_verify_log_record(log, start_blk,
     528                                                         &head_blk, 0)) == -1) {

#define XLOG_REC_SHIFT(log) \
         BTOBB(1 << (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) ? \
          XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))

#define XLOG_BIG_RECORD_BSHIFT  15              /* 32k == 1 << 15 */
#define XLOG_MAX_RECORD_BSHIFT  18              /* 256k == 1 << 18 */

Number of blocks between rec-hdrs from -d output:
5376-5248 = 128 BB

Looks like it used 5312 = 5376 - num_scan_bblks
=> num_scan_bblks = 64

Yep
(gdb) p num_scan_bblks
$3 = 64
32K
i.e. it thinks it has v1 logs

(gdb) p *(log->l_mp)
$9 = {m_sb = {sb_magicnum = 0, sb_blocksize = 0, sb_dblocks = 0, sb_rblocks = 0, sb_rextents = 0, sb_uuid = '\0' <repeats 15 times>,
     sb_logstart = 2305843009213997776, sb_rootino = 6953557824646229696, sb_rbmino = 6953557824646229688, sb_rsumino = 6953557824646229680,
     sb_rextsize = 284472, sb_agblocks = 536870912, sb_agcount = 4281151176, sb_rbmblocks = 1619001343, sb_logblocks = 0, sb_versionnum = 0,
     sb_sectsize = 0, sb_inodesize = 38256, sb_inopblock = 4, sb_fname = "\000\000\000 H?\a\000\000\000\000 ", sb_blocklog = 0 '\0',
etc...
it is not set

Okay, need to file a bug for this part so that -f can be useful here.
It needs to be using a LR h_version number for this somehow.

--Tim


Lachlan McIlroy wrote:
>> ============================================================================ 
>>
>> cycle: 154    version: 2        lsn: 154,5248    tail_lsn: 153,253056
>> length of Log Record: 61440    prev offset: 5120        num ops: 303
>> uuid: b02fc6bd-662f-40a5-8f0c-e260a881a3e7   format: little endian linux
>> h_size: 262144
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
>>
>> extended-header: cycle: 154
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
>>
>> extended-header: cycle: 154
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
>>
>> extended-header: cycle: 154
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
>>
>> extended-header: cycle: 154
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
>>
>> extended-header: cycle: 154
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
>>
>> extended-header: cycle: 154
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
>>
>> extended-header: cycle: 154
>> ---------------------------------------------------------------------------- 
>>
>> Oper (0): tid: 5769cd60  len: 0  clientid: TRANS  flags: START
>> ---------------------------------------------------------------------------- 
>>
>> Oper (1): tid: 5769cd60  len: 16  clientid: TRANS  flags: none
>> TRAN:    type: STRAT_WRITE       tid: 0       num_items: 5
>> ---------------------------------------------------------------------------- 
>>
>> Oper (2): tid: 5769cd60  len: 56  clientid: TRANS  flags: none
>> INODE: #regs: 3   ino: 0x1400005c  flags: 0x5   dsize: 16
>>         blkno: 610338736  len: 16  boff: 4096
>> Oper (3): tid: 5769cd60  len: 96  clientid: TRANS  flags: none
>> INODE CORE
>> magic 0x494e mode 0100600 version 1 format 2
>> nlink 1 uid 14029 gid 1474
>> atime 0x4716b870 mtime 0x4716bade ctime 0x4716bade
>> size 0x1ce00000 nblocks 0x1c840 extsize 0x0 nextents 0x1
>> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
>> flags 0x0 gen 0x4
>> Oper (4): tid: 5769cd60  len: 16  clientid: TRANS  flags: none
>> EXTENTS inode data
>> ---------------------------------------------------------------------------- 
> 
> 
> Another interesting point is that the transaction id has changed between
> these operations from 5769cd60 to 5769cf18.  It should stay the same.
> We may be reading old log data.
> 
>>
>> Oper (5): tid: 5769cf18  len: 24  clientid: TRANS  flags: none
>> BUF:  #regs: 2   start blkno: 610338561 (0x24610701)  len: 1  bmap 
>> size: 1  flags: 0x0
>> Oper (6): tid: 5769cf18  len: 128  clientid: TRANS  flags: none
>> AGF Buffer: XAGF
>> ver: 1  seq#: 5  len: 15258464
>> root BNO: 1  CNT: 2
>> level BNO: 1  CNT: 1
>> 1st: 0  last: 3  cnt: 4  freeblks: 2491090  longest: 581471
>> ---------------------------------------------------------------------------- 
>>
>> Oper (7): tid: 5769cf18  len: 28  clientid: TRANS  flags: none
>> BUF:  #regs: 2   start blkno: 610338568 (0x24610708)  len: 8  bmap 
>> size: 2  flags: 0x0
>> Oper (8): tid: 5769cf18  len: 128  clientid: TRANS  flags: none
>> BUF DATA
>> ---------------------------------------------------------------------------- 
>>
