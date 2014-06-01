Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E69D7F87
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 20:22:44 -0500 (CDT)
Message-ID: <538A8064.2030304@sgi.com>
Date: Sat, 31 May 2014 20:22:44 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/7] xfs: add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
References: <1378132151-2685-1-git-send-email-linkinjeon@gmail.com>
	<53850F92.7010401@sgi.com> <20140527225138.GD8554@dastard>
	<53851836.2070301@sgi.com> <20140528002906.GH8554@dastard>
	<538743E0.70103@sgi.com> <20140531003918.GI14410@dastard>
In-Reply-To: <20140531003918.GI14410@dastard>
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

On 05/30/14 19:39, Dave Chinner wrote:
> On Thu, May 29, 2014 at 09:27:44AM -0500, Mark Tinguely wrote:
>> On 05/27/14 19:29, Dave Chinner wrote:
>>> On Tue, May 27, 2014 at 05:56:54PM -0500, Mark Tinguely wrote:
>>>> A 7-8 hours on spinning rust. This is my burn in test.
>>>
>>> Can you try to narrow the problem down? Otherwise it's going to be a
>>> case of looking for a needle in a haystack....
>>
>> Nod on the needle in a hay stack if it bmbt is really corrupt.
>>
>> I am running fsstress from xfstests with the top commit 9b7f704, and
>> I don't see any newer fsstress patches since then.
>>
>> I moved the test to another box with a kdump that works on top of
>> tree Linux and grabbed a vmcore. I grabbed a metadata dump of the
>> filesystem after the ASSERT. That should give some idea of what
>> inode/block it was looking up.
>>
>> I sent email to Namjae when I first tripped over this problem in
>> late April. No longer on the face of the earth and I can't look at
>> this until the weekend.
>
> No worries - it looks pretty hard to hit, so it's not something we
> urgently need to track down. Any time you can spare to try to narrow
> it down would be great!
>
> Cheers,
>
> Dave.

The xfs_inode thinks there are 11 bmbt entries when there should only be 11:
   i_df = {
     if_bytes = 0xb0,              <- here 11 entries 0x10 bytes long
     if_real_bytes = 0x100,
     if_broot = 0xffff88009f74c680,
     if_broot_bytes = 0x28,
     if_flags = 0x6,
     if_u1 = {
       if_extents = 0xffff88033c44a000,  <-
       if_ext_irec = 0xffff88033c44a000,
       if_data = 0xffff88033c44a000 ""
     },

Looking at the if_extents[]:

crash> rd ffff88033c44a000 32
ffff88033c44a000:  8000000000000200 000000b601800021   ........!.......
ffff88033c44a010:  0000000000004400 000000449a000007   .D..........D...
ffff88033c44a020:  0000000000005200 000002f897e00004   .R..............
ffff88033c44a030:  8000000000005a00 000002f898600033   .Z......3.`.....
ffff88033c44a040:  000000000000c000 000002f89ec00001   ................
ffff88033c44a050:  0000000000015c00 000005fdfba00010   .\..............
ffff88033c44a060:  0000000000017c00 00000eab00400006   .|........@.....
ffff88033c44a070:  000000000001f800 00000ec752c00004   ...........R....
ffff88033c44a080:  0000000000020000 00000e8ae6800004   ................
ffff88033c44a090:  0000000000020800 00000e7167e00004   ...........gq...
ffff88033c44a0a0:  000000000002bfff ffffffc000a00001   ................
                        ^^^^ bad  ^^^^
It appears that current_ext is 10 (11th entry).
The assert is on the bad entry.

xfs_db thinks there are 11 entries:

recs[1-11] = [startoff,startblock,blockcount,extentflag] 
1:[1,372748,33,1] 2:[34,140496,18,0] 3:[52,1557619,53,1] 
4:[105,1557672,27,0] 5:[132,1557699,51,1] 6:[183,1557750,1,0] 
7:[261,3141597,16,0] 8:[277,7690242,6,0] 9:[339,7748246,4,0] 
10:[343,7624500,4,0] 11:[347,7572287,4,0]

xfs_db> fsb 4262789
xfs_db> type text
xfs_db> p
000:  42 4d 41 50 00 00 00 0b ff ff ff ff ff ff ff ff  BMAP............
010:  ff ff ff ff ff ff ff ff 80 00 00 00 00 00 02 00  ................
020:  00 00 00 b6 01 80 00 21 00 00 00 00 00 00 44 00  ..............D.
030:  00 00 00 44 9a 00 00 12 80 00 00 00 00 00 68 00  ...D..........h.
040:  00 00 02 f8 8e 60 00 35 00 00 00 00 00 00 d2 00  .......5........
050:  00 00 02 f8 95 00 00 1b 80 00 00 00 00 01 08 00  ................
060:  00 00 02 f8 98 60 00 33 00 00 00 00 00 01 6e 00  .......3......n.
070:  00 00 02 f8 9e c0 00 01 00 00 00 00 00 02 0a 00  ................
080:  00 00 05 fd fb a0 00 10 00 00 00 00 00 02 2a 00  ................
090:  00 00 0e ab 00 40 00 06 00 00 00 00 00 02 a6 00  ................
0a0:  00 00 0e c7 52 c0 00 04 00 00 00 00 00 02 ae 00  ....R...........
0b0:  00 00 0e 8a e6 80 00 04 00 00 00 00 00 02 b6 00  ................
0c0:  00 00 0e 71 67 e0 00 04 00 00 00 00 00 00 00 00  ...qg...........
0d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
0e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

This xfs_db is before log replay, but it appears that the 3 extent is
missing in the data fork, everything shifted up and a garbage entry in 
entry 11.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
