Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50669 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbdIUOEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 10:04:21 -0400
Date: Thu, 21 Sep 2017 07:04:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: perag initialization should only touch
 m_ag_max_usable for AG 0
Message-ID: <20170921140421.GA24142@infradead.org>
References: <20170919181041.GC7112@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919181041.GC7112@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 19, 2017 at 11:10:41AM -0700, Darrick J. Wong wrote:
> We call __xfs_ag_resv_init to make a per-AG reservation for each AG.
> This makes the reservation per-AG, not per-filesystem.  Therefore, it
> is incorrect to adjust m_ag_max_usable for each AG.  Adjust it only
> when we're reserving AG 0's blocks so that we only do it once per fs.

This looks correct to me, but I hate how we manipulate a per-mount
value.  Is there a way we can just move this to the caller?
