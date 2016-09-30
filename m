Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47735 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbcI3HxU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:53:20 -0400
Date: Fri, 30 Sep 2016 00:53:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 43/63] xfs: add dedupe range vfs function
Message-ID: <20160930075319.GD17618@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520502044.29434.18210922155003779454.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520502044.29434.18210922155003779454.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:10:20PM -0700, Darrick J. Wong wrote:
> Define a VFS function which allows userspace to request that the
> kernel reflink a range of blocks between two files if the ranges'
> contents match.  The function fits the new VFS ioctl that standardizes
> the checking for the btrfs EXTENT SAME ioctl.

Nothing in the compare functionality is really XFS specific, so it
might be a nice idea to share this between btrfs and XFS in the future
and move it common code.  Except for that this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
