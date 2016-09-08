Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48550 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758186AbcIHSUz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 14:20:55 -0400
Date: Thu, 8 Sep 2016 11:20:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/71] xfs: define tracepoints for refcount btree
 activities
Message-ID: <20160908182025.GA8969@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216796400.867.3093949883691867882.stgit@birch.djwong.org>
 <20160906145446.GB24287@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160906145446.GB24287@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 07:54:46AM -0700, Christoph Hellwig wrote:
> > +#ifndef XFS_REFCOUNT_IREC_PLACEHOLDER
> > +#define XFS_REFCOUNT_IREC_PLACEHOLDER
> > +/* Placeholder definition to avoid breaking bisectability. */
> > +struct xfs_refcount_irec {
> > +	xfs_agblock_t	rc_startblock;	/* starting block number */
> > +	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
> > +	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
> > +};
> > +#endif
> 
> I didn't really understand the point earlier either - why can't
> you just merge the patch adding the tracepoints into that defining
> the structures and calling the tracepoints?  That would avoid that
> whole exercise.

Originally I did it that way so my eyes wouldn't bleed every time I
looked at the follow-on patch, but you're right that these can be
consolidated now.

--D
