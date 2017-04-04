Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752518AbdDDGs2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2017 02:48:28 -0400
Date: Mon, 3 Apr 2017 23:48:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] nowait aio: Introduce IOCB_RW_FLAG_NOWAIT
Message-ID: <20170404064827.GB21942@infradead.org>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403185307.6243-2-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Mon, Apr 03, 2017 at 01:53:00PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This flag informs kernel to bail out if an AIO request will block
> for reasons such as file allocations, or a writeback triggered,
> or would block while allocating requests while performing
> direct I/O.
> 
> Unfortunately, aio_flags is not checked for validity, which would
> break existing applications which have it set to anything besides zero
> or IOCB_FLAG_RESFD. So, we are using aio_reserved1 and renaming it
> to aio_rw_flags.
> 
> IOCB_RW_FLAG_NOWAIT is translated to IOCB_NOWAIT for
> iocb->ki_flags.

Please make this a flag in the RWF_* namespace, and as a preparation
support the existing RWF_* flags for aio.
