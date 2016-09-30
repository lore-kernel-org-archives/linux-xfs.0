Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45319 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcI3Hrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:47:31 -0400
Date: Fri, 30 Sep 2016 00:47:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 38/63] xfs: cancel CoW reservations and clear inode
 reflink flag when freeing blocks
Message-ID: <20160930074730.GE951@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520498644.29434.5014643991183828847.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520498644.29434.5014643991183828847.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:09:46PM -0700, Darrick J. Wong wrote:
> When we're freeing blocks (truncate, punch, etc.), clear all CoW
> reservations in the range being freed.  If the file block count
> drops to zero, also clear the inode reflink flag.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
