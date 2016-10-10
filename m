Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56880 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751594AbcJJUs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 16:48:27 -0400
Date: Tue, 11 Oct 2016 07:19:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dax: correct dax iomap code namespace
Message-ID: <20161010201958.GD23194@dastard>
References: <20161009152803.GA20111@lst.de>
 <1476126244-27673-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476126244-27673-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Mon, Oct 10, 2016 at 01:04:04PM -0600, Ross Zwisler wrote:
> The recently added DAX functions that use the new struct iomap data
> structure were named iomap_dax_rw(), iomap_dax_fault() and
> iomap_dax_actor().  These are actually defined in fs/dax.c, though, so
> should be part of the "dax" namespace and not the "iomap" namespace.
> Rename them to dax_iomap_rw(), dax_iomap_fault() and dax_iomap_actor()
> respectively.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
> 
> Dave, per Christoph's suggestion can you please send this to Linus for
> v4.9?  This patch applies cleanly to both the current linux/master and the
> current xfs/for-next.

I'll plan to send this for 4.9-rc2 or 4.9-rc3 in the first batch of
fixes for the -rc1 merge.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
