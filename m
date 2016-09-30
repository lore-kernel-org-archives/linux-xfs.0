Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42813 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752451AbcI3HTq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:19:46 -0400
Date: Fri, 30 Sep 2016 00:19:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/63] xfs: return work remaining at the end of a bunmapi
 operation
Message-ID: <20160930071944.GL18305@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520490339.29434.11775509253578580319.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520490339.29434.11775509253578580319.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:08:23PM -0700, Darrick J. Wong wrote:
> Return the range of file blocks that bunmapi didn't free.  This hint
> is used by CoW and reflink to figure out what part of an extent
> actually got freed so that it can set up the appropriate atomic
> remapping of just the freed range.

FYI, I'd much prefer having xfs_bunmapi use the new __xfs_bunmapi
calling convention and use that everywhere.

Not really urgent enough to block the merge for now, especially as I
have some major xfs_bunmapi surgery on my plate anyway and can take
care of that in the next merge window.

Reviewed-by: Christoph Hellwig <hch@lst.de>
