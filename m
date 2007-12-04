Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Dec 2007 23:08:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB477qsW008591
	for <xfs@oss.sgi.com>; Mon, 3 Dec 2007 23:07:55 -0800
Message-ID: <4754FCEC.30906@sgi.com>
Date: Tue, 04 Dec 2007 18:08:28 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: 2.6.24-rc3 oopses while mounting fs
References: <20071128134523.GF7793@luba> <474E003A.7020000@sgi.com> <20071130223154.GB13589@luba> <47537709.9040406@sgi.com> <20071203220200.GC13667@luba> <47549B1A.4070508@sgi.com>
In-Reply-To: <47549B1A.4070508@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

The transactional view appears to be truncated.

============================================================================
TRANS: tid:0x5769cb28  type:STRAT_WRITE  #items:5  trans:0x0  q:0x56dfa0
INO: cnt:3 total:3 a:0x56f5e0 len:56 a:0x56f570 len:96 a:0x56df80 len:16
         INODE: #regs:3   ino:0x1400005c  flags:0x5   dsize:16
         CORE inode:
                 magic:IN  mode:0x8180  ver:1  format:2  onlink:1
                 uid:14029  gid:1474  nlink:1 projid:0
                 atime:1192671344  mtime:1192672095  ctime:1192672095
                 flushiter:20
                 size:0x20700000  nblks:0x20740  exsize:0  nextents:1  anextents:0
                 forkoff:0  dmevmask:0x0  dmstate:0  flags:0x0  gen:4
                 DATA FORK EXTENTS inode data:
BUF: cnt:2 total:2 a:0x56dc50 len:24 a:0x56dca0 len:128
         BUF:  #regs:2   start blkno:0x24610701   len:1   bmap size:1   flags:0x0
         AGF Buffer: (XAGF)
BUF: cnt:2 total:2 a:0x56ddc0 len:28 a:0x56dd30 len:128
         BUF:  #regs:2   start blkno:0x24610708   len:8   bmap size:2   flags:0x0
         BUF DATA
BUF: cnt:3 total:3 a:0x56df20 len:28 a:0x56f010 len:128 a:0x56f160 len:256
         BUF:  #regs:3   start blkno:0x24610710   len:8   bmap size:2   flags:0x0
         BUF DATA
         BUF DATA
BUF: cnt:2 total:2 a:0x56ddf0 len:24 a:0x56f0a0 len:128
         BUF:  #regs:2   start blkno:0x0   len:1   bmap size:1   flags:0x0
         SUPER Block Buffer:

LOG REC AT LSN cycle 154 block 5248 (0x9a, 0x1480)

... just stops there.  Looking at the non-transactional view at this point:

============================================================================
cycle: 154	version: 2		lsn: 154,5248	tail_lsn: 153,253056
length of Log Record: 61440	prev offset: 5120		num ops: 303
uuid: b02fc6bd-662f-40a5-8f0c-e260a881a3e7   format: little endian linux
h_size: 262144
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extended-header: cycle: 154
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extended-header: cycle: 154
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extended-header: cycle: 154
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extended-header: cycle: 154
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extended-header: cycle: 154
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extended-header: cycle: 154
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extended-header: cycle: 154
----------------------------------------------------------------------------
Oper (0): tid: 5769cd60  len: 0  clientid: TRANS  flags: START
----------------------------------------------------------------------------
Oper (1): tid: 5769cd60  len: 16  clientid: TRANS  flags: none
TRAN:    type: STRAT_WRITE       tid: 0       num_items: 5
----------------------------------------------------------------------------
Oper (2): tid: 5769cd60  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x1400005c  flags: 0x5   dsize: 16
         blkno: 610338736  len: 16  boff: 4096
Oper (3): tid: 5769cd60  len: 96  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100600 version 1 format 2
nlink 1 uid 14029 gid 1474
atime 0x4716b870 mtime 0x4716bade ctime 0x4716bade
size 0x1ce00000 nblocks 0x1c840 extsize 0x0 nextents 0x1
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x4
Oper (4): tid: 5769cd60  len: 16  clientid: TRANS  flags: none
EXTENTS inode data
----------------------------------------------------------------------------
Oper (5): tid: 5769cf18  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 610338561 (0x24610701)  len: 1  bmap size: 1  flags: 0x0
Oper (6): tid: 5769cf18  len: 128  clientid: TRANS  flags: none
AGF Buffer: XAGF
ver: 1  seq#: 5  len: 15258464
root BNO: 1  CNT: 2
level BNO: 1  CNT: 1
1st: 0  last: 3  cnt: 4  freeblks: 2491090  longest: 581471
----------------------------------------------------------------------------
Oper (7): tid: 5769cf18  len: 28  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 610338568 (0x24610708)  len: 8  bmap size: 2  flags: 0x0
Oper (8): tid: 5769cf18  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (9): tid: 5769cf18  len: 28  clientid: TRANS  flags: none
BUF:  #regs: 3   start blkno: 610338576 (0x24610710)  len: 8  bmap size: 2  flags: 0x0
Oper (10): tid: 5769cf18  len: 128  clientid: TRANS  flags: none
BUF DATA
Oper (11): tid: 5769cf18  len: 256  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (12): tid: 5769cf18  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 8647474234504773632 (0x7802000000000000)  len: 1  bmap size: 1  flags: 0x0
Oper (13): tid: 5769cf18  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (14): tid: 5769cf18  len: 0  clientid: TRANS  flags: COMMIT
----------------------------------------------------------------------------
Oper (15): tid: 5769c5e8  len: 0  clientid: TRANS  flags: START
----------------------------------------------------------------------------
Oper (16): tid: 5769c5e8  len: 16  clientid: TRANS  flags: none
TRAN:    type: STRAT_WRITE       tid: 0       num_items: 5
----------------------------------------------------------------------------
Oper (17): tid: 5769c5e8  len: 2145656  clientid: TRANS  flags: none
**********************************************************************
* ERROR: data block=5255                                              *
**********************************************************************

We should have 5 more items in this transaction plus the commit
and then another 286 operations.  The operation number and transaction
id are correct but the length is bogus.  The first item in a STRAT_WRITE
transaction should be an inode and the length should be 56.

Tim, does this ring any bells with you?

The only validation we do on the length is an ASSERT in
xlog_recover_process_data() which isn't much good here.  I don't know
why the value is wrong but we can do better than crashing the system.
I would like to know how much more data is corrupt beyond this point.

Peter, can you try xfs_logprint -c ...?


Timothy Shimmin wrote:
> Hi Peter,
> 
> FYI
> 
> Just a couple of things in case you weren't aware.
> Often it is simplest to save the log using the -C option to a file.
>        -C filename
>               Copy the log from the filesystem to the file filename.
>               The log itself is not printed.
> The log can then be analysed in various ways later.
> 
> Running logprint in operation mode (the default mode without options)
> (non-transaction mode without -t)
> is really pretty useless without the -s option.
> If you use the -s option then one needs to know where to seek to
> (you can use -t to find the head/tail or -d to see where log records 
> start).
> The problem here is that if you do logprint
> like this (no options) then it will start at offset zero and will 
> invariably have
> trouble decoding if the log has wrapped around (the general case) as
> you'll start in the middle of a record.
> So the -t option is often a more interesting starting point as it
> will operate more like the file system recovery does, finding the head 
> and tail,
> and processing from the tail to the head of the log.
> 
> If you want to save the filesystem away for possible metadata debugging 
> later,
> then xfs_metadump is your friend.
> 
> Cheers,
> Tim.
> 
> KELEMEN Peter wrote:
>> * Lachlan Mcilroy (lachlan@sgi.com) [20071203 14:24]:
>>
>> Lachlan,
>>
>>> Okay, sounds like it might be a corrupt log.
>>
>> Yep.
>>
>>> Can you run xfs_logprint on the device or saved log?
>>
>> Sure.
>>
>> http://cern.ch/fuji/lxfsre1103/xfs_logprint1.txt.bz2
>> It aborted though, with the following message:
>>
>>     xfs_logprint: unknown log operation type (343b)
>>     Bad data in log
>>
>>> Also give xfs_logprint -t -i a go.
>>
>> http://cern.ch/fuji/lxfsre1103/xfs_logprint2.txt.bz2
>>
>>> You've saved the log into a file?  You can get the filesystem
>>> mounted again by deleting the log with xfs_repair -L <dev>.
>>> You'll probably need to run xfs_repair over the filesystem to be
>>> safe.
>>
>> I conserved this filesystem away for further analysis, I'm not
>> sure how helpful it can be.
>>
>> Thanks,
>> Peter
>>
> 
> 
> 
