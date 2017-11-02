Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56290 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932571AbdKBStn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 14:49:43 -0400
Date: Thu, 2 Nov 2017 19:49:42 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/18] xfs: introduce the xfs_iext_cursor abstraction
Message-ID: <20171102184942.GB4244@lst.de>
References: <20171031142230.11755-1-hch@lst.de> <20171031142230.11755-13-hch@lst.de> <20171031220234.GT4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031220234.GT4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 03:02:34PM -0700, Darrick J. Wong wrote:
> > +	struct xfs_iext_cursor ext;
> 
> I was expecting an extent map cursor to have 'cur' in the name --
> 'ext' misleads me into thinking that 'ext' is an actual extent.
> 
> struct xfs_iext_cursor	*icur;
> 
> Also, xfs_iext_insert names its cursor parameter *cur, so why ext here?

I started out with cur, but in most bmap routines we already have the
btree cursor named cur, so I had to look for something else.  I could
probably change to icur, but that will be a heck of an annoying rebase..

> For now I'm going to assume that xfs_iext_{first,last,next,prev} will
> actually do something with the ifp parameter in the near future.

Yes, good assumption.
