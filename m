Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43633 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753217AbcJDINZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Oct 2016 04:13:25 -0400
Date: Tue, 4 Oct 2016 10:13:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] fs: update atime before I/O in generic_file_read_iter
Message-ID: <20161004081324.GC17515@quack2.suse.cz>
References: <1475225194-3702-1-git-send-email-hch@lst.de>
 <1475225194-3702-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475225194-3702-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri 30-09-16 10:46:34, Christoph Hellwig wrote:
> After the call to ->direct_IO the final reference to the file might have
> been dropped by aio_complete already, and the call to file_accessed might
> cause a use after free.
> 
> Instead update the access time before the I/O, similar to how we
> update the time stamps before writes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

But frankly it looks like a nasty catch that iocb->ki_filp can go away
under you in the AIO case. Do I get it right that this means there must be
some other thread closing your fd while the read is running, right?

Also it seems that file_end_write(file) call in aio_run_iocb() is prone to
the same race?

Won't we be better off to just to do additional get_file() / fput() pair in
the AIO submission path so that whole AIO submission path is guaranteed to
have struct file available? I understand this is very performance sensitive
path but we'll be adding just two atomic ops...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
