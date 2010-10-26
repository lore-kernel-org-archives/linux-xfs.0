Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QN8rqP112738 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 18:08:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C472128165
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 16:10:10 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	C02FVa8sFBY8taZU for <xfs@oss.sgi.com>;
	Tue, 26 Oct 2010 16:10:10 -0700 (PDT)
Date: Wed, 27 Oct 2010 10:10:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Performance on NetApp
Message-ID: <20101026231007.GA32255@dastard>
References: <201010270033.35894@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010270033.35894@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Oct 27, 2010 at 12:33:35AM +0200, Michael Monnerie wrote:
> Does anybody have a report how XFS behaves on a NetApp storage with thin 
> provisioning? They have a completely "weird" storage, their WAFL (write 
> anywhere file layout) together with deduplication and other things make 
> me think the best is to not-at-all specify any "performance options" in 
> mkfs/mount, like sunit/swidth or largeio, swalloc, etc.
> 
> Does someone have information on that?

Not about the Netapp as such.

However, as a general rule thin provisioned storage will have
unpredictable performance characteristics as the block
number/physical location correlation is meaningless.

e.g. because the log is one of the first things written to a thinly
provisioned volume during mkfs, it is unlikely to be physically
located in the middle of the volume. Indeed, there's no guarantee
that it will even be on the same spindles as the rest of the
filesystem, and it may be sharing spindles with some other thin
volume....

So, you are right in assuming that it is best not to tune your
filesystem to a specific physical geometry because there generally
isn't one for thinly provisioned volumes. However, options that
reduce filesystem fragmentation (e.g. allocsize) still have value in
keeping the amount of metadata and ptotential seeks down...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
