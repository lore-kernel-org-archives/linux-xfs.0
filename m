Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfAQOWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:22:37 -0500
Date: Thu, 17 Jan 2019 06:22:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/22] xfs: decouple platform-specific inode allocation
 functions
Message-ID: <20190117142237.GE16270@infradead.org>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630918439.18437.3847814286604639982.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630918439.18437.3847814286604639982.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:19:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Decouple the xfs_ialloc function from the platform-specific pieces by
> passing in an operations structure.  This prepares the function for
> hoisting to libxfs.

What "platform"?
