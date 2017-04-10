Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34992 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753386AbdDJPOI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 11:14:08 -0400
Date: Mon, 10 Apr 2017 17:13:59 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/8] nowait aio: ext4
Message-ID: <20170410151359.GH3224@quack2.suse.cz>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-7-rgoldwyn@suse.de>
 <20170404075853.GB28522@quack2.suse.cz>
 <20170404084122.GA10252@infradead.org>
 <d6dac6ec-c71c-0082-972f-61e7299ed418@suse.de>
 <20170410074539.GA18250@infradead.org>
 <20170410123750.GE3224@quack2.suse.cz>
 <20170410143943.GA2930@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170410143943.GA2930@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Mon 10-04-17 07:39:43, Christoph Hellwig wrote:
> On Mon, Apr 10, 2017 at 02:37:50PM +0200, Jan Kara wrote:
> > I don't understand here. Do you want that all filesystems support NOWAIT
> > direct IO?
> 
> No.  Per-file_system_type is way to coarse grained.  All feature flag
> needs to be per-file_operation at least for cases like ext4 with our
> without extents (or journal) XFS v4 vs v5, different NFS versions, etc.

Ah, I see your point now. Thanks for patience. I think we could make this
work by making generic_file_write/read_iter() refuse NOWAIT IO with
EOPNOTSUPP and then only modify those few filesystems that implement their
own iter helpers and will not initially support NOWAIT IO. Sounds easy
enough.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
