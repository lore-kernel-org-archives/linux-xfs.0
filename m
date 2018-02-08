Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbeBHB57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 20:57:59 -0500
Date: Wed, 7 Feb 2018 17:57:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] xfs: rename agfl perag res type to rmapbt
Message-ID: <20180208015754.GE5433@magnolia>
References: <20180205174601.51574-1-bfoster@redhat.com>
 <20180205174601.51574-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180205174601.51574-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 05, 2018 at 12:46:00PM -0500, Brian Foster wrote:
> The AGFL perag reservation type accounts all allocations that feed
> into (or are released from) the allocation group free list (agfl).
> The purpose of the reservation is to support worst case conditions
> for the reverse mapping btree (rmapbt). As such, the agfl
> reservation usage accounting only considers rmapbt usage when the
> in-core counters are initialized at mount time.
> 
> This implementation inconsistency leads to divergence of the in-core
> and on-disk usage accounting over time. In preparation to resolve
> this inconsistency and adjust the AGFL reservation into an rmapbt
> specific reservation, rename the AGFL reservation type and
> associated accounting fields to something more rmapbt-specific. Also
> fix up a couple tracepoints that incorrectly use the AGFL
> reservation type to pass the agfl state of the associated extent
> where the raw reservation type is expected.
> 
> Note that this patch does not change perag reservation behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, though the tracepoint fix should probably be a standalone
patch.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
