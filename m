Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48110 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932357AbeARRDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jan 2018 12:03:01 -0500
Date: Thu, 18 Jan 2018 09:02:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: try to unshare extents before granting pnfs
 leases
Message-ID: <20180118170255.GH25805@magnolia>
References: <151626134674.25794.7913544634631149739.stgit@magnolia>
 <151626135947.25794.13152244142083119314.stgit@magnolia>
 <20180118141513.GA22992@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180118141513.GA22992@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 18, 2018 at 03:15:13PM +0100, Christoph Hellwig wrote:
> On Wed, Jan 17, 2018 at 11:42:39PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Try to unshare an extent before granting a lease to pnfs; if this isn't
> > possible, then bail out.
> 
> 
> I don't like this at all.  The block and scsi layout protocols actually
> have support for reflinks, someone just needs to implement it..
> 
> But until that is implemented I'd rather fail getting a layout than
> starting a potentially very long running unshare.

Fair enough, I'll dump this one.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
