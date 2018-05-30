Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:4896 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753691AbeE3Wqq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 18:46:46 -0400
Date: Thu, 31 May 2018 08:46:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] fs: move page_cache_seek_hole_data to iomap.c
Message-ID: <20180530224637.GW10363@dastard>
References: <20180530100208.31490-1-hch@lst.de>
 <20180530100208.31490-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100208.31490-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, May 30, 2018 at 12:02:06PM +0200, Christoph Hellwig wrote:
> This function is only used by the iomap code, depends on being called
> from it, and will soon stop poking into buffer head internals.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
