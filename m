Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50952 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbcI3I05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:26:57 -0400
Date: Fri, 30 Sep 2016 01:26:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 58/63] xfs: don't mix reflink and DAX mode for now
Message-ID: <20160930082656.GK32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520511715.29434.14793907325765131489.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520511715.29434.14793907325765131489.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:11:57PM -0700, Darrick J. Wong wrote:
> Since we don't have a strategy for handling both DAX and reflink,
> for now we'll just prohibit both being set at the same time.

I think we're about ready to lift this limitation, but let's not delay
the series for that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
