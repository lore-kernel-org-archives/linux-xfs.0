Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40536 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbcJQMIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 08:08:46 -0400
Date: Mon, 17 Oct 2016 05:08:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Fix uninitialized variable in
 xfs_reflink_reserve_cow_range()
Message-ID: <20161017120843.GA9906@infradead.org>
References: <1476699404-5977-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1476699404-5977-1-git-send-email-geert@linux-m68k.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 17, 2016 at 12:16:44PM +0200, Geert Uytterhoeven wrote:
> with gcc 4.1.2:
> 
>     fs/xfs/xfs_reflink.c: In function ‘xfs_reflink_reserve_cow_range’:
>     fs/xfs/xfs_reflink.c:327: warning: ‘error’ may be used uninitialized in this function
> 
> Indeed, if "count" is zero, the function will return an uninitialized
> error value.
> 
> While "count" is unlikely to be zero, this function is called through
> the public iomap API. Hence fix this by preinitializing error to zero.

The iomap API should never call in with a zero count, but I think the
initialization is a fine safety net anyway:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, what compiler did you get this from?  I haven't seen it, but then
again I recently missed a lot of initializers without compiler warnings,
so either something changed in the Debian stable gcc or our build
system recently..
