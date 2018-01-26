Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41936 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751861AbeAZTBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 14:01:18 -0500
Date: Fri, 26 Jan 2018 11:00:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/11] xfs: track CoW blocks separately in the inode
Message-ID: <20180126190058.GZ9068@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676030942.12349.14467032190779795677.stgit@magnolia>
 <20180126121546.GB15859@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126121546.GB15859@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 26, 2018 at 04:15:46AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 23, 2018 at 06:18:29PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Track the number of blocks reserved in the CoW fork so that we can
> > move the quota reservations whenever we chown, and don't account for
> > CoW fork delalloc reservations in i_delayed_blks.  This should make
> > chown work properly for quota reservations, enables us to fully
> > account for real extents in the cow fork in the file stat info, and
> > improves the post-eof scanning decisions because we're no longer
> > confusing data fork delalloc extents with cow fork delalloc extents.
> 
> Just curious:  is there any good reason we can't just have an
> i_extra_blocks field for the delayed and cow blocks?  Or is there
> a place where we care about the difference between the two?

"cow blocks" now includes real and unwritten extents sitting around in
the cow fork in addition to delalloc extents in the cow fork, and I
didn't want the field to have overlapping meanings.  On a practical
level, it also means we avoid eofblocks scans on inodes that have cow
blocks but no da blocks.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
