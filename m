Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 15:41:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MMeunv027489
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 15:40:56 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17C8D12C3CE1
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 15:42:38 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id SkfrfmqAlTPEEs6W for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 15:42:38 -0700 (PDT)
Date: Thu, 23 Oct 2008 09:42:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27.[0,2] problems (v. 2.6.26.5): Samba & root-read-only
Message-ID: <20081022224235.GW18495@disturbed>
References: <48FED90F.7030809@tlinx.org> <20081022223005.GV18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022223005.GV18495@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Oct 23, 2008 at 09:30:05AM +1100, Dave Chinner wrote:
> On Wed, Oct 22, 2008 at 12:41:03AM -0700, Linda Walsh wrote:
> > I am having to stay at 2.6.26.5 for now on my main home server.
> >
> > Going to 2.6.27 (and just trying 2.6.27.2), I'm have two VERY weird (would
> > appear to be user-land probs from symptoms), problems. 
> >
> > 1) Samba -- the system is a Samba domain controller.  When I boot using
> > the 2.6.27.2 kernel (or .0 before), I can no longer mount any file systems
> > from my windows client. 
> .....
> >
> > 2) My root disk comes up READ-ONLY.  It uses XFS.  I am NOT able to remount
> > read/write (mount -o remount,rw /, fails writing to Read-only /etc/mtab,
> > mount -n -o remount,rw doesn't give an error message, but doesn't make the
> > drive R/W.  Root fs is on an adaptec FAST-SCSI (80MB/s) with an 18MB Seagate
> > (root, disk is oldest disk on the system). 
> 
> That XFS problem should be fixed in 2.6.27.3, whenever that is going
> to be released. It was sent and ACK'd by the stable team a week ago,
> but for some reason missed 2.6.27.2.

2.6.27.3 was released as I was writing this, so the fix is available
now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
