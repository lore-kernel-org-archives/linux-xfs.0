Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36565 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbdBPUVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 15:21:42 -0500
Date: Thu, 16 Feb 2017 12:21:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] nonblocking aio: xfs
Message-ID: <20170216202141.GA18385@infradead.org>
References: <20170214024603.9563-1-rgoldwyn@suse.de>
 <20170214024603.9563-7-rgoldwyn@suse.de>
 <20170214074326.GA20629@infradead.org>
 <9859c328-263a-e4eb-22f6-20cdda821654@suse.de>
 <be95fe38-ddbe-427e-df7f-7b54fe3b02a6@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be95fe38-ddbe-427e-df7f-7b54fe3b02a6@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org

On Wed, Feb 15, 2017 at 10:11:38AM -0600, Goldwyn Rodrigues wrote:
> > I did not understand short writes. Where can I
> > get a short write?

If you have a write request of N bytes, and you've already wrіtten
M of them you return M from the *write system call instead of -EAGAIN.
This is standard practice on e.g. sockets.

> > 
> > If I understand correctly, we do add the flag.
> 
> Replying to myself to correct myself.
> 
> On reading a bit more, I figured that we perform
> xfs_file_iomap_begin->xfs_iomap_write_direct. At this point we have
> already performed xfs_bmapi_read(). So, a check in xfs_file_iomap_begin
> should be good enough. So, the flag required would be with iomap flags,
> say IOMAP_NONBLOCKING. IOW, we don't need to go all the way to
> xfs_bmap_write() and return when imap.br_startblock == HOLESTARTBLOCK.

Yes, except that reflinked files with shared extents will also need
some additional special casing - for those xfs_bmapi_read can return
an allocated extent, but we might still have to perform a block
allocation for a write.
