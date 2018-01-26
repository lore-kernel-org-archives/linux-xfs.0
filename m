Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42611 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbeAZMPr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 07:15:47 -0500
Date: Fri, 26 Jan 2018 04:15:46 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] xfs: track CoW blocks separately in the inode
Message-ID: <20180126121546.GB15859@infradead.org>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676030942.12349.14467032190779795677.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676030942.12349.14467032190779795677.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 06:18:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Track the number of blocks reserved in the CoW fork so that we can
> move the quota reservations whenever we chown, and don't account for
> CoW fork delalloc reservations in i_delayed_blks.  This should make
> chown work properly for quota reservations, enables us to fully
> account for real extents in the cow fork in the file stat info, and
> improves the post-eof scanning decisions because we're no longer
> confusing data fork delalloc extents with cow fork delalloc extents.

Just curious:  is there any good reason we can't just have an
i_extra_blocks field for the delayed and cow blocks?  Or is there
a place where we care about the difference between the two?
