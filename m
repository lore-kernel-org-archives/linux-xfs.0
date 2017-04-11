Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54003 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752757AbdDKFmC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 01:42:02 -0400
Date: Tue, 11 Apr 2017 07:42:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] xfs: introduce xfs_bmapi_remap
Message-ID: <20170411054201.GA27917@lst.de>
References: <20170403121833.7825-1-hch@lst.de> <20170403121833.7825-5-hch@lst.de> <20170410195004.GA10459@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170410195004.GA10459@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Apr 10, 2017 at 12:50:04PM -0700, Darrick J. Wong wrote:
> Why change all this if the next patch removes the whole function except:
> 
> ip->i_d.di_nblocks += length;
> xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> 
> Wouldn't it make more sense to have this patch add _bmapi_remap (as it
> appears in the next patch) and change the callers to use it; and then
> the next patch removes the old _bmap_remap_alloc and its callers?

I'd rather keep steps as small and self-explaining as possible,
so one is factoring out a new helper, and the other is removing a call
that's no needed.

> > +	else if (ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
> > +		logflags &= ~XFS_ILOG_DBROOT;
> > +
> > +	if (logflags)
> > +		xfs_trans_log_inode(tp, ip, logflags);
> > +	if (cur) {
> > +		xfs_btree_del_cursor(cur,
> > +			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> 
> Double indent here?

Sure..
