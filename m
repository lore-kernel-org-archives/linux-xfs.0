Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38687 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbcI3HIu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:08:50 -0400
Date: Fri, 30 Sep 2016 00:08:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/63] vfs: add a FALLOC_FL_UNSHARE mode to fallocate to
 unshare a range of blocks
Message-ID: <20160930070849.GD18305@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520474825.29434.11791614565389664342.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520474825.29434.11791614565389664342.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:05:48PM -0700, Darrick J. Wong wrote:
> Add a new fallocate mode flag that explicitly unshares blocks on
> filesystems that support such features.  The new flag can only
> be used with an allocate-mode fallocate call.

We will also need a manpage addition for this.  And while we're at
it an explanation of fallocate on COW files for btrfs, ocfs2 and
XFS as I don't think we are very coherent or obvious at the moment.

Well, maybe that's just future work.  For now:

Reviewed-by: Christoph Hellwig <hch@lst.de>
