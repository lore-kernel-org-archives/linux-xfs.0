Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52900 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfAWEMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 23:12:06 -0500
Date: Tue, 22 Jan 2019 20:11:50 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/22] xfs: pack inode allocation parameters into a
 separate structure
Message-ID: <20190123041150.GA4368@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630917213.18437.11076220872907040413.stgit@magnolia>
 <20190117142126.GC16270@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117142126.GC16270@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Thu, Jan 17, 2019 at 06:21:26AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 31, 2018 at 06:19:32PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Instead of open-coding new inode parameters through xfs_dir_ialloc and
> > xfs_Ialloc, put everything into a structure and pass that instead.  This
> > will make it easier to share code with xfsprogs while maintaining the
> > ability for xfsprogs to supply extra new inode parameters.
> 
> I find these ad-hoc arg structures rather cumberssome to be honest.
> 
> > +/* Initial ids, link count, device number, and mode of a new inode. */
> > +struct xfs_ialloc_args {
> > +	struct xfs_inode		*pip;	/* parent inode or null */
> > +
> > +	uint32_t			uid;
> > +	uint32_t			gid;
> > +	prid_t				prid;
> > +
> > +	xfs_nlink_t			nlink;
> > +	dev_t				rdev;
> > +
> > +	umode_t				mode;
> 
> And except for the parent inode this is a significant subsystet of
> stat data.  Can't we just pass a struct kstat, and a mask of attributes
> from the kstat we want to set instead?  That is use a calling convention
> similar to ->setattr?

We could, but we still want to be able to pass in the parent inode and
the initial project id, so we still need struct xfs_ialloc_args.  Using
struct kstat instead of just picking up the fields xfs cares about will
waste stack space for things we're /never/ going to need, like blksize,
attributes* ino, dev, size, btime, and blocks.  That also requires us to
maintain enough of a port of struct kstat to userspace in order to share
uid, gid, nlink, rdev, and mode.

I don't think it's worth the trouble, but I want Eric's input before I
go doing things that have repercussions for xfsprogs. :)

--D
