Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46131 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751337AbdEQAjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2017 20:39:35 -0400
Date: Wed, 17 May 2017 10:39:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid mount-time deadlock in CoW extent recovery
Message-ID: <20170517003931.GN17542@dastard>
References: <20170516192748.GQ4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170516192748.GQ4519@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, May 16, 2017 at 12:27:48PM -0700, Darrick J. Wong wrote:
> If a malicious user corrupts the refcount btree to cause a cycle between
> different levels of the tree, the next mount attempt will deadlock in
> the CoW recovery routine while grabbing buffer locks.  We can use the
> ability to re-grab a buffer that was previous locked to a transaction to
> avoid deadlocks, so do that here.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Missing comments in the code explaining the deadlock being avoided
by using xfs_trans_alloc_empty()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
