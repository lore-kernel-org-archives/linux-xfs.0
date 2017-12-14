Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60800 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdLNQkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 11:40:18 -0500
Date: Thu, 14 Dec 2017 08:40:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: avoid infinite loop when cancelling CoW blocks
 after writeback failure
Message-ID: <20171214164018.GE32616@infradead.org>
References: <151295857424.30614.8269461794142248028.stgit@magnolia>
 <151295860804.30614.8264763311495796776.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151295860804.30614.8264763311495796776.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Dec 10, 2017 at 06:16:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're cancelling a cow range, we don't always delete each extent
> that we iterate, so we have to move icur backwards in the list to avoid
> an infinite loop.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
