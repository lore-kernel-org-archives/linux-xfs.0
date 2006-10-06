Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 07:05:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k96E5baG014698
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 07:05:37 -0700
Date: Fri, 6 Oct 2006 09:25:28 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
In-Reply-To: <20061006003339.GF19345@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0610060903280.31641@madrid.max-t.internal>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
 <451A618B.5080901@agami.com> <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal>
 <20061002223056.GN4695059@melbourne.sgi.com> <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal>
 <1159893642.5592.12.camel@lade.trondhjem.org> <Pine.LNX.4.64.0610051108140.9190@madrid.max-t.internal>
 <20061006003339.GF19345@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: several messages
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, xfs@oss.sgi.com, nfs@lists.sourceforge.net, Shailendra Tripathi <stripathi@agami.com>

On Fri, 6 Oct 2006, David Chinner wrote:

> On Thu, Oct 05, 2006 at 11:39:45AM -0400, Stephane Doyon wrote:
>>
>> I hadn't realized that the issue isn't just with the final flush on
>> close(). It's actually been flushing all along, delaying some of the
>> subsequent write()s, getting NOSPC errors but not reporting them until the
>> end.
>
> Other NFS clients will report an ENOSPC on the next write() or close()
> if the error is reported during async writeback. The clients that typically
> do this throw away any unwritten data as well on the basis that the
> application was returned an error ASAP and it is now Somebody Else's
> Problem (i.e. the application needs to handle it from there).

Well the client wouldn't necessarily have to throw away cached data. It 
could conceivably be made to return ENOSPC on some subsequent write. It 
would need to throw away the data for that write, but not necessarily 
destroy its cache. It could then clear the error condition and allow the 
application to keep trying if it wants to...

>> Would it be incorrect for a subsequent write to return the error that
>> occurred while flushing data from previous writes? Then the app could
>> decide whether to continue and retry or not. But I guess I can see how
>> that might get convoluted.
>
> .... there's many entertaining hoops to jump through to do this
> reliably.

I imagine there would be...

> For example: when you have large amounts of cached data, expedient
> error reporting and tossing unwritten data leads to much faster
> error recovery than trying to write every piece of data (hence the
> Irix use of this method).

In my case, I didn't think I was caching that much data though, only a few 
hundred MBs, and I wouldn't have minded so much if an error had been 
returned after that much. The way it's implemented though, I can write an 
unbounded amount of data through that cache and not be told of the problem 
until I close or fsync. It may not be technically wrong, but given the 
outrageous delay I saw in my particular situation, it felt pretty 
suboptimal.

> There's no clear right or wrong approach here - both have their
> advantages and disadvantages for different workloads. If it
> weren't for the sub-optimal behaviour of XFS in this case, you
> probably wouldn't have even cared about this....

Indeed not! In fact, changing the client is not practical for me, what I 
need is a fix for the XFS behavior. I just thought it was also worth 
reporting what I perceived to be an issue with the NFS client.

Thanks
