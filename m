Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58234 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbeGLMNt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jul 2018 08:13:49 -0400
Date: Thu, 12 Jul 2018 14:06:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: t_firstblock assert triggered from dedup in generic/051
Message-ID: <20180712120624.GA28984@lst.de>
References: <20180711184241.GA4949@lst.de> <20180711190925.GI32415@magnolia> <20180711193821.GA6841@killians.ges.redhat.com> <20180711194321.GJ5724@magnolia> <20180712002534.GJ32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180712002534.GJ32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jul 11, 2018 at 05:25:34PM -0700, Darrick J. Wong wrote:
> > +	/*
> > +	 * Roll the transaction once more to avoid returning to the caller
> > +	 * with a dirty transaction.
> > +	 */
> > +	error = xfs_defer_trans_roll(tp, dop);
> 
> Heh, it doesn't test ok; back to the drawing board...
> 
> XFS: Assertion failed: !test_bit(XFS_LI_DIRTY, &lip->li_flags), file: fs/xfs/xfs_trans.c, line: 740

I haven't hit this yet with a full 4k+reflink and 1k+reflink run,
so far things seem to do fine.

> I think we only need to roll if the transaction is actually dirty, i.e.
> 
> 	if ((*tp)->t_flags & XFS_TRANS_DIRTY)
> 		error = xfs_defer_trans_roll(tp, dop);

But independent of me not hitting the assert that looks reasonable.
