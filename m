Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdALNxN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2017 08:53:13 -0500
Date: Thu, 12 Jan 2017 05:53:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs_io: fix the minimum arguments to the reflink
 command
Message-ID: <20170112135309.GA5756@infradead.org>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419039493.32674.9443275401625618997.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148419039493.32674.9443275401625618997.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 07:06:34PM -0800, Darrick J. Wong wrote:
> The reflink command can reflink the entirety of two files if the
> offsets and lengths are not specified... but we forgot to permit
> that case.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
