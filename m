Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34364 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932836AbcJRFSA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 01:18:00 -0400
Date: Tue, 18 Oct 2016 07:17:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: merge xfs_reflink_remap_range and
        xfs_file_share_range
Message-ID: <20161018051758.GA2184@lst.de>
References: <1476705920-32493-1-git-send-email-hch@lst.de> <1476705920-32493-5-git-send-email-hch@lst.de> <20161017212933.GE26485@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161017212933.GE26485@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Oct 17, 2016 at 02:29:33PM -0700, Darrick J. Wong wrote:
> > +	bs = inode->i_sb->s_blocksize;
> > +	inode_dio_wait(inode);
> > +
> > +	rounding = max_t(xfs_off_t, bs, PAGE_SIZE);
> > +	ioffset = round_down(offset, rounding);
> > +	iendoffset = round_up(offset + len, rounding) - 1;
> > +	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
> > +					   iendoffset);
> > +	return ret;
> > +}
> 
> This seems like a file action not specific to reflink.

But it's only used by the reflink code :)

That being said given that filemap_write_and_wait_range operates
on pages there is no need for the rounding anyway, and we could
just replace it with open coded calls to inode_dio_wait and
filemap_write_and_wait_range.  Maybe I should do that before
this patch so we don't have to bother moving it.

> > +xfs_file_share_range(
> 
> xfs_reflink_share_file_range() ?
> 
> I'd like to maintain the convention that all reflink functions
> start with xfs_reflink_*, particularly since the xfs_file_* functions
> largely live in xfs_file.c.

Ok, fine.

> > +	if (is_dedupe) {
> > +		bool		is_same = false;
> > +
> > +		ret = xfs_compare_extents(inode_in, pos_in, inode_out, pos_out,
> > +				len, &is_same);
> > +		if (ret)
> > +			goto out_unlock;;
> 
> Double-semicolon here.

I'll fix it.
