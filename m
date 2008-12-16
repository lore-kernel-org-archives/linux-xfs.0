Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBG6BQlk013622 for <xfs@oss.sgi.com>; Tue, 16 Dec 2008 00:11:27 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FC55173A227
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 22:11:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id PxImdrTKBDoT3tAz for <xfs@oss.sgi.com>;
	Mon, 15 Dec 2008 22:11:25 -0800 (PST)
Message-ID: <4947466D.7000705@sandeen.net>
Date: Tue, 16 Dec 2008 00:10:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix corruption case for block size < page size
References: <49435F35.40109@sandeen.net> <4943FCD7.2010509@sandeen.net>
	<494735D9.8020809@sgi.com> <49473F5C.3070308@sandeen.net>
	<49474530.2080809@sgi.com>
In-Reply-To: <49474530.2080809@sgi.com>
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

Lachlan McIlroy wrote:
> Eric Sandeen wrote:
>> Actually; after the truncate down step (3) we should have:
>>
>>      |<--------trunc-----------------------
>> 3: |11??|                                       trunc down to 1/2 block
>>      ^
>>      |
>>     EOF
>>
>> Hm, but does the end of this block get zeroed now or only when we
>> subsequently extend the size?  The latter I think...?
> Only when extending the file size.

Right.

>> So I think in the next step:
>>
>>  trunc-->|
>> 4: |1100|                                        trunc up to block+1byte
>>       ^^
>>   now || this part of the block gets zeroed, right, by xfs_zero_eof?
> Yes (by xfs_zero_last_block()).

Right.  :)  But I *think* that after this step we are actually zeroing
into block 1 (2nd block) and causing it to get zeroed/mapped.  Off by
one maybe?

>>> Because of the truncate to 256 bytes
>>> only the first block is allocated and everything beyond 512 bytes is
>>> a hole.  
>> Yep, up until the last write anyway.
>>
>>> More specifically there is a hole under the remainder of the
>>> page so xfs_zero_eof() will skip that region and not zero anything.
>> Well, the last write (step 5) is still completely within the page...
>>
>> Right, that's what it *should* be doing; but in page_state_convert (and
>> I'll admit to not having this 100% nailed down) we write block 1 and map
>> blocks 2 & 3 back into the file, and get:
>>
>> # |1100|0000|1111|1111|2222|----|----|----|
>>              ^^^^ ^^^^
>> where these  |||| |||| blocks are stale data, and block 1 is written
>> (but at least zeroed).  How block 1 got zeroed I guess I'm not quite
> I think block 1 got zeroed during the last write because the file size
> was extended from 513 to 2048.  Byte 513 is just inside block 1.  But
> that block should have been a hole and xfs_zero_last_block() should
> have skipped it.

I think the 2nd extending write does skip it but from a bit more looking
the first extending truncate might step into it by one... still looking
into that.

>> certain yet.  But it does not appear that blocks 2 and 3 get *written*
>> any time other than step 1; blktrace seems to confirm this.  block 1
>> does get written, and 0s are written.  (But I don't think this block
>> ever should get written either; EOF landed there but only via truncate,
>> not a write).
> Agree.
> 
>> Crap, now you've got me slightly confused again, and I'll need to look a
>> bit more to be sure I'm 100% clear on what's getting zeroed and when vs.
>> what's getting mapped and why.  :)
> That makes two.

:)

> Something else to consider is that there may be allocated blocks
> entirely beyond eof due to speculative allocation.  This means that just
> because a block within a page is beyond eof does not mean it covers a
> hole.  This is why xfs_zero_eof() looks for blocks to zero between the
> old eof and the new eof.

true... yeah, my test may yet be a bit naiive.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
