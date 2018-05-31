Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36501 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751660AbeEaGOa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 02:14:30 -0400
Date: Thu, 31 May 2018 08:20:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] fs: use ->is_partially_uptodate in
        page_cache_seek_hole_data
Message-ID: <20180531062055.GA31523@lst.de>
References: <20180530100208.31490-1-hch@lst.de> <20180530100208.31490-4-hch@lst.de> <20180530230038.GY10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530230038.GY10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, May 31, 2018 at 09:00:38AM +1000, Dave Chinner wrote:
> > -/*
> > - * Seek for SEEK_DATA / SEEK_HOLE within @page, starting at @lastoff.
> > - *
> > - * Returns the offset within the file on success, and -ENOENT otherwise.
> > - */
> > -static loff_t
> > -page_seek_hole_data(struct page *page, loff_t lastoff, int whence)
> > +static bool
> > +page_seek_hole_data(struct inode *inode, struct page *page, loff_t *lastoff,
> > +		int whence)
> 
> Can we keep the comment explaining the return value?

The old comment isn't going to be correct.  I've added back a changed
comment, akthough I don't really think it helps.

> > +	const struct address_space_operations *ops = inode->i_mapping->a_ops;
> > +	unsigned int bsize = i_blocksize(inode), off;
> 
> Split this into two lines.

We've got a pattern here - I really like it that way..
