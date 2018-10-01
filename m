Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38074 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729488AbeJAVY3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:24:29 -0400
Date: Mon, 1 Oct 2018 16:46:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] xfs: handle zeroing in xfs_file_iomap_begin_delay
Message-ID: <20181001144618.GA5831@lst.de>
References: <20181001123741.32005-1-hch@lst.de> <20181001123741.32005-4-hch@lst.de> <20181001142005.GE53694@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001142005.GE53694@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Oct 01, 2018 at 10:20:05AM -0400, Brian Foster wrote:
> >  	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got);
> > -	if (!eof && got.br_startoff <= offset_fsb) {
> > -		if (xfs_is_reflink_inode(ip)) {
> > +	if (eof)
> > +		got.br_startoff = maxbytes_fsb;
> 
> What's the purpose of this? Can't we just continue to use eof in the
> logic below and report holes up through the requested range (offset +
> length) just like the other branch does (via xfs_bmapi_read())?

Setting the startblock makes the code a lot simpler.  But yes,
we could limit the hole to the reporting range.

> 
> > +	if (got.br_startoff <= offset_fsb) {
> > +		if (xfs_is_reflink_inode(ip) &&
> > +		    ((flags & IOMAP_WRITE) ||
> > +		     got.br_state != XFS_EXT_UNWRITTEN)) {
> 
> I think a small comment is useful here due to the implicit logic. For
> example:
> 
> /* reservation is required for writes and zeroing over normal extents */

Ok.
