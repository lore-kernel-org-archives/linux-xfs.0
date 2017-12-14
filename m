Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58620 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdLNQhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 11:37:11 -0500
Date: Thu, 14 Dec 2017 08:37:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: account for null transactions in bunmapi
Message-ID: <20171214163710.GA32616@infradead.org>
References: <151295857424.30614.8269461794142248028.stgit@magnolia>
 <151295858045.30614.4101979123861411900.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151295858045.30614.4101979123861411900.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Dec 10, 2017 at 06:16:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In e1a4e37cc7b665 ("xfs: try to avoid blowing out the transaction
> reservation when bunmaping a shared extent"), we try to constrain the
> amount of real extents we unmap from the data fork in a given call so
> that we don't blow out transaction reservations.
> 
> However, not all bunmapi operations require a transaction -- if we're
> only removing a delalloc extent, no transaction is needed, so we have to
> code against that.

Looks good for now.  And reminds me that I need to submit my patch
to get rid of that special case :)

Reviewed-by: Christoph Hellwig <hch@lst.de>
