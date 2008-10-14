Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 23:49:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E6nMJw029788
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:49:24 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B6AF130BDFA
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:51:04 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id KrefRvrr5AZuIli9 for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:51:04 -0700 (PDT)
Date: Tue, 14 Oct 2008 17:50:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 988255 - fix instant oops with tracing enabled
Message-ID: <20081014065049.GM10716@disturbed>
References: <20081014011747.AC14E58FA1E9@chook.melbourne.sgi.com> <20081014020556.GH10716@disturbed> <48F42F12.1010409@sgi.com> <20081014054103.GK10716@disturbed> <48F43838.9040606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F43838.9040606@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 14, 2008 at 05:12:08PM +1100, Timothy Shimmin wrote:
> Dave Chinner wrote:
> > On Tue, Oct 14, 2008 at 03:33:06PM +1000, Lachlan McIlroy wrote:
> >> Dave Chinner wrote:
> >>> On Tue, Oct 14, 2008 at 12:17:47PM +1100, Lachlan McIlroy wrote:
> >>>> fix instant oops with tracing enabled
> >>>>
> >>>> We can only read inode->i_count if the inode is actually there and not
> >>>> a NULL pointer.  This was introduced in one of the recent sync patches.
> >>>>
> >>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >>> BTW, this now means that other pending patches won't apply cleanly....
> >>>
> >> Yeah this patch hunk didn't apply but was easy to hand merge.  It also
> >> didn't compile because of a missing comma from the 4th last line.  Can
> >> you please make sure each of your patch series compile on their own?
> > 
> > I do make sure every patch compiles given the config options a
> > mainline kernel allows. However, the CONFIG_XFS_TRACE option is not
> > present in mainline-derived kernels so it's not obvious when
> > problems occur inside code that isn't easily configurable on
> > such a kernel....
> > 
> > As it is, I haven't done a CONFIG_XFS_TRACE build for several months
> > because I've found that I haven't needed tracing to find problems
> > esoteric problems. Using watchpoints, breakpoints and single
> > stepping catches problems as they occur rather than needing tracing
> > to try to work out what went wrong after a problem has occurred.
> > 
> OOI, can anyone comment on any suggestions for other tracing mechanisms.
> I recall Christoph mentioning something in the past but it wasn't
> ready yet or something???.

Well, I'd suggest that we probably should turn all the trace points
into markers so that systemtap can hook them and you can write
probes to extract the traces in real-time....

> I'd really like to be able to access tracing output via proc
> instead of just within kdb,
> as I have used in the past with Greg Banks qtrace patches.

Perhaps extending something like:

Documentation/ftrace.txt

would be the appropriate way to go to acheive this.

I think in the past Christoph has suggested switching the ktrace
code over a relayfs mechanism and providing a userspace decoder
would allow both kdb and userspace to access the same traces...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
