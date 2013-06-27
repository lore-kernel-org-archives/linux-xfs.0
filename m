Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BCB9A7F66
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 20:48:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5529EAC001
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 18:48:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IAF7IvZW25GeaPGK for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 18:48:14 -0700 (PDT)
Date: Thu, 27 Jun 2013 11:48:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sizing log - is there a too big?
Message-ID: <20130627014810.GA29790@dastard>
References: <55C24454-59E9-4285-9A4C-C4BD24EDBEEC@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C24454-59E9-4285-9A4C-C4BD24EDBEEC@gmail.com>
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

On Wed, Jun 26, 2013 at 04:56:31PM -0700, aurfalien wrote:
> Hi all,
> 
> Wondering if my log being just under 2GB is a bad idea.
> 
> Noticing flush-253:2/kcopyd which is my XFS file system getting
> really high load avg and wait times via top).

What has the log size got to do with something that is happening at
the block layer? What's your storage config?

> Doing a simple rsync over NFS and after a bit, the system gets to a load of 24.... yikes...

Let me guess - 24 nfsds blocked waiting for kcopyd to do it's stuff?

Load average going up when the NFS server is busy generally means
your IO subsystem is heavily loaded - it's not uncommon to see large
NFS servers that are extremely busy sustain load averages over a
100 (or even 1000) for hours/days on end....

> Upon killing the rsync, I am seeing loads going down to sub 1
> after about 10 min.  I have repeated this to verify 10 min.

Sure. Processes blocked on IO contribute to the load average. Kill
the IO load, and the load average will return to nothing in 10-15
minutes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
