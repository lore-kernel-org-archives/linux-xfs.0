Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfAQOTX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:19:23 -0500
Date: Thu, 17 Jan 2019 06:19:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/22] xfs: convert projid get/set functions
Message-ID: <20190117141923.GB16270@infradead.org>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630915987.18437.2499418741534604769.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630915987.18437.2499418741534604769.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:19:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the projid get and set functions to work on xfs_icdinode like
> they do in userspace.  xfs_db needs the icdinode version.

No new users of xfs_icdinode, please.  I actually have a series to
kill it off that I need to dust off once I've got a little time.
