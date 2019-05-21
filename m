Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55946 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbfEUIe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 04:34:58 -0400
Date: Tue, 21 May 2019 01:34:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] libxfs: fix argument to xfs_trans_add_item
Message-ID: <20190521083458.GD533@infradead.org>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
 <1558410427-1837-5-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558410427-1837-5-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 10:47:04PM -0500, Eric Sandeen wrote:
> The hack of casting an inode_log_item or buf_log_item to a
> xfs_log_item_t is pretty gross; yes it's the first member in the
> structure, but yuk.  Pass in the correct structure member.
> 
> This was fixed in the kernel with commit e98c414f9
> ("xfs: simplify log item descriptor tracking")
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
