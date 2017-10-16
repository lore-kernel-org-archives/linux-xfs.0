Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:60971 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751060AbdJPFLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 01:11:05 -0400
Date: Mon, 16 Oct 2017 16:11:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 29/30] xfs: scrub realtime bitmap/summary
Message-ID: <20171016051102.GF3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777263398.1724.10464088394123475758.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777263398.1724.10464088394123475758.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:43:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Perform simple tests of the realtime bitmap and summary.

....

> +/* Realtime bitmap. */
> +
> +/* Scrub a free extent record from the realtime bitmap. */
> +STATIC int
> +xfs_scrub_rtbitmap_helper(

s/helper/rec/

Otherwise good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
