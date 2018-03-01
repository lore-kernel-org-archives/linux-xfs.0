Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61892 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1162460AbeCAWMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 17:12:05 -0500
Date: Fri, 2 Mar 2018 09:12:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: implement the lazytime mount option
Message-ID: <20180301221202.GO30854@dastard>
References: <20180228175737.317-1-hch@lst.de>
 <20180228175737.317-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180228175737.317-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

On Wed, Feb 28, 2018 at 09:57:37AM -0800, Christoph Hellwig wrote:
> Use the VFS dirty inode tracking for lazytime inodes only, and just
> log them in ->dirty_inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Works fine. I can't think of a cleaner way to implement this, so it
looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
