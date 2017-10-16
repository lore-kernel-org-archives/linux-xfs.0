Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6776 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751724AbdJPDCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 23:02:55 -0400
Date: Mon, 16 Oct 2017 14:02:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 20/30] xfs: scrub refcount btrees
Message-ID: <20171016030252.GW3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777257372.1724.10044986248908141456.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777257372.1724.10044986248908141456.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:42:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Plumb in the pieces necessary to check the refcount btree.  If rmap is
> available, check the reference count by performing an interval query
> against the rmapbt.

....

> +/* Scrub a refcountbt record. */
> +STATIC int
> +xfs_scrub_refcountbt_helper(

s/helper/rec/

Apart from that

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
