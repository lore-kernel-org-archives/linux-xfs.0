Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:6214 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751506AbdJPCSY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 22:18:24 -0400
Date: Mon, 16 Oct 2017 13:18:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/30] xfs: scrub AGF and AGFL
Message-ID: <20171016021819.GR3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777254274.1724.15950286721367258242.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777254274.1724.15950286721367258242.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:42:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the block references in the AGF and AGFL headers to make sure
> they make sense.

Looks good. Much simpler without all the duplicated AG header
reading. :P

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
