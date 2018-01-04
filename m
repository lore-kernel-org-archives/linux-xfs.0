Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47995 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751520AbeADIdi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 03:33:38 -0500
Date: Thu, 4 Jan 2018 09:33:36 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 18/18] xfs, dax: wire up dax_flush_dma support via a
        new xfs_sync_dma helper
Message-ID: <20180104083336.GN2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com> <151407705701.38751.6157642918168721562.stgit@dwillia2-desk3.amr.corp.intel.com> <20180102230027.GV5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180102230027.GV5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org, jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

On Wed, Jan 03, 2018 at 10:00:27AM +1100, Dave Chinner wrote:
> AFAIC, these DMA references are just another external layout
> reference that needs to be broken.  IOWs, this "sync DMA" complexity
> needs to go inside xfs_break_layouts() as it is part of breaking the
> external reference to the file layout - it does not replace the
> layout breaking abstraction and so the implementation needs to
> reflect that.

Agreed.
