Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42885 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933265AbcI3HUk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:20:40 -0400
Date: Fri, 30 Sep 2016 00:20:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 28/63] xfs: don't allow reflinked
 dir/dev/fifo/socket/pipe files
Message-ID: <20160930072039.GO18305@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520492235.29434.5736614103531299436.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520492235.29434.5736614103531299436.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:08:42PM -0700, Darrick J. Wong wrote:
> Only non-rt files can be reflinked, so check that when we load an
> inode.  Also, don't leak the attr fork if there's a failure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
