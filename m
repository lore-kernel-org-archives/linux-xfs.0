Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 06:15:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8CDFgFJ030519
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 06:15:42 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A638433071
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 06:17:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id PnHak3uvdJl2vLXi for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 06:17:11 -0700 (PDT)
Message-ID: <48CA6BD8.8000009@sandeen.net>
Date: Fri, 12 Sep 2008 08:17:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Re-dirty pages on I/O error
References: <48C8D8CD.7050508@sgi.com> <20080911103342.GA17482@infradead.org> <48C98BE4.3000309@sandeen.net> <48CA0FD8.6010904@sgi.com>
In-Reply-To: <48CA0FD8.6010904@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> On Thu, Sep 11, 2008 at 06:37:33PM +1000, Lachlan McIlroy wrote:
>>>> If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
>>>> we throw away the dirty page without converting the delayed allocation.  This
>>>> leaves delayed allocations that can never be removed and confuses code that
>>>> expects a flush of the file to clear them.  We need to re-dirty the page on
>>>> error so we can try again later or report that the flush failed.
>>>>
>>>> --- a/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 16:32:11.000000000 +1000
>>>> +++ b/fs/xfs/linux-2.6/xfs_aops.c	2008-09-11 15:44:09.000000000 +1000
>>>> @@ -1147,16 +1147,6 @@ error:
>>>> 	if (iohead)
>>>> 		xfs_cancel_ioend(iohead);
>>>>
>>>> -	/*
>>>> -	 * If it's delalloc and we have nowhere to put it,
>>>> -	 * throw it away, unless the lower layers told
>>>> -	 * us to try again.
>>>> -	 */
>>>> -	if (err != -EAGAIN) {
>>>> -		if (!unmapped)
>>>> -			block_invalidatepage(page, 0);
>>>> -		ClearPageUptodate(page);
>>>> -	}
>>> While this always looked fishy to me we it needs a good explanation to
>>> kill this.  I try to remember why Steve did it this way long time ago.
>> Hrm some of that was my fault, ages ago.
>>
>> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/pagebuf/Attic/page_buf_io.c.diff?r1=1.2;r2=1.3;hideattic=0
> That revision history doesn't match the ptools history - probably cause the
> file no longer exists.  Anyway it looks like the hack was mostly there before
> your change.

Before my change it just cleared the delalloc flag....

>> I don't remember the details fo why.... ah here's a clue
>>
>> http://oss.sgi.com/archives/xfs/2002-01/msg00475.html
> Geez, that's so long ago that I doubt it's still an issue.  So it sounds
> like this hack was added to prevent further issues after a forced shutdown
> has already occurred.  If we leave this hack in there's a good chance it
> will cause a forced shutdown.

I'm not arguing to keep it, just trying to figure out where it's from :)

>>> As _xfs_force_shutdown was written, it tried to schedule in an interrupt context
>>> and caused a BUG() to be thrown.
>>> Also, even if we didn't try to deal with leftover buffers in the interrupt,
>>> they subsequently had their delalloc flags removed, and thus queued up
>>> to clobber block 0 (1,2,3) on the disk, thus corrupting the filesystem.
>> so back then, delalloc buffers w/o a home would eventually slam into the
>> superblock, I guess.
> Really?  How do you figure?  Delayed allocations have a special block
> number of -1.  When that is converted to the physical disk address it
> should end up beyond the end of the volume.

Well, I don't remember how things worked back in 2002 for sure, but
pretty sure the net result was that we simply cleared the delalloc page
on the flag, and it eventually came out at block 0.  Back then.  A lot
has changed since!

-Eric
