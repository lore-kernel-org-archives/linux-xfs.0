Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 18:44:52 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBK2ii41016761
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 18:44:47 -0800
Received: from email.msoe.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53C92B7A5A3
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 18:44:56 -0800 (PST)
Received: from email.msoe.edu (email.msoe.edu [155.92.194.61]) by cuda.sgi.com with ESMTP id 9W87YsuhgGsQIpR7 for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 18:44:56 -0800 (PST)
Date: Wed, 19 Dec 2007 20:44:53 -0600
From: "Jonathan C. Detert" <Jonathan.Detert@msoe.edu>
Subject: Re: mount prob: "log inconsistent or not a log"
Message-ID: <20071220024453.GX19770@msoe.edu>
References: <20071220000144.GQ19770@msoe.edu> <4769BD13.5040303@sgi.com> <20071220011848.GV19770@msoe.edu> <20071220015425.GL4612@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220015425.GL4612@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

* David Chinner <dgc@sgi.com> [071219 19:59]:
> On Wed, Dec 19, 2007 at 07:18:48PM -0600, Jonathan C. Detert wrote:
> > * Timothy Shimmin <tes@sgi.com> [071219 18:53]:
> > > Hi Jonathan,

-- snip --

> > > Jonathan.Detert@msoe.edu wrote:
> > > >This is what /var/log/messages has to say about the mount attempt:
> > > >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> > > >Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS mounting filesystem sdb
> > > >Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: Log inconsistent or not 
> > > >a log (last==0, first!=1)
> > 
> > --snip --
> > 
> > > >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> > > >
> > > Every 512 bytes of the log is stamped with the cycle#.
> > > The cycle# is effectively the number of times the log has wrapped
> > 
> > -- snip --
> > 
> > > An "xfs_logprint -d /dev/sdb" will show what the cycle#s are
> > > and where the log records are. It might give an idea of the
> > > extent of the corruption.
> > 
> > Something occurred to me to point out:  the snapshot from yesterday has
> > the same problem.  How can that be?  Is is possible that the log has
> > been hosed for some time, and that the problem only reared its head now
> > because I had to remount?  I.e. is it possible for an xfs fs to be
> > mounted and used, even while the log is messed up?
> 
> No, it should not.
> 
> BTW, does "lost it's iSCSI connection" == "iSCSI server crashed"?

I'm not sure what you mean by 'iSCSI server'.  The linux 2.6.20
box (named 'quartz') is running the 'open-iscsi' 'iscsi initiator' software
(v2.0.730).  The ethernet cable connecting quartz to the iSCSI SAN switch
got accidentally removed while the SAN volume was mounted and in use as
/dev/sdb on quartz.  After the ethernet cable was reconnected, I was
unable to ls(1) the contents of the /dev/sdb's mountpoint.  So, I
rebooted quartz.  Incidentally, quartz had another SAN volume mounted as
/dev/sda, also with xfs on it, and it is able to mount /dev/sda just
fine.

> If so, is it possible that the iSCSI server is corrupted in some way?

if by that you mean the software that the iSCSI controller is running on
the iSCSI SAN hardware, then I suppose so.  I have a call into the
vendor on this already, and am waiting for a call-back.
-- 
Jon Detert
IT Systems Administrator, Milwaukee School of Engineering
1025 N. Broadway, Milwaukee, Wisconsin 53202, U.S.A.
--
"Music washes away from the soul the dust of everyday life."  Berthold Auerbach
