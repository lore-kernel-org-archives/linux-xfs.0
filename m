Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57116 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753791AbcIXD7L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 23:59:11 -0400
Date: Sat, 24 Sep 2016 04:59:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/11] splice: lift pipe_lock out of splice_to_pipe()
Message-ID: <20160924035908.GM2356@ZenIV.linux.org.uk>
References: <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
 <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Sep 23, 2016 at 01:36:12PM -0700, Linus Torvalds wrote:
> On Fri, Sep 23, 2016 at 1:10 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OTOH, considering the quality of documentation, I'm somewhat tempted to go
> > for "sleep only if it had been completely full when we entered; once there's
> > some space feed as much as fits and be done with that".  OTTH, I'm not sure
> > that no userland cr^Hode will manage to be hurt by that variant...
> 
> Let's just try it.
> 
> If that then doesn't work, we can introduce your odd code (with a
> *big* comment). Ok?

	FWIW, updated (with fixes) and force-pushed.  Added piece:
default_file_splice_read() converted to iov_iter.  Seems to work, after
fixing a braino in __pipe_get_pages().  Changed: #4 (sleep only in the
beginning, as described above), #6 (context changes from #4), #10 (missing
get_page() added in __pipe_get_pages()), #11 (removed pointless truncation
of len - ->read_iter() can bloody well handle that on its own) and added #12.
Stands at 28 files changed, 657 insertions(+), 1009 deletions(-) now...
