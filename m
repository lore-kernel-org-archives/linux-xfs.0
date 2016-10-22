Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46752 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932389AbcJVIqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Oct 2016 04:46:39 -0400
Date: Sat, 22 Oct 2016 01:46:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: fix up inode cowblocks tracking tracepoints
Message-ID: <20161022084639.GA7734@infradead.org>
References: <1477070533-59327-1-git-send-email-bfoster@redhat.com>
 <1477070533-59327-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477070533-59327-2-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2016 at 01:22:11PM -0400, Brian Foster wrote:
> These calls are still using the eofblocks tracepoints. The cowblocks
> equivalents are already defined, we just aren't actually calling them.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
