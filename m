Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:15624 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753349AbeAJAQC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 19:16:02 -0500
Date: Wed, 10 Jan 2018 11:15:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 14/21] xfs: cross-reference with the bnobt
Message-ID: <20180110001529.GR16421@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398985848.18741.1443595678961710395.stgit@magnolia>
 <20180109211536.GI5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109211536.GI5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 01:15:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're scrubbing various btrees, cross-reference the records with
> the bnobt to ensure that we don't also think the space is free.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: streamline scrubber arguments, remove stack allocated objects
> ---

Looks much better.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
