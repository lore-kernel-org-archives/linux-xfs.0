Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42723 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753399AbcJZQd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 12:33:56 -0400
Date: Wed, 26 Oct 2016 09:33:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/39] xfs_db: metadump should copy the refcount btree too
Message-ID: <20161026163322.GA26572@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743668609.11035.16781673871765061912.stgit@birch.djwong.org>
 <20161026102940.GI29648@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026102940.GI29648@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 03:29:40AM -0700, Christoph Hellwig wrote:
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Do we have a testcase for metadump on a reflink fs, btw?

xfs/129 for refcountbt, xfs/234 for rmapbt, and xfs/336 for realtime rmap.

--D
