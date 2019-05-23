Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:49939 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387621AbfEWWdH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 18:33:07 -0400
Date: Fri, 24 May 2019 08:33:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/20] xfs: make mem_to_page available outside of
 xfs_buf.c
Message-ID: <20190523223302.GQ29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:26PM +0200, Christoph Hellwig wrote:
> Rename the function to kmem_to_page and move it to kmem.h together
> with our kmem_large allocator that may either return kmalloced or
> vmalloc pages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yup, needed if you are going to use kmem_zalloc_large() for the IO
buffers.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
