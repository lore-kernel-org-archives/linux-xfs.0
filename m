Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752445AbdKWN0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 08:26:06 -0500
Date: Thu, 23 Nov 2017 05:26:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Don't trim file extents during iomap
Message-ID: <20171123132606.GA21798@infradead.org>
References: <1511437203-4329-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511437203-4329-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, sandeen@redhat.com, darrick.wong@oracle.com

On Thu, Nov 23, 2017 at 01:40:03PM +0200, Nikolay Borisov wrote:
> For file extents xfs currently calls xfs_bmapi_read with flag set to 0,
> meaning extents are going to be truncated to the requested range. Since the
> same codepath is used for fiemap this means xfs is special in that regard, since
> other filesystems (ext4/btrfs) do not trim extents for fiemap. Make the behavior
> consistent by always passing XFS_BMAPI_ENTIRE. A full xfstest run validated that
> this doesn't regress on ordinary read/write IO.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks good, except that the changelog could use line wrapping at
75 characters :)

Reviewed-by: Christoph Hellwig <hch@lst.de>
