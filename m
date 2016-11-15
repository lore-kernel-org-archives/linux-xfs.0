Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966686AbcKOKUw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:20:52 -0500
Date: Tue, 15 Nov 2016 02:20:51 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/16] libxfs: remove useless stuff from the kernel
Message-ID: <20161115102051.GN1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830456618.26713.15449667779126141448.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830456618.26713.15449667779126141448.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:09:26PM -0700, Darrick J. Wong wrote:
> Evidently the libxfs-apply script sucked in some fs/xfs/ content from
> the kernel patches and an extra redefinition of _bmap_search_extents.
> We don't need this, so get rid of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
