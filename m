Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:50956 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbcLRUML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2016 15:12:11 -0500
Date: Sun, 18 Dec 2016 20:12:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
Message-ID: <20161218201207.GY1555@ZenIV.linux.org.uk>
References: <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
 <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924035951.GN2356@ZenIV.linux.org.uk>
 <87shpmxrey.fsf@linux-m68k.org>
 <CA+55aFyJGz6njFjKe8O0+XRJhCrPHA_wnEuLbGSGypJ0G2-vpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyJGz6njFjKe8O0+XRJhCrPHA_wnEuLbGSGypJ0G2-vpQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Dec 18, 2016 at 11:28:44AM -0800, Linus Torvalds wrote:
> On Sat, Dec 17, 2016 at 11:54 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> > This break EPIPE handling inside splice when SIGPIPE is ignored:
> >
> > Before:
> > $ { sleep 1; strace -e splice pv -q /dev/zero; } | :
> 
> Where is that "splice" program from? Google isn't helpful, and fedora
> doesn't seem to have it. I'm assuming it was posted in one of the
> threads, but if so I've long since lost sight of it..

It's pv(1), actually.  I'm looking into that - debian-packaged pv reproduced
that crap.
