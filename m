Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:45593 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbcLQTye (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2016 14:54:34 -0500
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
Date: Sat, 17 Dec 2016 20:54:29 +0100
In-Reply-To: <20160924035951.GN2356@ZenIV.linux.org.uk> (Al Viro's message of
        "Sat, 24 Sep 2016 04:59:51 +0100")
Message-ID: <87shpmxrey.fsf@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

This break EPIPE handling inside splice when SIGPIPE is ignored:

Before:
$ { sleep 1; strace -e splice pv -q /dev/zero; } | :
splice(3, NULL, 1, NULL, 131072, SPLICE_F_MORE) = -1 EPIPE (Broken pipe)
--- SIGPIPE {si_signo=SIGPIPE, si_code=SI_USER, si_pid=23750, si_uid=17005} ---
--- SIGPIPE {si_signo=SIGPIPE, si_code=SI_USER, si_pid=23750, si_uid=17005} ---
+++ exited with 0 +++

After:
$ { sleep 1; strace -e splice pv -q /dev/zero; } | :
splice(3, NULL, 1, NULL, 131072, SPLICE_F_MORE) = 65536
splice(3, NULL, 1, NULL, 131072, SPLICE_F_MORE
[hangs]

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
