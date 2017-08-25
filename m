Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53500 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754575AbdHYGuw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 02:50:52 -0400
Date: Fri, 25 Aug 2017 08:50:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] xfs: support for synchronous DAX faults
Message-ID: <20170825065051.GA8866@lst.de>
References: <20170824152207.30729-1-hch@lst.de> <20170824152207.30729-4-hch@lst.de> <CAPcyv4i0kNowtfDQpjJPU+o1xnsAskB+-O8cFzdLivdeoEEJkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i0kNowtfDQpjJPU+o1xnsAskB+-O8cFzdLivdeoEEJkw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>

On Thu, Aug 24, 2017 at 05:13:54PM -0700, Dan Williams wrote:
> 
> So this behaves differently than ext4 that returns EOPNOTSUP in the !DAX case.
> 
> Are we generally documenting MAP_SYNC to be ignored in the pagecache
> case? Or should we explicitly fail MAP_SYNC for the !DAX case on all
> filesystems?

It's just me being lazy for now until we've settled on the exact mmap
interface.  With your new ->mmap signature we can do proper flags
checking, and I would add it.  But with only Jans patches it seems
like we'd silently support MAP_SYNC for all other file systems
anyway.

> Another option is to finish block allocations at fault time in the
> pagecache+MAP_SYNC case, but still require fsync to writeback dirty
> pages, but that seems pointless.

Agreed.

> Whatever we do I think all implementations should agree.

Sure.
