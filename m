Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54333 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751080AbcLEQXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 11:23:12 -0500
Date: Mon, 5 Dec 2016 08:23:12 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: deprecate barrier/nobarrier mount option
Message-ID: <20161205162312.GC10124@infradead.org>
References: <20161130225444.15869-1-david@fromorbit.com>
 <20161130225444.15869-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161130225444.15869-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2016 at 09:54:44AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We always perform integrity operations now, so these mount options
> don't do anything. Deprecate them and mark them for removal in
> in a year.

This might be a bit of a too aggressive schedule, but we'll see..

Looks fine otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
