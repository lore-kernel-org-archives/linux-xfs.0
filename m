Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40100 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfARLuy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 06:50:54 -0500
Date: Fri, 18 Jan 2019 03:50:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/5] xfs: remove superfluous writeback mapping eof
 trimming
Message-ID: <20190118115054.GC7807@infradead.org>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117192004.49346-5-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 02:20:03PM -0500, Brian Foster wrote:
> Now that the cached writeback mapping is explicitly invalidated on
> data fork changes, the EOF trimming band-aid is no longer necessary.
> Remove xfs_trim_extent_eof() as well since it has no other users.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
