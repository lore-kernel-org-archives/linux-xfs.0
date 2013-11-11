Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D6EBF7F6A
	for <linux-xfs@oss.sgi.com>; Mon, 11 Nov 2013 14:56:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9FB448F8040
	for <linux-xfs@oss.sgi.com>; Mon, 11 Nov 2013 12:56:07 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hzrRklffNaYFa5gd for <linux-xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 12:56:02 -0800 (PST)
Date: Tue, 12 Nov 2013 07:55:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ag selection
Message-ID: <20131111205558.GU6188@dastard>
References: <l5r3tf$m0j$1@ger.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <l5r3tf$m0j$1@ger.gmane.org>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-xfs@oss.sgi.com

On Mon, Nov 11, 2013 at 06:25:13PM +0100, Bernd Schubert wrote:
> Hi all,
> 
> for streaming writes onto a raid6 the current round-robin ag
> selection seems does not seem to be optimal. Writing 4 files from 4
> threads into a single directory we get 900 MB/s,

IOWs, writing all 4 files into the same AG, interleaving them in to
the same physical location on disk.

> writing 4 files in
> 4 different directories we only get 700 MB/s (12 disks with with hw
> megaraid-sas).

And that writes the 4 files into 4 different AGs, separating them
into physically different regions of the disk. There's seeks between
the streams there, and often cheap RAID controllers have problems
with internal caching algorithms being unable to minimise seeks
between streams effectively.

> The current round-robin scheme seems to be optimized
> for linear raid0?

Not at all - sequential writes of large files are optimised to
maintain high sequential *read* rates of the data that is being
written. Also, RAID 0 and RAID 6 have exactly the same
characteristics for this workload, so the behaviour you are seeing
is more likely due to XFS is writing to slower areas of the disks
when more streams are running in more AGs.

i.e. 900MB/s might be what you get at the outer edge of the disks,
but you might only get 500MB/s at the inner edges. When writing into
4 AGs at once, they are not all going to the outer edge, and hence
you see a much truer reflection of the speed of your storage than
the single AG case.

Keep in mind the inode64 AG selection algorithm is optimised to
spread the allocation load out over the entire filesystem address
space via rotating the directory structure. It does this to
increases allocation parallelism and reduce filesystem hotspots,
to improves individual locality of disparate sets of data, and in
general is significantly faster than any other AG selection
algorithm that anyone has managed to come up with.

> With small AGs one could also argue, that choosing
> AGs which are not far away from each other (in respect to the number
> of blocks) also adds more parallel disk access for small and medium
> sized files.
> 
> Any objections against a patch to improve the AG selection?

Define "improve". I'm interested in hearing new idea on how we might
be able to make different allocation decisions, but changing
algorithms is not just a matter of changing code.

At minimum, changing the way allocation is done will drastically
change the aging characteristics of the filesystem, and so what
might work really well for empty filesystems (like ext4's linear
allocation algorithms) really hurts performance as filesystems get
older and free space gets less contiguous....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
