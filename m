Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37006 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751100AbeAEBNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 20:13:54 -0500
Date: Fri, 5 Jan 2018 12:12:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/21] xfs: ignore agfl read errors when not scrubbing
 agfl
Message-ID: <20180105011215.GO30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398977659.18741.2172605369601254389.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398977659.18741.2172605369601254389.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:42:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_scrub_ag_read_headers, if we're not scrubbing the AGFL but
> hit a read error reading the AGFL, we should reset the error code
> so that it doesn't propagate up into the caller.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
