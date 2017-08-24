Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:52572 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753838AbdHXVm5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 17:42:57 -0400
Date: Thu, 24 Aug 2017 15:42:26 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 3/3] xfs: support for synchronous DAX faults
Message-ID: <20170824214226.GC20489@linux.intel.com>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824152207.30729-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>

On Thu, Aug 24, 2017 at 05:22:07PM +0200, Christoph Hellwig wrote:
> Return IOMAP_F_NEEDDSYNC from xfs_file_iomap_begin() for a synchronous
> write fault when inode is pinned, and has dirty fields other than the
> timestamps.  In xfs_filemap_huge_fault() we then detect this case and
		  __xfs_filemap_fault()

Otherwise this looks good to me:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
