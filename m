Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 17:34:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k960YfaG008047
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 17:34:43 -0700
Date: Fri, 6 Oct 2006 10:33:39 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: several messages
Message-ID: <20061006003339.GF19345@melbourne.sgi.com>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal> <451A618B.5080901@agami.com> <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal> <20061002223056.GN4695059@melbourne.sgi.com> <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal> <1159893642.5592.12.camel@lade.trondhjem.org> <Pine.LNX.4.64.0610051108140.9190@madrid.max-t.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0610051108140.9190@madrid.max-t.internal>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, nfs@lists.sourceforge.net, Shailendra Tripathi <stripathi@agami.com>

On Thu, Oct 05, 2006 at 11:39:45AM -0400, Stephane Doyon wrote:
> 
> I hadn't realized that the issue isn't just with the final flush on 
> close(). It's actually been flushing all along, delaying some of the 
> subsequent write()s, getting NOSPC errors but not reporting them until the 
> end.

Other NFS clients will report an ENOSPC on the next write() or close()
if the error is reported during async writeback. The clients that typically
do this throw away any unwritten data as well on the basis that the
application was returned an error ASAP and it is now Somebody Else's
Problem (i.e. the application needs to handle it from there).

> I understand that since my application did not request any syncing, the 
> system cannot guarantee to report errors until cached data has been 
> flushed. But some data has indeed been flushed with an error; can't this 
> be reported earlier than on close?

It could, but...

> Would it be incorrect for a subsequent write to return the error that 
> occurred while flushing data from previous writes? Then the app could 
> decide whether to continue and retry or not. But I guess I can see how 
> that might get convoluted.

.... there's many entertaining hoops to jump through to do this
reliably.

FWIW, these are simply two different approaches to handling ENOSPC
(and other server) errors.  Mostly it comes down to how the ppl who
implemented the NFS client think it's best to handle the errors in
the scenarios that they most care about.

For example: when you have large amounts of cached data, expedient
error reporting and tossing unwritten data leads to much faster
error recovery than trying to write every piece of data (hence the
Irix use of this method).

OTOH, when you really want as much of the data to get to the server,
regardless of whether you lose some (e.g.  log files) before
reporting an error then you try to write every bit of data before
telling the application.

There's no clear right or wrong approach here - both have their
advantages and disadvantages for different workloads. If it
weren't for the sub-optimal behaviour of XFS in this case, you
probably wouldn't have even cared about this....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
