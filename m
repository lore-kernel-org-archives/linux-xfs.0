Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58280 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbeK2Lim (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 06:38:42 -0500
Date: Wed, 28 Nov 2018 16:35:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/6] xfs_scrub: handle totally empty inode chunks
Message-ID: <20181129003508.GJ8125@magnolia>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181073901.3727.3960278646297663354.stgit@magnolia>
 <8de9dcd7-4bcd-2f4b-0043-835611317bed@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8de9dcd7-4bcd-2f4b-0043-835611317bed@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 28, 2018 at 06:16:37PM -0600, Eric Sandeen wrote:
> On 11/9/18 6:45 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > We try to load a single inobt record with each FSINUMBERS call.  If the
> > chunk is totally empty (which can happen when there are more than one
> > inobt record per block) we should skip to the next INUMBERS call since
> > there are no inodes to bulkstat.
> 
> It's not clear to me if this is a bugfix or an optimization, but meh,
> seems like the right thing to do :)

It's a bug fix for 64k-block filesystems, which can have multiple empty
inobt records that map to a single 64k block; if we try to BULKSTAT an
empty inobt group then we get zero inodes and scrub erroneously says the
fs is broken when in reality it's just stupid.

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/inodes.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > 
> > diff --git a/scrub/inodes.c b/scrub/inodes.c
> > index 693f21ec..442a5978 100644
> > --- a/scrub/inodes.c
> > +++ b/scrub/inodes.c
> > @@ -139,6 +139,12 @@ xfs_iterate_inodes_range(
> >  		/* Load the inodes. */
> >  		ino = inogrp.xi_startino - 1;
> >  		bulkreq.icount = inogrp.xi_alloccount;
> > +		/*
> > +		 * We can have totally empty inode chunks on filesystems where
> > +		 * there are more than 64 inodes per block.  Skip these.
> > +		 */
> > +		if (inogrp.xi_alloccount == 0)
> > +			goto igrp_retry;
> >  		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
> >  		if (error)
> >  			str_info(ctx, descr, "%s", strerror_r(errno,
> > 
