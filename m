Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54975 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbdLNQkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 11:40:35 -0500
Date: Thu, 14 Dec 2017 08:40:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: allow CoW remap transactions to use reserve
 blocks
Message-ID: <20171214164035.GF32616@infradead.org>
References: <151295857424.30614.8269461794142248028.stgit@magnolia>
 <151295861910.30614.17925324546800268919.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151295861910.30614.17925324546800268919.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Dec 10, 2017 at 06:16:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since we as yet have no way of holding on to the indlen blocks that are
> reserved as part of CoW fork delalloc reservations, let the CoW remap
> transaction dip into the reserves so that we avoid failing writes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
