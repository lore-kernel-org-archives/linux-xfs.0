Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p652mxLm214199 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 21:49:00 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 118F215E9BB4
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 19:48:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KgC52tZ742XPOOS9 for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 19:48:58 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.72)
	(envelope-from <david@fromorbit.com>) id 1Qdvh1-0004v9-Oo
	for xfs@oss.sgi.com; Tue, 05 Jul 2011 12:48:55 +1000
Date: Tue, 5 Jul 2011 12:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Updated xfsprogs 2.6.38 merge
Message-ID: <20110705024855.GA561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Folks,

I pushed out an updated 2.6.38 kernel merge to xfsprogs patchset a
couple of days ago. I've been doing quite a bit of testing on it,
both 32 bit and 64 bit, with 512 byte, 1k and 4k block size
filesystems and I haven't come across any regressions. The patchset
can be found here:

  git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev kernel-2.6.38-sync

It's pretty much unchanged from the last set of patches I sent,
except for one minor fix to the radix tree code for an off by one in
the path array size for item and tag deletes.

I'm pretty much ready to commit this update so I can then move
forward with updating it to the 3.0 kernel code base as a smaller
incremental series.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
