Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56413 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751781AbdLCVoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Dec 2017 16:44:19 -0500
Date: Mon, 4 Dec 2017 08:44:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/7] xfs: include inobt buffers in ifree tx log
 reservation
Message-ID: <20171203214416.GR5858@dastard>
References: <20171130185836.18481-1-bfoster@redhat.com>
 <20171130185836.18481-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130185836.18481-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 01:58:31PM -0500, Brian Foster wrote:
> The tr_ifree transaction handles inode unlinks and inode chunk
> frees. The current transaction calculation does not accurately
> reflect worst case changes to the inode btree, however. The inobt
> portion of the current transaction reservation only covers
> modification of a single inobt buffer (for the particular inode
> record). This is a historical artifact from the days before XFS
> supported full inode chunk removal.
> 
> When support for inode chunk removal was added in commit
> 254f6311ed1b ("Implement deletion of inode clusters in XFS."), the
> additional log reservation required for chunk removal was not added
> correctly. The new reservation only considered the header overhead
> of associated buffers rather than the full contents of the btrees
> and AGF and AGFL buffers affected by the transaction. The
> reservation for the free space btrees was subsequently fixed up in
> commit 5fe6abb82f76 ("Add space for inode and allocation btrees to
> ITRUNCATE log reservation"), but the res. for full inobt joins has
> never been added.
> 
> Further review of the ifree reservation uncovered a couple more
> problems:
> 
> - The undocumented +2 blocks are intended for the AGF and AGFL, but
>   are also not sized correctly and should be logged as full sectors
>   (not FSBs).
> - The additional single block header is undocumented and serves no
>   apparent purpose.
> 
> Update xfs_calc_ifree_reservation() to include a full inobt join in
> the reservation calculation. Refactor the undocumented blocks
> appropriately and fix up the comments to reflect the current
> calculation.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
