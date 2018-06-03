Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5258 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751593AbeFCXvi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:51:38 -0400
Date: Mon, 4 Jun 2018 09:51:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfs: don't assert when reporting on-disk
 corruption while loading btree
Message-ID: <20180603235136.GA10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806817663.18187.1063422880493258360.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152806817663.18187.1063422880493258360.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:22:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't bother ASSERTing when we're already going to log and return the
> corruption status.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Make sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
