Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53230 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbdJBPCN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Oct 2017 11:02:13 -0400
Date: Mon, 2 Oct 2017 11:02:08 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 3/4] ext4: Add iomap support for inline data
Message-ID: <20171002150208.bcuv2wqqs3cpyyvz@thunk.org>
References: <20170914095047.23935-1-agruenba@redhat.com>
 <20170914095047.23935-4-agruenba@redhat.com>
 <20170928175748.23b7wkjiqavpunvj@thunk.org>
 <CAHc6FU4iEYQb7TV-kqFUt4Z6qTkRO1NgWixdeQ-BYBDTk6v3EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU4iEYQb7TV-kqFUt4Z6qTkRO1NgWixdeQ-BYBDTk6v3EA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Mon, Oct 02, 2017 at 04:39:59PM +0200, Andreas Gruenbacher wrote:
> > If we race with the inline data flag getting cleared,
> > ext4_iomap_begin() will return with -EAGAIN.
> 
> Actually, in that case, ext4_iomap_begin will treat the file as non-inline.
> It will not return -EAGAIN.

Ah, thanks, I missed that.

					- Ted
