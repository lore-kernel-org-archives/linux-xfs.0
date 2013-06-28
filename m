Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3C8A7F52
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 20:56:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC84230404E
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 18:56:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bQotofw5Rit8wGJB for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 18:56:14 -0700 (PDT)
Date: Fri, 28 Jun 2013 11:56:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sizing log - is there a too big?
Message-ID: <20130628015610.GH32195@dastard>
References: <55C24454-59E9-4285-9A4C-C4BD24EDBEEC@gmail.com>
	<20130627014810.GA29790@dastard>
	<73A9FC1C-854D-4C23-B560-FEEF64A3001B@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <73A9FC1C-854D-4C23-B560-FEEF64A3001B@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: aurfalien <aurfalien@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 27, 2013 at 08:58:06AM -0700, aurfalien wrote:
> 
> On Jun 26, 2013, at 6:48 PM, Dave Chinner wrote:
> 
> > On Wed, Jun 26, 2013 at 04:56:31PM -0700, aurfalien wrote:
> >> Hi all,
> >> 
> >> Wondering if my log being just under 2GB is a bad idea.
> >> 
> >> Noticing flush-253:2/kcopyd which is my XFS file system getting
> >> really high load avg and wait times via top).
> > 
> > What has the log size got to do with something that is happening at
> > the block layer? What's your storage config?
> > 
> >> Doing a simple rsync over NFS and after a bit, the system gets to a load of 24.... yikes...
> > 
> > Let me guess - 24 nfsds blocked waiting for kcopyd to do it's stuff?
> > 
> > Load average going up when the NFS server is busy generally means
> > your IO subsystem is heavily loaded - it's not uncommon to see large
> > NFS servers that are extremely busy sustain load averages over a
> > 100 (or even 1000) for hours/days on end....
> > 
> >> Upon killing the rsync, I am seeing loads going down to sub 1
> >> after about 10 min.  I have repeated this to verify 10 min.
> > 
> > Sure. Processes blocked on IO contribute to the load average. Kill
> > the IO load, and the load average will return to nothing in 10-15
> > minutes.
> 
> 
> Not so fast my fine feathered friend.
> 
> Same work load, same hardware.
> 
> Only diff is;
> 
> External log, its 2GB
> And its Centos 6.4 which was previously 5.9.

Oh, you're comparing behaviour between kernels 5 years in age
difference. Well, things change, and a change of load average for
the same workload between very different kernels is no unexpected.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
