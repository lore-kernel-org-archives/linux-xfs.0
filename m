Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBG4xFsG005960 for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 22:59:15 -0600
Message-ID: <494735D9.8020809@sgi.com>
Date: Tue, 16 Dec 2008 16:00:09 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix corruption case for block size < page size
References: <49435F35.40109@sandeen.net> <4943FCD7.2010509@sandeen.net>
In-Reply-To: <4943FCD7.2010509@sandeen.net>
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
> Eric Sandeen wrote:
>> On a 4k page system and 512-byte blocksize, this:
>>
>> xfs_io \
>> -c "pwrite -S 0x11 -b 4096 0 4096" \
>> -c "mmap -r 0 512" -c "mread 0 512" -c "munmap" \
>> -c "truncate 256" \
>> -c "truncate 513" \
>> -c "pwrite -S 0x22 -b 512 2048 512" \
>> -t -d -f testfile
> 
> Not to keep belaboring the point, but if anyone reviews this here's a
> bit more info.
> 
> If I blktrace the testcase it looks like this:
> 
> 8,16  0   1   0.000000000  4222  C   W 166979666 + 8 [0] 4k wr
> 8,16  0   2   0.000367043  4222  C   R 166979666 + 8 [0] 4k map rd
> 8,16  0   3   0.002923548  4222  C   N (35 00 ..) [0]
> 8,16  0   4   0.003108924  4222  C   W 200708307 + 9 [0] Log?(trunc)
> 8,16  0   5   0.020357902  4222  C   N (35 00 ..) [0]
> 8,16  0   6   0.020361434  4222  C   W 200708307 + 9 [0] Log?(trunc)
> 8,16  0   7   0.020745509  4222  C   W 166979666 + 1 [0] 512 wr @0
> 8,16  0   8   0.020940005  4222  C   W 166979667 + 1 [0] 512 wr @1
> 8,16  0   9   0.021172749  4222  C   W 166979670 + 1 [0] 512 wr @4
> 
> and a detailed look at the data on disk is this:
> 
> 00000000  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  Block 0(OK)
> *
> 00000100  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  Block 0...
> *
> 00000200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  Block 1(OK)
> *
> 00000400  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  Block 2(BAD)
> *
> 00000600  11 11 11 11 11 11 11 11  11 11 11 11 11 11 11 11  Block 3(BAD)
> *
> 00000800  22 22 22 22 22 22 22 22  22 22 22 22 22 22 22 22  Block 4(OK)
> *
> 00000a00
> 
> And the bmap information is this:
> 
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>    0: [0..4]:          56..60            0 (56..60)             5
> 
> So the bad data in blocks 2 and 3 were never rewritten; the buffer heads
> probably were fine (containing 0's, but I should check) and we simply
> re-mapped blocks 2 and 3 back into existence, along with their stale
> data, it seems.
> 
> So I think this was just a bad mapping decision, and not a buffer head
> state/zeroing problem...?
I'm still working through this Eric so I don't fully understand what's 
going on.

It looks to me like the region was never zeroed at all.  In
xfs_zero_last_block() we only zero up to the end of the last block
(hence the name) but if the last page extends beyond that last
block we wont zero that extra space in the page.  If that remaining
space in the page sits over a hole then xfs_zero_eof() wont zero it
either.

In your example above the last write extends the file size from 513
bytes to 2048 bytes.  In xfs_zero_last_block() we'll only zero from
513 up to 1024 bytes (ie up to the end of the last block) but leave
the rest of the page untouched.  Because of the truncate to 256 bytes
only the first block is allocated and everything beyond 512 bytes is
a hole.  More specifically there is a hole under the remainder of the
page so xfs_zero_eof() will skip that region and not zero anything.

> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
