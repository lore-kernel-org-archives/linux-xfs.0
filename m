Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbeKTSRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 13:17:41 -0500
Date: Mon, 19 Nov 2018 23:49:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] vfs: vfs_dedupe_file_range() doesn't return
 EOPNOTSUPP
Message-ID: <20181120074956.GC25418@infradead.org>
References: <20181119211742.8824-1-david@fromorbit.com>
 <20181119211742.8824-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119211742.8824-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Nov 20, 2018 at 08:17:42AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It returns EINVAL when the operation is not supported by the
> filesystem. Fix it to return EOPNOTSUPP to be consistent with
> the man page and clone_file_range().
> 
> Clean up the inconsistent error return handling while I'm there.
> (I know, lipstick on a pig, but every little bit helps...)
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.  And I really like the removal of the pointless goto
out uses..

Reviewed-by: Christoph Hellwig <hch@lst.de>
