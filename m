Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 16:14:01 -0800 (PST)
Received: from smtp110.mail.mud.yahoo.com (smtp110.mail.mud.yahoo.com [209.191.85.220])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P0Dpqw022950
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 16:13:52 -0800
Message-ID: <45B7F5F9.2070308@yahoo.com.au>
Date: Thu, 25 Jan 2007 11:12:41 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com>
In-Reply-To: <20070124224654.GN33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

David Chinner wrote:
> On Thu, Jan 25, 2007 at 12:43:23AM +1100, Nick Piggin wrote:

>>And why not just leave it in the pagecache and be done with it?
> 
> 
> because what is in cache is then not coherent with what is on disk,
> and a direct read is supposed to read the data that is present
> in the file at the time it is issued. 

So after a writeout it will be coherent of course, so the point in
question is what happens when someone comes in and dirties it at the
worst possible moment? That relates to the paragraph below...

>>All you need is to do a writeout before a direct IO read, which is
>>what generic dio code does.
> 
> 
> No, that's not good enough - after writeout but before the
> direct I/O read is issued a process can fault the page and dirty
> it. If you do a direct read, followed by a buffered read you should
> get the same data. The only way to guarantee this is to chuck out
> any cached pages across the range of the direct I/O so they are
> fetched again from disk on the next buffered I/O. i.e. coherent
> at the time the direct I/O is issued.

... so surely if you do a direct read followed by a buffered read,
you should *not* get the same data if there has been some activity
to modify that part of the file in the meantime (whether that be a
buffered or direct write).

>>but in that case you'll either have to live with some racyness
>>(which is what the generic code does), or have a higher level
>>synchronisation to prevent buffered + direct IO writes I suppose?
> 
> 
> The XFS inode iolock - direct I/O writes take it shared, buffered
> writes takes it exclusive - so you can't do both at once. Buffered
> reads take is shared, which is another reason why we need to purge
> the cache on direct I/O writes - they can operate concurrently
> (and coherently) with buffered reads.

Ah, I'm glad to see somebody cares about doing the right thing ;)
Maybe I'll use XFS for my filesystems in future.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
