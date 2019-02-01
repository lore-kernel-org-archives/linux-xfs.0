Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33323 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfBAHXY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 02:23:24 -0500
Date: Fri, 1 Feb 2019 08:23:22 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/11] FOLD: improve xfs_bmapi_delalloc
Message-ID: <20190201072322.GA14711@lst.de>
References: <20190131075524.4769-1-hch@lst.de> <20190131075524.4769-2-hch@lst.de> <20190131180957.GC36239@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131180957.GC36239@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 01:09:58PM -0500, Brian Foster wrote:
> > +	int			flags = XFS_BMAPI_DELALLOC, nimaps = 1, error;
> > +
> 
> I'd rather see these on separate lines.

Ok.

> >  	flags |= XFS_BMAPI_DELALLOC;
> > -	return xfs_bmapi_write(tp, ip, bno, 1, flags, total, imap, nimaps);
> > +	error = xfs_bmapi_write(tp, ip, offset_fsb, 1, flags,
> > +			XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK),
> 
> Shouldn't this be whichfork?

Yeah.

Given that this is intended to be folded into your series to clean
up the interface for the delalloc helper, do you want to take these
bits over?
