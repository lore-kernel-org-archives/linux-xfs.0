Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbcLEQWe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 11:22:34 -0500
Date: Mon, 5 Dec 2016 08:22:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: Always flush caches when integrity is required
Message-ID: <20161205162220.GB10124@infradead.org>
References: <20161130225444.15869-1-david@fromorbit.com>
 <20161130225444.15869-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161130225444.15869-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2016 at 09:54:43AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is no reason anymore for not issuing device integrity
> operations when teh filesystem requires ordering or data integrity
> guarantees. We should always issue cache flushes and FUA writes
> where necessary and let the underlying storage optimise them as
> necessary for correct integrity operation.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
