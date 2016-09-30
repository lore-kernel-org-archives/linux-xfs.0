Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbcI3IYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:24:07 -0400
Date: Fri, 30 Sep 2016 01:24:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 53/63] xfs: add shared rmap map/unmap/convert log item
 types
Message-ID: <20160930082406.GF32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520508464.29434.7580776188595193285.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520508464.29434.7580776188595193285.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:11:24PM -0700, Darrick J. Wong wrote:
> Wire up some rmap log redo item type codes to map, unmap, or convert
> shared data block extents.  The actual log item recovery comes in a
> later patch.

Looks fine, although I don't really understand what the point of this
fine grained patch split is..

Reviewed-by: Christoph Hellwig <hch@lst.de>
