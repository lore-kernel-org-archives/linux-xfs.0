Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33748 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757670AbcLUTM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2016 14:12:57 -0500
MIME-Version: 1.0
In-Reply-To: <87shphaz78.fsf@linux-m68k.org>
References: <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk> <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk> <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924035951.GN2356@ZenIV.linux.org.uk> <87shpmxrey.fsf@linux-m68k.org>
 <CA+55aFyJGz6njFjKe8O0+XRJhCrPHA_wnEuLbGSGypJ0G2-vpQ@mail.gmail.com>
 <20161218201207.GY1555@ZenIV.linux.org.uk> <20161218203003.GZ1555@ZenIV.linux.org.uk>
 <CA+55aFzPE6FbwX2NuiMkz9G+FzAoiNeb8jOSWwSoX3O7+KuH4Q@mail.gmail.com> <87shphaz78.fsf@linux-m68k.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Dec 2016 11:12:55 -0800
Message-ID: <CA+55aFwZ_k_m9CzVpu36fdBJOHkQKJkNrWYLVO8SbSTwY+X9BQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Dec 21, 2016 at 10:56 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
>
> FWIW, I have verified that the testsuite of pv succeeds with this patch:

Ok, thanks, committed.

Al, looking at this area, I think there's some room for cleanups. In
particular, isn't the loop in opipe_prep() now just
"wait_for_space()"? I'm also thinking that we could perhaps remove the
SIGPIPE/EPIPE handling from splice_to_pipe()..

Hmm?

               Linus
