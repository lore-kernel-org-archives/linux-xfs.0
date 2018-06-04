Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:2388 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751771AbeFDAPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 20:15:42 -0400
Date: Mon, 4 Jun 2018 10:15:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/10] xfs: don't ASSERT on short form btree root pointer
 of zero
Message-ID: <20180604001540.GG10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806820166.18187.3892893338496519833.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152806820166.18187.3892893338496519833.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:23:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't ASSERT if the short form btree root pointer is zero.  Now that we
> use xfs_verify_agbno to check all short form btree pointers, we'll let
> that log the error and pass it to the upper layers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
