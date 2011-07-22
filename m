Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MFverA092705 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 10:57:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E557EF50F2
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 08:57:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	y5V6l1C8DUnnWEAY for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 08:57:38 -0700 (PDT)
Date: Fri, 22 Jul 2011 11:57:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Updated xfsprogs 2.6.38 merge
Message-ID: <20110722155737.GA7261@infradead.org>
References: <20110705024855.GA561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110705024855.GA561@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 05, 2011 at 12:48:55PM +1000, Dave Chinner wrote:
> Folks,
> 
> I pushed out an updated 2.6.38 kernel merge to xfsprogs patchset a
> couple of days ago. I've been doing quite a bit of testing on it,
> both 32 bit and 64 bit, with 512 byte, 1k and 4k block size
> filesystems and I haven't come across any regressions. The patchset
> can be found here:
> 
>   git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev kernel-2.6.38-sync
> 
> It's pretty much unchanged from the last set of patches I sent,
> except for one minor fix to the radix tree code for an off by one in
> the path array size for item and tag deletes.
> 
> I'm pretty much ready to commit this update so I can then move
> forward with updating it to the 3.0 kernel code base as a smaller
> incremental series.

With the xfs_imap.h changes in, and the radix-tree bits fixed up I'm
fine with this merge and you can add my reviewed-by tags to all commits.

I'd also suggest removing the testing details in the main patch commit
log, as it seems a bit misplaced in there.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
