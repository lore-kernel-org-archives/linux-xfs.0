Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:38271 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbcLRT57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2016 14:57:59 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
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
        <20160924035951.GN2356@ZenIV.linux.org.uk>
        <87shpmxrey.fsf@linux-m68k.org>
        <CA+55aFyJGz6njFjKe8O0+XRJhCrPHA_wnEuLbGSGypJ0G2-vpQ@mail.gmail.com>
Date: Sun, 18 Dec 2016 20:57:51 +0100
In-Reply-To: <CA+55aFyJGz6njFjKe8O0+XRJhCrPHA_wnEuLbGSGypJ0G2-vpQ@mail.gmail.com>
        (Linus Torvalds's message of "Sun, 18 Dec 2016 11:28:44 -0800")
Message-ID: <87zijt2eo0.fsf@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Dez 18 2016, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Dec 17, 2016 at 11:54 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
>> This break EPIPE handling inside splice when SIGPIPE is ignored:
>>
>> Before:
>> $ { sleep 1; strace -e splice pv -q /dev/zero; } | :
>
> Where is that "splice" program from?

It's running pv (splice is the argument of strace -e).

http://ivarch.com/programs/pv.shtml

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
