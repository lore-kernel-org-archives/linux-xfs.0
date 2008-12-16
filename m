Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBG6LmRg014750 for <xfs@oss.sgi.com>; Tue, 16 Dec 2008 00:21:48 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9B79173A28A
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 22:21:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id LLQSAfd4yvXMSNuI for <xfs@oss.sgi.com>;
	Mon, 15 Dec 2008 22:21:46 -0800 (PST)
Message-ID: <494748FA.20404@sandeen.net>
Date: Tue, 16 Dec 2008 00:21:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix corruption case for block size < page size
References: <49435F35.40109@sandeen.net>
	<4943FCD7.2010509@sandeen.net>	<494735D9.8020809@sgi.com>
	<49473F5C.3070308@sandeen.net>	<49474530.2080809@sgi.com>
	<4947466D.7000705@sandeen.net>
In-Reply-To: <4947466D.7000705@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> Eric Sandeen wrote:
>>> Actually; after the truncate down step (3) we should have:
>>>
>>>      |<--------trunc-----------------------
>>> 3: |11??|                                       trunc down to 1/2 block
>>>      ^
>>>      |
>>>     EOF
>>>
>>> Hm, but does the end of this block get zeroed now or only when we
>>> subsequently extend the size?  The latter I think...?
>> Only when extending the file size.
> 
> Right.
> 
>>> So I think in the next step:
>>>
>>>  trunc-->|
>>> 4: |1100|                                        trunc up to block+1byte
>>>       ^^
>>>   now || this part of the block gets zeroed, right, by xfs_zero_eof?
>> Yes (by xfs_zero_last_block()).
> 
> Right.  :)  But I *think* that after this step we are actually zeroing
> into block 1 (2nd block) and causing it to get zeroed/mapped.  Off by
> one maybe?
> 
>>>> Because of the truncate to 256 bytes
>>>> only the first block is allocated and everything beyond 512 bytes is
>>>> a hole.  
>>> Yep, up until the last write anyway.
>>>
>>>> More specifically there is a hole under the remainder of the
>>>> page so xfs_zero_eof() will skip that region and not zero anything.
>>> Well, the last write (step 5) is still completely within the page...
>>>
>>> Right, that's what it *should* be doing; but in page_state_convert (and
>>> I'll admit to not having this 100% nailed down) we write block 1 and map
>>> blocks 2 & 3 back into the file, and get:
>>>
>>> # |1100|0000|1111|1111|2222|----|----|----|
>>>              ^^^^ ^^^^
>>> where these  |||| |||| blocks are stale data, and block 1 is written
>>> (but at least zeroed).  How block 1 got zeroed I guess I'm not quite
>> I think block 1 got zeroed during the last write because the file size
>> was extended from 513 to 2048.  Byte 513 is just inside block 1.  But
>> that block should have been a hole and xfs_zero_last_block() should
>> have skipped it.
> 
> I think the 2nd extending write does skip it but from a bit more looking
> the first extending truncate might step into it by one... still looking
> into that.

Gah; or not.  what is going on here...  Doing just steps 1, 2, 3, 4
(ending on the extending truncate):

# xfs_io -c "pwrite -S 0x11 -b 4096 0 4096" -c "mmap -r 0 512" -c "mread
0 512" -c "munmap" -c "truncate 256" -c "truncate 514" -t -d -f
/mnt/scratch/testfile

# xfs_bmap -v /mnt/scratch/testfile
/mnt/scratch/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..0]:          63..63            0 (63..63)             1
   1: [1..1]:          hole                                     1

It looks like what I expect, at this point.  But then:

# sync
# xfs_bmap -v /mnt/scratch/testfile
/mnt/scratch/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..1]:          63..64            0 (63..64)             2

Um, why'd that last block get mapped in?  mmap vs. direct IO I'm
guessing... w/o the mmap read this does not happen.

-Eric (heading to bed now...)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
