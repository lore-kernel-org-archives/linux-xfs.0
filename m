Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50939 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbcI3IZs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:25:48 -0400
Date: Fri, 30 Sep 2016 01:25:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 56/63] xfs: set a default CoW extent size of 32 blocks
Message-ID: <20160930082547.GI32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520510452.29434.5207119763591103950.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520510452.29434.5207119763591103950.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:11:44PM -0700, Darrick J. Wong wrote:
> If the admin doesn't set a CoW extent size or a regular extent size
> hint, default to creating CoW reservations 32 blocks long to reduce
> fragmentation.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although a constant for the magic number of 32 would have been nice.
