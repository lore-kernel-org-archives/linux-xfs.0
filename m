Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49781 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751871AbdIQVom (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 Sep 2017 17:44:42 -0400
Date: Sun, 17 Sep 2017 23:44:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: rewrite getbmap using the xfs_iext_* helpers
Message-ID: <20170917214441.GA30786@lst.de>
References: <20170903155140.17256-1-hch@lst.de> <20170911154925.GB13400@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911154925.GB13400@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Sep 11, 2017 at 11:49:25AM -0400, Brian Foster wrote:
> > +		if (!xfs_iext_get_extent(ifp, ++idx, &got)) {
> > +			xfs_fileoff_t	end = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> > +
> > +			out[bmv->bmv_entries].bmv_oflags |= BMV_OF_LAST;
> > +
> 
> I'm a little confused about the above bit. Isn't ->bmv_entries already
> incremented past the last reported extent?

Yes, it needs to be bmv->bmv_entries - 1.

> Further, if there is a hole
> to be reported, we potentially do that just below (which means that
> ->bmv_entries may or may not refer to the last reported segment here)..?

We can't reach this code when the previous extent was a hole.  For the
whole file hole case we jump straight to out_unlock_ilock after
filling the hole, for the inbetween extents hole case we break out
of the loop when running out of space before filling the second extent,
and the end of file hole case is just below setting BMV_OF_LAST.
