Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:19919 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751461AbeFDB4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 21:56:40 -0400
Date: Mon, 4 Jun 2018 11:56:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/14] xfs: repair the AGI
Message-ID: <20180604015637.GK10363@dastard>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
 <152770865219.11611.15383367715338540008.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152770865219.11611.15383367715338540008.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 30, 2018 at 12:30:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rebuild the AGI header items with some help from the rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks OK, but I can't help but think it should be structured similar
to the AGF rebuild, even though the functions would be smaller and
simpler...

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
