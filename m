Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40003 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753353AbdHUSpD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Aug 2017 14:45:03 -0400
Date: Mon, 21 Aug 2017 12:45:01 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 09/13] dax: Allow dax_iomap_fault() to return pfn
Message-ID: <20170821184501.GA26220@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-10-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-10-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu, Aug 17, 2017 at 06:08:11PM +0200, Jan Kara wrote:
> For synchronous page fault dax_iomap_fault() will need to return PFN
> which will then need to inserted into page tables after fsync()
> completes. Add necessary parameter to dax_iomap_fault().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Yep, this seems like a nice, straightforward way of doing things.  I like this
better than the vmf->orig_pte solution from the previous RFC.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
