Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31880 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933039AbcI3R1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 13:27:23 -0400
Date: Fri, 30 Sep 2016 10:26:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 20/63] xfs: log bmap intent items
Message-ID: <20160930172651.GL14092@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520486550.29434.1414641708433838018.stgit@birch.djwong.org>
 <20160930072650.GB13587@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930072650.GB13587@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Sep 30, 2016 at 12:26:50AM -0700, Christoph Hellwig wrote:
> > +/* The XFS_BMAP_EXTENT_* in xfs_log_format.h must match these. */
> > +enum xfs_bmap_intent_type {
> > +	XFS_BMAP_MAP = 1,
> > +	XFS_BMAP_UNMAP,
> > +};
> 
> Meh.  Please just use it directly then.
> 
> Otherwise this looks ok, so a conditional:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> based on fixing the above.

The log format items actually /do/ store the enum values directly into a
u32 now.  Evidently I forgot to update the comment.

--D
