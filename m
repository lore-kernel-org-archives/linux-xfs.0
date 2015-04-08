Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C4F867F81
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 11:24:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A10028F8071
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 09:24:06 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id FgPadXyO16CljWxb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Apr 2015 09:24:05 -0700 (PDT)
Date: Wed, 8 Apr 2015 18:24:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: unlock i_mutex in xfs_break_layouts
Message-ID: <20150408162403.GD16052@lst.de>
References: <1428420944-20965-1-git-send-email-hch@lst.de>
	<20150407221927.GD15810@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150407221927.GD15810@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Wed, Apr 08, 2015 at 08:19:27AM +1000, Dave Chinner wrote:
> That's kinda nasty, and it has no documentation explaining when or
> why we'd need to drop the i_mutex. How are we supposed to know if we
> need to drop the i_mutex or not?

We need to drop it if we hold it, pretty easy.

> What happens if the upper VFS
> layers change or we have a multiple call paths that have different
> i_mutex contexts (i.e. one holds, another doesn't)?

We avoid this in the VFS, as everytime we had it filesystems were getting it
wrong.

However you have a point in that we should probably have asserts that the
right locks are held.

> Which makes me wonder - is this layout breaking stuff at the right
> layer?

We can't do it in the VFS as it needs to be atomic vs the lock that
protects write in ->write and ->fallocate, which is only taken in
the filesystem.  For ->setattr in theory we could do it in the VFS,
but if the other callers can't do it in the VFS that will just lead
to code duplication.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
