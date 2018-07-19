Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731625AbeGSR1x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 13:27:53 -0400
Date: Thu, 19 Jul 2018 09:43:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: trivial xfs_btree_del_cursor cleanups
Message-ID: <20180719164353.GF10151@infradead.org>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192905163.31685.17441257298247003323.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192905163.31685.17441257298247003323.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 08:50:51AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The error argument to xfs_btree_del_cursor already understands the
> "nonzero for error" semantics, so remove pointless error testing in the
> callers and pass it directly.

Looks fine, but we should also get rid of the XFS_BTREE_ERROR and
XFS_BTREE_NOERROR defines as mixing them with errno values is going
to be very confusing.

Reviewed-by: Christoph Hellwig <hch@lst.de>

(assuming we get another patch for the above eventually)
