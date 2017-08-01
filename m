Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41831 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751697AbdHAK4K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 06:56:10 -0400
Date: Tue, 1 Aug 2017 03:56:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] dax, iomap: Add support for synchronous faults
Message-ID: <20170801105608.GD6742@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-6-jack@suse.cz>
 <20170727224245.GF22000@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170727224245.GF22000@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

On Thu, Jul 27, 2017 at 04:42:45PM -0600, Ross Zwisler wrote:
> I wonder if we should name this flag something a little stronger and more
> specific to its usage with respect to DAX and sync faults?  Maybe
> "VM_FAULT_NEEDDSYNC" for consistency with the iomap flag?

Agreed.
