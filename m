Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 17:18:44 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBK1IbD2010787
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 17:18:41 -0800
Received: from email.msoe.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99BE54A2146
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 17:18:50 -0800 (PST)
Received: from email.msoe.edu (email.msoe.edu [155.92.194.61]) by cuda.sgi.com with ESMTP id WzFE2NjOIvLQCRDR for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 17:18:50 -0800 (PST)
Date: Wed, 19 Dec 2007 19:18:48 -0600
From: "Jonathan C. Detert" <Jonathan.Detert@msoe.edu>
Subject: Re: mount prob: "log inconsistent or not a log"
Message-ID: <20071220011848.GV19770@msoe.edu>
References: <20071220000144.GQ19770@msoe.edu> <4769BD13.5040303@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4769BD13.5040303@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Timothy Shimmin <tes@sgi.com> [071219 18:53]:
> Hi Jonathan,
> 
> I'm not giving a high level view but
> in regards to the log message about the xfs log :)
> 
> Jonathan.Detert@msoe.edu wrote:
> >This is what /var/log/messages has to say about the mount attempt:
> >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> >Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS mounting filesystem sdb
> >Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: Log inconsistent or not 
> >a log (last==0, first!=1)

--snip --

> >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> >
> Every 512 bytes of the log is stamped with the cycle#.
> The cycle# is effectively the number of times the log has wrapped

-- snip --

> An "xfs_logprint -d /dev/sdb" will show what the cycle#s are
> and where the log records are. It might give an idea of the
> extent of the corruption.

Something occurred to me to point out:  the snapshot from yesterday has
the same problem.  How can that be?  Is is possible that the log has
been hosed for some time, and that the problem only reared its head now
because I had to remount?  I.e. is it possible for an xfs fs to be
mounted and used, even while the log is messed up?
-- 
Jon Detert
IT Systems Administrator, Milwaukee School of Engineering
1025 N. Broadway, Milwaukee, Wisconsin 53202, U.S.A.
--
"Most of the trouble in the world is caused by people wanting to be important."
~ T.S. Eliot
