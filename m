Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40972 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfAQX3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 18:29:25 -0500
Date: Thu, 17 Jan 2019 15:29:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 22/22] xfs: create library function to reset root inodes
Message-ID: <20190117232913.GK4424@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630929346.18437.14185691799928569579.stgit@magnolia>
 <20190117142525.GG16270@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117142525.GG16270@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 06:25:25AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 31, 2018 at 06:21:33PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a library function to reset a root inode, which xfs_repair will
> > take advantage of in xfsprogs.
> 
> And which will just add dead code to the kernel?

Fair enough, it can live in xfs_repair.

--D
