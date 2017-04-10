Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48836 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbdDJHpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 03:45:41 -0400
Date: Mon, 10 Apr 2017 00:45:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] nowait aio: ext4
Message-ID: <20170410074539.GA18250@infradead.org>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-7-rgoldwyn@suse.de>
 <20170404075853.GB28522@quack2.suse.cz>
 <20170404084122.GA10252@infradead.org>
 <d6dac6ec-c71c-0082-972f-61e7299ed418@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6dac6ec-c71c-0082-972f-61e7299ed418@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Tue, Apr 04, 2017 at 01:41:09PM -0500, Goldwyn Rodrigues wrote:
> I am working on incorporating RWF_* flags. However, I am not sure how
> RWF_* flags would get rid of FS_NOWAIT/FS_NOWAIT_IO. Since most of
> "blocking" information is with the filesystem, it is a per-filesystem
> flag to block out (EOPNOTSUPP) the filesystems which do not support it.

You need to check the flag in the actual read/write methods as the
support for features on Linux is not a per-file_system_type thing.
