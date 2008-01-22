Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 13:52:37 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0MLqUIF001351
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 13:52:33 -0800
Received: from mail.purevideo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5B65CC8451
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 13:52:46 -0800 (PST)
Received: from mail.purevideo.com (mail.purevideo.com [208.50.29.149]) by cuda.sgi.com with ESMTP id jloJReMGNVH7SWus for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 13:52:46 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Repairing a possibly incomplete xfs_growfs command?
Date: Tue, 22 Jan 2008 13:46:56 -0800
Message-ID: <9CE70E6ED2C2F64FB5537A2973FA4F0253596F@pvn-3001.purevideo.local>
In-Reply-To: <20080122211311.GA155259@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local> <20080119004018.GH155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local> <20080122211311.GA155259@sgi.com>
From: "Mark Magpayo" <mmagpayo@purevideo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com


> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
Of
> David Chinner
> Sent: Tuesday, January 22, 2008 1:13 PM
> To: Mark Magpayo
> Cc: xfs@oss.sgi.com
> Subject: Re: Repairing a possibly incomplete xfs_growfs command?
> 
> On Tue, Jan 22, 2008 at 11:40:52AM -0800, Mark Magpayo wrote:
> > Any ideas on how long the xfs_repair is supposed to take on 18TB?  I
> > started it Friday nite, and it's now Tuesday afternoon.  It's stuck
> > here:
> >
> > Phase 5 - rebuild AG headers and trees...
> >         - reset superblock...
> > Phase 6 - check inode connectivity...
> >         - resetting contents of realtime bitmap and summary inodes
> >         - traversing filesystem ...
> >
> > I figure traversing a filesystem of 18TB takes a while, but does 4
days
> > sound right?
> 
> Yes, it can if it's swapping like mad because you don't have enough
> RAM in the machine. Runtime is also detemrined by how many inodes
there
> are in the filesystem - do you know how many there are? Also, more
> recent xfs_repair versions tend to be faster - what version are you
> using again?

Using version 2.9.4.  I may have forgotten to allocate more swap space
(as was told in the manual given to me by the vendor), so would breaking
out of the repair and restarting with more swap help out, or am I too
deep (4 days) into it and should just let it run?

-Mark
 
