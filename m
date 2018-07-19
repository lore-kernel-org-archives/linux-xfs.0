Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbeGSUch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:32:37 -0400
Date: Thu, 19 Jul 2018 12:47:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/14] xfs: support embedded dfops in transaction
Message-ID: <20180719194759.GA6558@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-9-bfoster@redhat.com>
 <20180719161825.GE29404@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719161825.GE29404@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 12:18:26PM -0400, Brian Foster wrote:
> FYI, this accidentally leaves off libxfs/xfs_rtbitmap.c, which also
> requires the xfs_defer.h include treatment.

I wonder if we shouldn't just move struct xfs_defer_ops to xfs_trans.h
instead.
