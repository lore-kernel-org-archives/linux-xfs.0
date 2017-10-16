Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:34301 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751060AbdJPFQr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 01:16:47 -0400
Date: Mon, 16 Oct 2017 16:16:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/30] xfs: scrub the secondary superblocks
Message-ID: <20171016051644.GH3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777253648.1724.14074690877454400591.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777253648.1724.14074690877454400591.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:42:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ensure that the geometry presented in the backup superblocks matches
> the primary superblock so that repair can recover the filesystem if
> that primary gets corrupted.

I've noticed that scrub on certain fstests will report PREEN for
secondary superblocks and repair thinks there is nothing wrong and
doesn't fix them. I'm not sure which field it's complaining about,
but at this point I don't see this as a blocker. Follow up patches
would be fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
