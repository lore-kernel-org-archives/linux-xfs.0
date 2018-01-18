Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34200 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755690AbeAROPO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:15:14 -0500
Date: Thu, 18 Jan 2018 15:15:13 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: try to unshare extents before granting pnfs
        leases
Message-ID: <20180118141513.GA22992@lst.de>
References: <151626134674.25794.7913544634631149739.stgit@magnolia> <151626135947.25794.13152244142083119314.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151626135947.25794.13152244142083119314.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org

On Wed, Jan 17, 2018 at 11:42:39PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Try to unshare an extent before granting a lease to pnfs; if this isn't
> possible, then bail out.


I don't like this at all.  The block and scsi layout protocols actually
have support for reflinks, someone just needs to implement it..

But until that is implemented I'd rather fail getting a layout than
starting a potentially very long running unshare.
