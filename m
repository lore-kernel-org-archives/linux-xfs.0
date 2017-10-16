Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49690 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932519AbdJPXxI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 19:53:08 -0400
Date: Tue, 17 Oct 2017 10:53:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 05/30] xfs: create inode pointer verifiers
Message-ID: <20171016235306.GP15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777247562.1724.7094279740133124537.stgit@magnolia>
 <20171016194932.GH4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016194932.GH4703@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 12:49:32PM -0700, Darrick J. Wong wrote:
> Create some helper functions to check that inode pointers point to
> somewhere within the filesystem and not at the static AG metadata.
> Move xfs_internal_inum and create a directory inode check function.
> We will use these functions in scrub and elsewhere.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix names, fix incorrect results returned from agino_range, remove
> unnecessary tests

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
