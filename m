Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 14:55:48 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0MMtcrt013085
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 14:55:44 -0800
Received: from mail.purevideo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B3DFCCCADF
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 14:55:58 -0800 (PST)
Received: from mail.purevideo.com (mail.purevideo.com [208.50.29.149]) by cuda.sgi.com with ESMTP id 91SJXUzkq3DmRGsY for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 14:55:58 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Repairing a possibly incomplete xfs_growfs command?
Date: Tue, 22 Jan 2008 14:50:39 -0800
Message-ID: <9CE70E6ED2C2F64FB5537A2973FA4F02535970@pvn-3001.purevideo.local>
In-Reply-To: <479672B2.9070103@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local> <20080119004018.GH155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local> <20080122211311.GA155259@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253596F@pvn-3001.purevideo.local> <479672B2.9070103@sgi.com>
From: "Mark Magpayo" <mmagpayo@purevideo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
Of
> Mark Goodwin
> Sent: Tuesday, January 22, 2008 2:48 PM
> To: Mark Magpayo
> Cc: David Chinner; xfs@oss.sgi.com
> Subject: Re: Repairing a possibly incomplete xfs_growfs command?
> 
> 
> 
> Mark Magpayo wrote:
> >> -----Original Message-----
> >> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On
Behalf
> > Of
> >> David Chinner
> >> Sent: Tuesday, January 22, 2008 1:13 PM
> >> To: Mark Magpayo
> >> Cc: xfs@oss.sgi.com
> >> Subject: Re: Repairing a possibly incomplete xfs_growfs command?
> >>
> >> On Tue, Jan 22, 2008 at 11:40:52AM -0800, Mark Magpayo wrote:
> >>> Any ideas on how long the xfs_repair is supposed to take on 18TB?
I
> >>> started it Friday nite, and it's now Tuesday afternoon.  It's
stuck
> >>> here:
> >>>
> >>> Phase 5 - rebuild AG headers and trees...
> >>>         - reset superblock...
> >>> Phase 6 - check inode connectivity...
> >>>         - resetting contents of realtime bitmap and summary inodes
> >>>         - traversing filesystem ...
> >>>
> >>> I figure traversing a filesystem of 18TB takes a while, but does 4
> > days
> >>> sound right?
> >> Yes, it can if it's swapping like mad because you don't have enough
> >> RAM in the machine. Runtime is also detemrined by how many inodes
> > there
> >> are in the filesystem - do you know how many there are? Also, more
> >> recent xfs_repair versions tend to be faster - what version are you
> >> using again?
> >
> > Using version 2.9.4.  I may have forgotten to allocate more swap
space
> > (as was told in the manual given to me by the vendor), so would
breaking
> > out of the repair and restarting with more swap help out, or am I
too
> > deep (4 days) into it and should just let it run?
> 
> cat /proc/meminfo for this machine and post it here. If it's swapping,
> adding more swap wont speed it up. If it runs out of swap the repair
> will stop anyway ;-)

Here you go:

purenas:~# cat /proc/meminfo
MemTotal:      1019732 kB
MemFree:        580920 kB
Buffers:          1720 kB
Cached:          17912 kB
SwapCached:      21712 kB
Active:          44016 kB
Inactive:         8488 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:      1019732 kB
LowFree:        580920 kB
SwapTotal:    732574516 kB
SwapFree:     732548180 kB
Dirty:              12 kB
Writeback:           0 kB
Mapped:          36096 kB
Slab:            18016 kB
CommitLimit:  732778460 kB
Committed_AS:    55612 kB
PageTables:       1420 kB
VmallocTotal: 34359738367 kB
VmallocUsed:    358616 kB
VmallocChunk: 34359379631 kB


Nevermind my previous comment about turning on swap, looks like I had it
turned on afterall.  Any reason to think it may have stopped?  Or does
it just take that long to run?

Thanks,

Mark
