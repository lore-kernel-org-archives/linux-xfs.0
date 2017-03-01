Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34123 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753053AbdCAP4w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2017 10:56:52 -0500
Date: Wed, 1 Mar 2017 07:56:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] nowait aio: Introduce IOCB_FLAG_NOWAIT
Message-ID: <20170301155634.GA9630@infradead.org>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-2-rgoldwyn@suse.de>
 <20170301153647.GA30631@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170301153647.GA30631@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed, Mar 01, 2017 at 07:36:48AM -0800, Christoph Hellwig wrote:
> Given that we aren't validating aio_flags in older kernels we can't
> just add this flag as it will be a no-op in older kernels.  I think
> we will have to add IOCB_CMD_PREADV2/IOCB_CMD_WRITEV2 opcodes that
> properly validate all reserved fields or flags first.
> 
> Once we do that I'd really prefer to use the same flags values
> as preadv2/pwritev2 so that we'll only need one set of flags over
> sync/async read/write ops.

I just took another look and we do verify that
aio_reserved1/aio_reserved2 must be zero.  So I think we can just
stick RWF_* into aio_reserved1 and fix that problem that way.
