Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43977 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752343AbdDJMhz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 08:37:55 -0400
Date: Mon, 10 Apr 2017 14:37:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/8] nowait aio: ext4
Message-ID: <20170410123750.GE3224@quack2.suse.cz>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-7-rgoldwyn@suse.de>
 <20170404075853.GB28522@quack2.suse.cz>
 <20170404084122.GA10252@infradead.org>
 <d6dac6ec-c71c-0082-972f-61e7299ed418@suse.de>
 <20170410074539.GA18250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170410074539.GA18250@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Mon 10-04-17 00:45:39, Christoph Hellwig wrote:
> On Tue, Apr 04, 2017 at 01:41:09PM -0500, Goldwyn Rodrigues wrote:
> > I am working on incorporating RWF_* flags. However, I am not sure how
> > RWF_* flags would get rid of FS_NOWAIT/FS_NOWAIT_IO. Since most of
> > "blocking" information is with the filesystem, it is a per-filesystem
> > flag to block out (EOPNOTSUPP) the filesystems which do not support it.
> 
> You need to check the flag in the actual read/write methods as the
> support for features on Linux is not a per-file_system_type thing.

I don't understand here. Do you want that all filesystems support NOWAIT
direct IO? IMO that's not realistic and also not necessary. In reality
different filesystems support different sets or operations and we have a
precedens for that in various fallocate operations, rename exchange, or
O_TMPFILE support...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
