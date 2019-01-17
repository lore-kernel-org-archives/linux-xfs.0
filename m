Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34110 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfAQTQg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 14:16:36 -0500
Date: Thu, 17 Jan 2019 11:16:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/22] xfs: convert projid get/set functions
Message-ID: <20190117191623.GG4424@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630915987.18437.2499418741534604769.stgit@magnolia>
 <20190117141923.GB16270@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117141923.GB16270@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 06:19:23AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 31, 2018 at 06:19:19PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert the projid get and set functions to work on xfs_icdinode like
> > they do in userspace.  xfs_db needs the icdinode version.
> 
> No new users of xfs_icdinode, please.  I actually have a series to
> kill it off that I need to dust off once I've got a little time.

Heh, I just realized that the xfs_db caller of xfs_get_projid actually
does have the corresponding (struct xfs_inode *) in local variable scope
so I can fix the xfsprogs version of this function.

--D
