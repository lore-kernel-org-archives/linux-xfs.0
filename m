Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L1x03L161166 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 20:59:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AF5475EC24
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 19:15:15 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	UcO6Q1rKMhrTpE6G for <xfs@oss.sgi.com>;
	Wed, 20 Oct 2010 19:15:15 -0700 (PDT)
Date: Thu, 21 Oct 2010 13:00:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: avoid mbox file fragmentation
Message-ID: <20101021020009.GG12506@dastard>
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
	<19646.55189.843933.481529@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19646.55189.843933.481529@tree.ty.sabi.co.uk>
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
To: Peter Grandi <pg@xfs2.to.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

On Wed, Oct 20, 2010 at 12:50:45PM +0100, Peter Grandi wrote:
> However, I am a fan of having *default* physical preallocation,
> because as a rule one can trade off space for speed nowadays, and
> padding files with "future growth" tails is fairly cheap, and one
> could modify the filesystem code or 'fsck' to reclaim unused space
> in "future grown" tails.

When writing lots of small files (e.g. unpacking a kernel tarball),
leaving space at the file tail due to preallocation (that will never
get used) means that the file data is now sparse on disk instead of
packed into adjacent blocks.

The result? Instead of the elevate merging adjacent file data IOs
into a large IO, they all get issued individually, and the seek
count for IO goes way up. Not truncating away the specualtive
prealocation beyond EOF will cause this, too, and that slows down
such workloads by an order of magnitude....

So, Peter, you don't get the pony because we gave it to someone
else. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
