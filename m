Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbdEBHd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 03:33:26 -0400
Date: Tue, 2 May 2017 00:33:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix use-after-free in xfs_finish_page_writeback
Message-ID: <20170502073325.GA6679@infradead.org>
References: <20170501173633.6639-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170501173633.6639-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 02, 2017 at 01:36:33AM +0800, Eryu Guan wrote:
> Commit 28b783e47ad7 ("xfs: bufferhead chains are invalid after
> end_page_writeback") fixed one use-after-free issue by
> pre-calculating the loop conditionals before calling bh->b_end_io()
> in the end_io processing loop, but it assigned 'next' pointer before
> checking end offset boundary & breaking the loop, at which point the
> bh might be freed already, and caused use-after-free.
> 
> This is caught by KASAN when running fstests generic/127 on sub-page
> block size XFS.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
