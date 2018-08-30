Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48960 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbeH3UZv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Aug 2018 16:25:51 -0400
Date: Thu, 30 Aug 2018 18:25:45 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180830162545.GA26816@lst.de>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, Aug 30, 2018 at 11:10:05AM -0500, Eric Sandeen wrote:
> We disabled FIBMAP/bmap calls for reflinked files because swap will then
> writes directly to the blocks, bypassing COW mechanisms, and breaking
> copy on write.  As noted in commit db1327b, this restriction also breaks
> bootloaders that want to use the FIBMAP ioctl.
> 
> Rather than disabling the entire mapping interface for everyone just
> because swapon may abuse the info, teach xfs_iomap_swapfile_activate()
> to reject activation for reflinked files, and re-enable the FIBMAP
> interface.

Every use of the feature is an abuse, and that includes bootloaders.
By the time you've obtained the information it can (and often will)
be stale.
