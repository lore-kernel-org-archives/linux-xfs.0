Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50996 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbcI3I2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:28:55 -0400
Date: Fri, 30 Sep 2016 01:28:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 62/63] xfs: refactor swapext code
Message-ID: <20160930082854.GO32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520514595.29434.16757984122949209084.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520514595.29434.16757984122949209084.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:12:26PM -0700, Darrick J. Wong wrote:
> Refactor the swapext function to pull out the fork swapping piece
> into a separate function.  In the next patch we'll add in the bit
> we need to make it work with rmap filesystems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
