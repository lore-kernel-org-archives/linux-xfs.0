Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 16:40:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0J0eCl4009114
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 16:40:15 -0800
Date: Sat, 19 Jan 2008 11:40:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
Message-ID: <20080119004018.GH155407@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Fri, Jan 18, 2008 at 09:50:37AM -0800, Mark Magpayo wrote:
> > > So is this all I need then prior to an xfs_repair?:
> > >
> > > > # for i in `seq 0 1 63`; do
> > > > > xfs_db -x -c "sb $i" -c 'write agcount 64' -c 'write dblock
> > 4761733120'
> > > > /dev/vg0/lv0
> > 
> > Yes, I think that is all that is necessary (that+repair was what fixed
> > the problem at the customer site successfully).
> > 
> 
> Is this supposed to be the proper output to the command above?
> 
> purenas:~# for i in `seq 0 1 63`; do xfs_db -x -c "sb $i" -c 'write
> agcount 64' -c 'write dblock 4761733120' /dev/vg0/lv0; done
> agcount = 64
> field dblock not found
> parsing error

Ah - As eric pointed out, that should be "dblocks".

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
