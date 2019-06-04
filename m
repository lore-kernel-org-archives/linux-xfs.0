Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55449 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726595AbfFDG1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 02:27:49 -0400
Date: Tue, 4 Jun 2019 16:27:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 20/20] xfs: remove the b_io_length field in struct xfs_buf
Message-ID: <20190604062745.GU29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-21-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-21-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:45PM +0200, Christoph Hellwig wrote:
> This field is now always idential to b_length.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c         | 5 ++---
>  fs/xfs/xfs_buf.h         | 1 -
>  fs/xfs/xfs_log_recover.c | 9 ++++-----
>  3 files changed, 6 insertions(+), 9 deletions(-)

One less size field to confuse me.i Looks like most of the remaining
uses of that variable should have been using b_length in the first
place, so this is good to finally have cleaned up.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
