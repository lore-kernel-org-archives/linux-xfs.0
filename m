Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:1223 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932080AbdJQWLc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2017 18:11:32 -0400
Date: Wed, 18 Oct 2017 09:11:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 28/30] xfs: scrub directory parent pointers
Message-ID: <20171017221130.GV15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777262776.1724.11135251107601015017.stgit@magnolia>
 <20171017001603.GY4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171017001603.GY4703@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 05:16:03PM -0700, Darrick J. Wong wrote:
> Scrub parent pointers, sort of.  For directories, we can ride the
> '..' entry up to the parent to confirm that there's at most one
> dentry that points back to this directory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: refactor the single-ilock-retry code into a separate validate function

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
