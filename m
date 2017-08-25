Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53579 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754318AbdHYHKK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 03:10:10 -0400
Date: Fri, 25 Aug 2017 09:10:08 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] iomap: return VM_FAULT_* codes from
        iomap_page_mkwrite
Message-ID: <20170825071008.GA9191@lst.de>
References: <20170824152207.30729-1-hch@lst.de> <20170824152207.30729-2-hch@lst.de> <20170824192624.GA20489@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824192624.GA20489@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Thu, Aug 24, 2017 at 01:26:24PM -0600, Ross Zwisler wrote:
> On Thu, Aug 24, 2017 at 05:22:05PM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This is obviously correct, but the lack of changelog makes it unclear why the
> change is being made.  Does a later patch in the series depend on
> iomap_page_mkwrite() returning VM_FAULT_* codes?  Is this just cleanup so you
> can hide the block_page_mkwrite_return() call inside of iomap_page_mkwrite()?
> 
> I think it's the former, so the logic in __xfs_filemap_fault() is simpler?

Yes.
