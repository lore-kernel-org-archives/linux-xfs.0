Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:4141 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751052AbeFDWAz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 18:00:55 -0400
Date: Tue, 5 Jun 2018 08:00:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/4] xfs: explicitly pass buffer size to
 xfs_corruption_error
Message-ID: <20180604220053.GU10363@dastard>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
 <20180604191730.GO7825@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180604191730.GO7825@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 12:17:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Explicitly pass the buffer length to xfs_corruption_error() instead of
> assuming XFS_CORRUPTION_DUMP_LEN so that we avoid dumping off the end
> of the pointer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
