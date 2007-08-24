Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 18:27:09 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7O1R44p000783
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 18:27:05 -0700
Date: Fri, 24 Aug 2007 03:27:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/17] remove dependency of the quota module on behaviors.
Message-ID: <20070824012702.GC25534@lst.de>
References: <20070823193935.GL8050@lst.de> <20070824002612.GC72985246@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824002612.GC72985246@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Aug 24, 2007 at 10:26:12AM +1000, David Chinner wrote:
> > +static struct xfs_qmops xfs_qmcore_stub = {
> >  	.xfs_qminit		= (xfs_qminit_t) xfs_noquota_init,
> >  	.xfs_qmdone		= (xfs_qmdone_t) fs_noerr,
> >  	.xfs_qmmount		= (xfs_qmmount_t) fs_noerr,
> > @@ -124,4 +126,38 @@ xfs_qmops_t	xfs_qmcore_stub = {
> >  	.xfs_dqvoprename	= (xfs_dqvoprename_t) fs_noerr,
> >  	.xfs_dqvopchown		= xfs_dqvopchown_default,
> >  	.xfs_dqvopchownresv	= (xfs_dqvopchownresv_t) fs_noerr,
> > +	.xfs_dqstatvfs		= (xfs_dqstatvfs_t) fs_noval,
> > +	.xfs_dqsync		= (xfs_dqsync_t) fs_noerr,
> 
> That returns no error.
> 
> This is slightly non-obvious that if quotas are not enabled or loaded
> that this quota sync does not actually return an error. Perhaps a small
> addition to the comment above XFS_QM_DQSYNC() to explain this would
> help prevent future misunderstandings.

Sure, I'll add a comment.
