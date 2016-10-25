Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:26985 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S941746AbcJYVGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 17:06:07 -0400
Date: Wed, 26 Oct 2016 08:06:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs/054: only filter ROOT_INO at the beginning
Message-ID: <20161025210604.GC14023@dastard>
References: <1477402729-13934-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477402729-13934-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 09:38:49PM +0800, Eryu Guan wrote:
> In the test ROOT_INO is filtered out and/or replaced, but if
> ROOT_INO is also 32, more "32"s are filtered and replaced than
> expected. This happens to me when testing 512B block size XFS and 1k
> block size CRC enabled XFS.
> 
> Fix it by filtering out only ROOT_INO at the beginning of a line,
> and removing all "g" modifiers in sed expressions.
> 
> Also the ROOT_INO should be the root inode number of TEST_DIR not
> SCRATCH_MNT.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
