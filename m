Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34549 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751690AbdJPDBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 23:01:44 -0400
Date: Mon, 16 Oct 2017 14:01:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/30] xfs: scrub rmap btrees
Message-ID: <20171016030141.GV3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777256757.1724.13349855746665148673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777256757.1724.13349855746665148673.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:42:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the reverse mapping records to make sure that the contents
> make sense.

Minor:

> +/* Scrub an rmapbt record. */
> +STATIC int
> +xfs_scrub_rmapbt_helper(

s/helper/rec/

otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
