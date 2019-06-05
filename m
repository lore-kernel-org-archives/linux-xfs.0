Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48230 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFEAYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 20:24:17 -0400
Date: Tue, 4 Jun 2019 17:24:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] xfs: fix inode_cluster_size rounding mayhem
Message-ID: <20190605002411.GF1200785@magnolia>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
 <155968495968.1657505.12432054087739349861.stgit@magnolia>
 <20190604220518.GA29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604220518.GA29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 08:05:18AM +1000, Dave Chinner wrote:
> On Tue, Jun 04, 2019 at 02:49:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > inode_cluster_size is supposed to represent the size (in bytes) of an
> > inode cluster buffer.  We avoid having to handle multiple clusters per
> > filesystem block on filesystems with large blocks by openly rounding
> > this value up to 1 FSB when necessary.  However, we never reset
> > inode_cluster_size to reflect this new rounded value, which adds to the
> > potential for mistakes in calculating geometries.
> > 
> > Fix this by setting inode_cluster_size to reflect the rounded-up size if
> > needed, and special-case the few places in the sparse inodes code where
> > we actually need the smaller value to validate on-disk metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> LGTM.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks for the review!

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
