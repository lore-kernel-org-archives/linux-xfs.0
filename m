Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58529 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753839AbcJDLsc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Oct 2016 07:48:32 -0400
Date: Tue, 4 Oct 2016 13:48:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] fs: update atime before I/O in
        generic_file_read_iter
Message-ID: <20161004114830.GA2359@lst.de>
References: <1475225194-3702-1-git-send-email-hch@lst.de> <1475225194-3702-3-git-send-email-hch@lst.de> <20161004081324.GC17515@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161004081324.GC17515@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Oct 04, 2016 at 10:13:24AM +0200, Jan Kara wrote:
> But frankly it looks like a nasty catch that iocb->ki_filp can go away
> under you in the AIO case. Do I get it right that this means there must be
> some other thread closing your fd while the read is running, right?

Yes, that's what generic/323 tests.

> Also it seems that file_end_write(file) call in aio_run_iocb() is prone to
> the same race?

Indeed.  That's easy to fix by moving the file_end_write to aio_complete,
though.

> Won't we be better off to just to do additional get_file() / fput() pair in
> the AIO submission path so that whole AIO submission path is guaranteed to
> have struct file available? I understand this is very performance sensitive
> path but we'll be adding just two atomic ops...

I'd rather avoid those if we can.  But a big comment and some refactoring
in this area would be useful to make that easier to understand.
