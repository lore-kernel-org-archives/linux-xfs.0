Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33729 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427944AbdDWIXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Apr 2017 04:23:16 -0400
Date: Sun, 23 Apr 2017 01:23:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: strengthen log intent item refcount checking
Message-ID: <20170423082315.GA21577@infradead.org>
References: <20170421200043.GL23371@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421200043.GL23371@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Fri, Apr 21, 2017 at 01:00:43PM -0700, Darrick J. Wong wrote:
> Use ASSERTs on the log intent item refcounts so that we fail noisily if
> anyone tries to double-free the item.  This will help us diagnose
> potential problems with the deferred-ops mechanism via generic/388.

Any specific problems you're looking at?

Otherwise looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
