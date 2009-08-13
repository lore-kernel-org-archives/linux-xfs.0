Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DDDk1L022742 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 08:14:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2B9114A8AB6
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 06:14:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BlCUoYitnVDuAToC for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 06:14:11 -0700 (PDT)
Date: Thu, 13 Aug 2009 09:14:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fs change on read-only mount
Message-ID: <20090813131407.GA1088@infradead.org>
References: <4A84090A.6040601@bgs.hu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A84090A.6040601@bgs.hu>
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
To: Bgs <bgs@bgs.hu>
Cc: SGI Project XFS mailing list <xfs@oss.sgi.com>

On Thu, Aug 13, 2009 at 02:37:30PM +0200, Bgs wrote:
> 
>  Greetings,
> 
> I don't know xfs' superblock handling well enough, so I'm asking for
> advice here:
> 
> Does xfs write anything on the disk when mounting read-only? Is it
> possible to use a partitions hash (or some well defined portion of the
> partition) for integrity checks?

It should not write anything to disk [1], but older versions did so due to
bugs.  Doing a hash of a read-only filesystem should be fine.

> The partitions are used read-only and hash would be re-generated  if any
> rw action was done (after remount ro or full reboot of course). Can this
> be done? I'm concerned about 'mount count' like writes...

There is no mount-count like write in XFS.

[1] the only exception is that log reocvery is performed when we attempt 
    a read-only mount with an unclean log, that is the box crashed while
    writing the filesystems.  To make sure you never do this always mark
    the underlying device readonly, using blkdev --ro.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
