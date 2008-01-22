Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 11:46:58 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0MJkTJ5005676
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 11:46:30 -0800
Received: from mail.purevideo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93CFCCC6DDF
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 11:46:46 -0800 (PST)
Received: from mail.purevideo.com (mail.purevideo.com [208.50.29.149]) by cuda.sgi.com with ESMTP id VaeuUN2Hanmj9pxq for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 11:46:46 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Repairing a possibly incomplete xfs_growfs command?
Date: Tue, 22 Jan 2008 11:40:52 -0800
Message-ID: <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local>
In-Reply-To: <20080119004018.GH155407@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local> <20080119004018.GH155407@sgi.com>
From: "Mark Magpayo" <mmagpayo@purevideo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com


> -----Original Message-----
> From: David Chinner [mailto:dgc@sgi.com]
> Sent: Friday, January 18, 2008 4:40 PM
> To: Mark Magpayo
> Cc: David Chinner; xfs@oss.sgi.com
> Subject: Re: Repairing a possibly incomplete xfs_growfs command?
> 
> On Fri, Jan 18, 2008 at 09:50:37AM -0800, Mark Magpayo wrote:
> > > > So is this all I need then prior to an xfs_repair?:
> > > >
> > > > > # for i in `seq 0 1 63`; do
> > > > > > xfs_db -x -c "sb $i" -c 'write agcount 64' -c 'write dblock
> > > 4761733120'
> > > > > /dev/vg0/lv0
> > >
> > > Yes, I think that is all that is necessary (that+repair was what
fixed
> > > the problem at the customer site successfully).
> > >
> >
> > Is this supposed to be the proper output to the command above?
> >
> > purenas:~# for i in `seq 0 1 63`; do xfs_db -x -c "sb $i" -c 'write
> > agcount 64' -c 'write dblock 4761733120' /dev/vg0/lv0; done
> > agcount = 64
> > field dblock not found
> > parsing error
> 
> Ah - As eric pointed out, that should be "dblocks".
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group

Any ideas on how long the xfs_repair is supposed to take on 18TB?  I
started it Friday nite, and it's now Tuesday afternoon.  It's stuck
here:

Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...

I figure traversing a filesystem of 18TB takes a while, but does 4 days
sound right?

Thanks,

Mark
