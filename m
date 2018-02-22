Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34031 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751978AbeBVEhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Feb 2018 23:37:06 -0500
Date: Thu, 22 Feb 2018 15:37:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reserve blocks for refcount / rmap log item recovery
Message-ID: <20180222043703.GA28971@dastard>
References: <20180221033854.GK27629@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180221033854.GK27629@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 20, 2018 at 07:38:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During log recovery, the per-AG reservations aren't yet set up, so log
> recovery has to reserve enough blocks to handle all possible btree
> splits.
> 
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This appears to have fixed all the random recovery failures I was
having through fstests. The logic seems sounds, too, so

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
