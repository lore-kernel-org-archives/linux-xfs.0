Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:23879 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934301AbdLSENQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 23:13:16 -0500
Date: Tue, 19 Dec 2017 15:13:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/13] xfs: verify dinode header first
Message-ID: <20171219041312.GN4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320952356.30654.13855911861316331973.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151320952356.30654.13855911861316331973.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 03:58:43PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the v3 inode integrity information (crc, owner, metauuid) before we
> look at anything else in the inode so that we don't waste time on a torn
> write or a totally garbled block.  This makes xfs_dinode_verify more
> consistent with the other verifiers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
