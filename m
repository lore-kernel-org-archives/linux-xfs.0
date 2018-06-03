Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11937 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751132AbeFCXli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:41:38 -0400
Date: Mon, 4 Jun 2018 09:41:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/10] xfs: don't forbid setting dax flag on directories
 if device doesn't dax
Message-ID: <20180603234136.GX10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806814871.18187.4240645095990301961.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152806814871.18187.4240645095990301961.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:22:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> On a directory, the DAX flag is merely a hint that files created in the
> directory should have the DAX flag set at creation time.  We don't care
> if the underlying device supports DAX or not because directory metadata
> are always cached in DRAM.  We don't care if new files get the flag even
> if the device doesn't support DAX because we always check for DAX
> support before setting the VFS flag (S_DAX).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Am I correct in assuming this allows directory hints to work on
a filesystem with a DAX capable RT device, but a normal data device?

Regardless, behaviour seems sensible to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
