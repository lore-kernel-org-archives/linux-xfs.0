Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47694 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdHAKy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 06:54:28 -0400
Date: Tue, 1 Aug 2017 03:54:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] dax: Simplify arguments of dax_insert_mapping()
Message-ID: <20170801105427.GC6742@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-4-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

On Thu, Jul 27, 2017 at 03:12:41PM +0200, Jan Kara wrote:
> dax_insert_mapping() has lots of arguments and a lot of them is actuall
> duplicated by passing vm_fault structure as well. Change the function to
> take the same arguments as dax_pmd_insert_mapping().

Some of this is probably for historic reasons, when I did the initial
pass at iomap based DAX dax_insert_mapping still had to be usable for
the non-DAX case.

Either way this looks like a great cleanup:

Reviewed-by: Christoph Hellwig <hch@lst.de>
