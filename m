Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34321 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750993AbdEaIvm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 May 2017 04:51:42 -0400
Date: Wed, 31 May 2017 10:51:37 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/10] xfs: nowait aio support
Message-ID: <20170531085137.GB14011@quack2.suse.cz>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-10-rgoldwyn@suse.de>
 <20170528093113.GB14519@infradead.org>
 <cfc1e7ad-f74b-a14a-ac30-8472f7f684af@suse.de>
 <20170529083338.GC1899@infradead.org>
 <f105d585-e88c-b037-9905-d0c608c609d9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f105d585-e88c-b037-9905-d0c608c609d9@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Tue 30-05-17 11:13:29, Goldwyn Rodrigues wrote:
> > Btw, can you write a small blurb up for the man page to document these
> > ѕemantics in man-page like language?
> > 
> 
> Yes, but which man page would it belong to?
> Should it be a subsection of errors in io_getevents/io_submit. We don't
> want to add ERRORS to io_getevents() because it would be the return
> value of the io_getevents call, and not the ones in the iocb structure.
> Should it be a new man page, say for iocb(7/8)?

I think you should extend the manpage for io_submit(8). There you can add
definition of struct iocb in 'DESCRIPTION' section explaining at least the
most common fields. You can also explain there which flags can be passed
and what are they intended to do.

You can also expand EAGAIN error description to specifically mention that
in case of NOWAIT aio EAGAIN can be returned if io submission would block.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
