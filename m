Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44207 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751312AbdEIJFg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 05:05:36 -0400
Date: Tue, 9 May 2017 11:05:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: Locking problems with Linux 4.9 with NFSD and `fs/iomap.c`
Message-ID: <20170509090534.GB2378@lst.de>
References: <de171adc29600902515d1424fd800678@molgen.mpg.de> <20170508131843.GB29840@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170508131843.GB29840@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, it+linux-nfs@molgen.mpg.de, Christoph Hellwig <hch@lst.de>

On Mon, May 08, 2017 at 09:18:46AM -0400, Brian Foster wrote:
> What exactly is a NULL call? Can this be reproduced easily?

It's a sunrpc concept of a dummy procedure that does nothing but
ensures the communication works.

> It may also be interesting to enable the xfs_zero_eof() tracepoint
> (trace-cmd start -e 'xfs:xfs_zero_eof') and see what the last few
> entries are from /sys/kernel/debug/tracing/trace_pipe.

Yeah.  I have a customer that uses Linux 4.9-stable with XFS and
nfsd exports in a product, so it's certainly not something that happens
too easily, but memory pressure might be a factor.   I'll see if
I can figure out what happens if I inject ENOMEM in the said
spot.
