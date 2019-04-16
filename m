Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33384 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726857AbfDPH5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 03:57:39 -0400
Date: Tue, 16 Apr 2019 17:57:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 4/5] xfs: scrub/repair should update filesystem
 metadata health
Message-ID: <20190416075737.GL29573@dread.disaster.area>
References: <155537397092.27935.16073573221774618735.stgit@magnolia>
 <155537399567.27935.2695652869908662243.stgit@magnolia>
 <20190416014309.GJ4752@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416014309.GJ4752@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, Apr 15, 2019 at 06:43:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have the ability to track sick metadata in-core, make scrub
> and repair update those health assessments after doing work.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: rename sick_mask_update to sick_mask.
> ---

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
