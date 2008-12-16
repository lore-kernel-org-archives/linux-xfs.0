Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBG7rIKe022711 for <xfs@oss.sgi.com>; Tue, 16 Dec 2008 01:53:18 -0600
Message-ID: <49475EA6.6030302@sgi.com>
Date: Tue, 16 Dec 2008 18:54:14 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix corruption case for block size < page size
References: <49435F35.40109@sandeen.net> <4943FCD7.2010509@sandeen.net>
	<494735D9.8020809@sgi.com> <49473F5C.3070308@sandeen.net>
	<49474530.2080809@sgi.com> <4947466D.7000705@sandeen.net>
In-Reply-To: <4947466D.7000705@sandeen.net>
Reply-To: lachlan@sgi.com
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
To: Eric Sandeen <sandeen@sandeen.net>
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
I assumed that the zeroing would stop at the new file size.  This bit of 
code in xfs_zero_eof() should ensure that:

		if ((zero_off + zero_len) > offset)
			zero_len = offset - zero_off;

The truncate down eventually calls truncate_inode_pages_range() which
will zero the remainder of a page beyond eof.  This could be how block
1 is becoming dirty.  If I remember correctly there are checks in fsx
to ensure that when mmaping a file with a file size that is not page
aligned that the space in the last page beyond eof is all zeroes (a
POSIX requirement I think but only holds true on initial mapping since
the area can be modified by a user).  This has to be done somewhere
and may well be in the truncate down.

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
Yes, true since the new file size (513 bytes) is not fsb aligned then
the first byte in block 1 needs to be zeroed.  But this will only happen
if block 1 is allocated.  If it's a hole or an unwritten extent then it
will be skipped.

> 
>>> certain yet.  But it does not appear that blocks 2 and 3 get *written*
>>> any time other than step 1; blktrace seems to confirm this.  block 1
>>> does get written, and 0s are written.  (But I don't think this block
>>> ever should get written either; EOF landed there but only via truncate,
>>> not a write).
>> Agree.
>>
>>> Crap, now you've got me slightly confused again, and I'll need to look a
>>> bit more to be sure I'm 100% clear on what's getting zeroed and when vs.
>>> what's getting mapped and why.  :)
>> That makes two.
> 
> :)
> 
>> Something else to consider is that there may be allocated blocks
>> entirely beyond eof due to speculative allocation.  This means that just
>> because a block within a page is beyond eof does not mean it covers a
>> hole.  This is why xfs_zero_eof() looks for blocks to zero between the
>> old eof and the new eof.
> 
> true... yeah, my test may yet be a bit naiive.

I used this command to trigger the problem:
fsx -r 512 -w 512 -W -Z -p 1000 file

It mixes direct I/O with a mmap'ed reads.

1000 mapread    0x3800 thru     0x609c  (0x289d bytes)
2000 mapread    0x7600 thru     0x16d0e (0xf70f bytes)
READ BAD DATA: offset = 0x9a00, size = 0xa600, fname = file
OFFSET  GOOD    BAD     RANGE
0x aa00 0x0000  0x43fb  0x    0
operation# (mod 256) for the bad data may be 67
...
2126(78 mod 256): SKIPPED (no operation)
2127(79 mod 256): TRUNCATE UP   from 0xc580 to 0x26629
2128(80 mod 256): WRITE 0x2bc00 thru 0x35fff    (0xa400 bytes) HOLE
2129(81 mod 256): TRUNCATE DOWN from 0x36000 to 0x231be
2130(82 mod 256): MAPREAD       0x9e00 thru 0xd6f6      (0x38f7 bytes) 
***RRRR***
2131(83 mod 256): READ  0x9a00 thru 0x13fff     (0xa600 bytes)  ***RRRR***
Correct content saved for comparison
(maybe hexdump "file" vs "file.fsxgood")

At operation 2130 the data at offset 0xaa00 is okay but on the next
operation the data at that offset is now bad.

Your patch stops this failure but frankly I don't know why.  Zeroing to
the end of the page in xfs_zero_last_block() also prevents the failure
but now I'm not so sure that makes sense.

The '-f' option to fsx (if you're using the fsx from the XFSQA suite) is
supposed to flush and invalidate pages after write operations and force
them to be read in from disk.  This is very handy to find bugs in the
read path that would otherwise be disguised by the page cache.  But it
looks like msync(MS_INVALIDATE) doesn't work anymore - I'm not seeing 
any reads, weird.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
