Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D44CD8032
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 23:55:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 673DBAC002
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 21:55:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ni68BcFW89ogfGED for <xfs@oss.sgi.com>;
	Sun, 03 Mar 2013 21:55:04 -0800 (PST)
Date: Mon, 4 Mar 2013 16:55:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible fsync02() xfs slowness regression on power7
Message-ID: <20130304055502.GP23616@dastard>
References: <220575861.7590457.1362129618880.JavaMail.root@redhat.com>
	<1601552351.8516567.1362371006444.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1601552351.8516567.1362371006444.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Mar 03, 2013 at 11:23:26PM -0500, CAI Qian wrote:
> 
> > > And this commit in 3.9-rc1:
> > > 
> > > a1e16c2 xfs: limit speculative prealloc size on sparse files
> > > should fix the problem. Please confirm these commits are the cause
> > > and the fix respectively....
> Confirmed this fixed the problem. I'd like to request this to be back-ported
> to stable-3.0, stable-3.4 and stable-3.8. What do you think?

IMO, no, it is not a backport candidate.  The patch has quite a few
dependencies, and at least for 3.0 xfs_bmapi_read() doesn't exist
and hence is not a trivial backport.

Further, it's take 2 years for this to be noticed, and you haven't
explained why the problem exists on your power machine and not any
others that it has been tested on. And there's been very few
complaints about performance of such workloads over the past 2
years, so either the workload is not important or only your power7
machine is having problems.

Hence I don't see any need to back port it - it's not a critical fix
and very few people see the problem so there's no real need to do
the backport.  Maybe someone else has the time and resources to
waste on backporting non-critical fixes to stable kernels, but I
don't....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
