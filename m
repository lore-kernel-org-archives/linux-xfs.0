Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBG64mI6012422 for <xfs@oss.sgi.com>; Tue, 16 Dec 2008 00:04:48 -0600
Message-ID: <49474530.2080809@sgi.com>
Date: Tue, 16 Dec 2008 17:05:36 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix corruption case for block size < page size
References: <49435F35.40109@sandeen.net> <4943FCD7.2010509@sandeen.net>
	<494735D9.8020809@sgi.com> <49473F5C.3070308@sandeen.net>
In-Reply-To: <49473F5C.3070308@sandeen.net>
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
>> I'm still working through this Eric so I don't fully understand what's 
>> going on.
>>
>> It looks to me like the region was never zeroed at all.  In
>> xfs_zero_last_block() we only zero up to the end of the last block
>> (hence the name) but if the last page extends beyond that last
>> block we wont zero that extra space in the page.  If that remaining
>> space in the page sits over a hole then xfs_zero_eof() wont zero it
>> either.
> 
> So the testcase steps are (8 blocks per page here).
> 
> 1: |1111|1111|1111|1111|1111|1111|1111|1111|     write 1's
> 
> 2: |RRRR|1111|1111|1111|1111|1111|1111|1111|     mapread first block
> 
>      |<--------trunc-----------------------
> 3: |1100|                                        trunc down to 1/2 block
> 
>  trunc-->|
> 4: |1100|                                        trunc up to block+1byte
> 
> 5: |    |    |    |    |2222|                    write 2's (extending)
> 
> And we get:
> 
> # |1100|0000|1111|1111|2222|----|----|----|
> 
> But we should get:
> 
> # |1100|HHHH|HHHH|HHHH|2222|----|----|----|
> 
> (where "H" means hole)
> 
> So no, the data for blocks 1,2,3 is never zeroed, nor should it be, I
> think - we never partially write those blocks.  And the stale 1's coming
> through in blocks 2 & 3 are not the result of non-zero buffer heads
> getting written to disk in the last stage; they are simply stale disk
> blocks from the first step mapped back into the file.  (They were
> originally written as 1's in the first step.)
Okay, it's making sense now.  I've actually fixed this same problem on
IRIX and our CXFS clients on solaris, osx and windows but in all those
cases when a page is dirty the whole page is dirty so needs to be
zeroed.  With the individual states of the buffer heads we can remap
parts of pages that now cover holes.

> 
>> In your example above the last write extends the file size from 513
>> bytes to 2048 bytes.  In xfs_zero_last_block() we'll only zero from
>> 513 up to 1024 bytes (ie up to the end of the last block) but leave
>> the rest of the page untouched.  
> 
> Actually; after the truncate down step (3) we should have:
> 
>      |<--------trunc-----------------------
> 3: |11??|                                       trunc down to 1/2 block
>      ^
>      |
>     EOF
> 
> Hm, but does the end of this block get zeroed now or only when we
> subsequently extend the size?  The latter I think...?
Only when extending the file size.

> 
> So I think in the next step:
> 
>  trunc-->|
> 4: |1100|                                        trunc up to block+1byte
>       ^^
>   now || this part of the block gets zeroed, right, by xfs_zero_eof?
Yes (by xfs_zero_last_block()).

> 
>> Because of the truncate to 256 bytes
>> only the first block is allocated and everything beyond 512 bytes is
>> a hole.  
> 
> Yep, up until the last write anyway.
> 
>> More specifically there is a hole under the remainder of the
>> page so xfs_zero_eof() will skip that region and not zero anything.
> 
> Well, the last write (step 5) is still completely within the page...
> 
> Right, that's what it *should* be doing; but in page_state_convert (and
> I'll admit to not having this 100% nailed down) we write block 1 and map
> blocks 2 & 3 back into the file, and get:
> 
> # |1100|0000|1111|1111|2222|----|----|----|
>              ^^^^ ^^^^
> where these  |||| |||| blocks are stale data, and block 1 is written
> (but at least zeroed).  How block 1 got zeroed I guess I'm not quite
I think block 1 got zeroed during the last write because the file size
was extended from 513 to 2048.  Byte 513 is just inside block 1.  But
that block should have been a hole and xfs_zero_last_block() should
have skipped it.

> certain yet.  But it does not appear that blocks 2 and 3 get *written*
> any time other than step 1; blktrace seems to confirm this.  block 1
> does get written, and 0s are written.  (But I don't think this block
> ever should get written either; EOF landed there but only via truncate,
> not a write).
Agree.

> 
> Crap, now you've got me slightly confused again, and I'll need to look a
> bit more to be sure I'm 100% clear on what's getting zeroed and when vs.
> what's getting mapped and why.  :)
That makes two.

Something else to consider is that there may be allocated blocks
entirely beyond eof due to speculative allocation.  This means that just
because a block within a page is beyond eof does not mean it covers a
hole.  This is why xfs_zero_eof() looks for blocks to zero between the
old eof and the new eof.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
