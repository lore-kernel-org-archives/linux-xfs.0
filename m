Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:39512 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754395AbeAaXv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 18:51:27 -0500
Date: Thu, 1 Feb 2018 10:52:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't allow DAX on reflink filesystems
Message-ID: <20180131235221.tglyplgzo3kj25sc@destitution>
References: <20180131222324.GH4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180131222324.GH4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, Jan 31, 2018 at 02:23:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that reflink is no longer experimental, reject attempts to mount
> with DAX until that whole mess gets sorted out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Make sense. Anyone trying to make this work needs to patch the
kernel, so having to patch out this check is no big deal.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
