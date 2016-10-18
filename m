Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54323 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932836AbcJRFTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 01:19:39 -0400
Date: Mon, 17 Oct 2016 22:19:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] misc: fix fallocate commands that need the unshare
 switch
Message-ID: <20161018051937.GB31237@infradead.org>
References: <147674215521.23842.13841682595738466897.stgit@birch.djwong.org>
 <147674216832.23842.4457619951534662629.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147674216832.23842.4457619951534662629.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, eguan@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, fstests@vger.kernel.org

On Mon, Oct 17, 2016 at 03:09:28PM -0700, Darrick J. Wong wrote:
> We re-added the UNSHARE flag to fallocate, so go make sure that all
> the unshare tests actually check that the installed copy of xfs_io
> supports the 'funshare' command and that the underlying filesystem
> understands the flag, and change the tests themselves to use
> funshare.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine, and tests fine on XFS, btrfs and ext4:

Reviewed-by: Christoph Hellwig <hch@lst.de>
