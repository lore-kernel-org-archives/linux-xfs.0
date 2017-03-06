Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35196 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752599AbdCFIwo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Mar 2017 03:52:44 -0500
Date: Mon, 6 Mar 2017 09:25:46 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/8 v2] Non-blocking AIO
Message-ID: <20170306082546.GA14932@quack2.suse.cz>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <347d19cb-dbb8-1d4f-dfb5-d1dd820dd65d@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <347d19cb-dbb8-1d4f-dfb5-d1dd820dd65d@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun 05-03-17 16:56:21, Avi Kivity wrote:
> >The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
> >any of these conditions are met. This way userspace can push most
> >of the write()s to the kernel to the best of its ability to complete
> >and if it returns -EAGAIN, can defer it to another thread.
> >
> 
> Is it not possible to push the iocb to a workqueue?  This will allow
> existing userspace to work with the new functionality, unchanged. Any
> userspace implementation would have to do the same thing, so it's not like
> we're saving anything by pushing it there.

That is not easy because until IO is fully submitted, you need some parts
of the context of the process which submits the IO (e.g. memory mappings,
but possibly also other credentials). So you would need to somehow transfer
this information to the workqueue.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
