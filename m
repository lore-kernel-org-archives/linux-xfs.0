Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdAXJsa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 04:48:30 -0500
Date: Tue, 24 Jan 2017 01:48:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: verify dirblocklog correctly
Message-ID: <20170124094830.GA21544@infradead.org>
References: <20170124004655.GG31202@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124004655.GG31202@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jan 23, 2017 at 04:46:55PM -0800, Darrick J. Wong wrote:
> sb_dirblklog is added to sb_blocklog to compute the directory block size
> in bytes.  Therefore, we must compare the sum of both those values
> against XFS_MAX_BLOCKSIZE_LOG, not just dirblklog.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
