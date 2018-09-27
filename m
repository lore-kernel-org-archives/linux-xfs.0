Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46879 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbeI1A6Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:58:25 -0400
Date: Thu, 27 Sep 2018 20:38:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/10] xfs: remove XFS_IO_INVALID
Message-ID: <20180927183849.GA14584@lst.de>
References: <20180917205354.15401-1-hch@lst.de> <20180917205354.15401-4-hch@lst.de> <20180920203127.GQ20086@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920203127.GQ20086@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Sep 20, 2018 at 01:31:27PM -0700, Darrick J. Wong wrote:
> >  {
> >  	struct xfs_writepage_ctx wpc = {
> > -		.io_type = XFS_IO_INVALID,
> > +		.io_type = XFS_IO_HOLE,
> 
> Hm.  So I guess if we ever saw XFS_IO_INVALID that meant "we never did
> find any extents and so never set io_type", right?

Yes.
