Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46690 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbeJQQcR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 12:32:17 -0400
Date: Wed, 17 Oct 2018 01:37:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 24/26] xfs: fix pagecache truncation prior to reflink
Message-ID: <20181017083738.GH16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153966004854.3607.15187709452762502392.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153966004854.3607.15187709452762502392.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Oct 15, 2018 at 08:20:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Prior to remapping blocks, it is necessary to remove pages from the
> destination file's page cache.  Unfortunately, the truncation is not
> aggressive enough -- if page size > block size, we'll end up zeroing
> subpage blocks instead of removing them.  So, round the start offset
> down and the end offset up to page boundaries.  We already wrote all
> the dirty data so the larger range shouldn't be a problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
