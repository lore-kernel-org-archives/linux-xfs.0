Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47192 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbeBHBm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 20:42:56 -0500
Date: Wed, 7 Feb 2018 17:42:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: shutdown if block allocation overruns tx
 reservation
Message-ID: <20180208014252.GC5433@magnolia>
References: <20180205174601.51574-1-bfoster@redhat.com>
 <20180205174601.51574-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180205174601.51574-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 05, 2018 at 12:45:58PM -0500, Brian Foster wrote:
> The ->t_blk_res_used field tracks how many blocks have been used in
> the current transaction. This should never exceed the block
> reservation (->t_blk_res) for a particular transaction. We currently
> assert this condition in the transaction block accounting code, but
> otherwise take no additional action should this situation occur.
> 
> The overrun generally has no effect if space ends up being available
> and the associated transaction commits. If the transaction is
> duplicated, however, the current block usage is used to determine
> the remaining block reservation to be transferred to the new
> transaction. If usage exceeds reservation, this calculation
> underflows and creates a transaction with an invalid and excessive
> reservation. When the second transaction commits, the release of
> unused blocks corrupts the in-core free space counters. With lazy
> superblock accounting enabled, this inconsistency eventually
> trickles to the on-disk superblock and corrupts the filesystem.
> 
> Replace the transaction block usage accounting assert with an
> explicit overrun check. If the transaction overruns the reservation,
> shutdown the filesystem immediately to prevent corruption. Add a new
> assert to xfs_trans_dup() to catch any callers that might induce
> this invalid state in the future.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
