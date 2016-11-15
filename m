Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755630AbcKOKUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:20:23 -0500
Date: Tue, 15 Nov 2016 02:20:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/16] libxfs: synchronize dinode_verify with userspace
Message-ID: <20161115102022.GM1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830456011.26713.11759326361226626805.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830456011.26713.11759326361226626805.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:09:20PM -0700, Darrick J. Wong wrote:
> The userspace version of _dinode_verify takes a raw inode number
> instead of an inode itself.  Since neither version actually needs
> the inode, port the changes to the kernel.  This will also reduce
> the libxfs diff noise.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
