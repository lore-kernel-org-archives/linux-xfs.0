Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:45636 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbcLUS4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2016 13:56:21 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
References: <20160917190023.GA8039@ZenIV.linux.org.uk>
        <20160923190032.GA25771@ZenIV.linux.org.uk>
        <20160923190326.GB2356@ZenIV.linux.org.uk>
        <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
        <20160923201025.GJ2356@ZenIV.linux.org.uk>
        <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
        <20160924035951.GN2356@ZenIV.linux.org.uk>
        <87shpmxrey.fsf@linux-m68k.org>
        <CA+55aFyJGz6njFjKe8O0+XRJhCrPHA_wnEuLbGSGypJ0G2-vpQ@mail.gmail.com>
        <20161218201207.GY1555@ZenIV.linux.org.uk>
        <20161218203003.GZ1555@ZenIV.linux.org.uk>
        <CA+55aFzPE6FbwX2NuiMkz9G+FzAoiNeb8jOSWwSoX3O7+KuH4Q@mail.gmail.com>
Date: Wed, 21 Dec 2016 19:56:11 +0100
In-Reply-To: <CA+55aFzPE6FbwX2NuiMkz9G+FzAoiNeb8jOSWwSoX3O7+KuH4Q@mail.gmail.com>
        (Linus Torvalds's message of "Sun, 18 Dec 2016 14:10:54 -0800")
Message-ID: <87shphaz78.fsf@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Dez 18 2016, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Regardless - Andreas, can you verify that that fixes your issues? I'm
> assuming you had some real load that made you notice this, not just he
> dummy example..

FWIW, I have verified that the testsuite of pv succeeds with this patch:

diff --git a/fs/splice.c b/fs/splice.c
index 5a7750bd2e..63b8f54485 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1086,7 +1086,13 @@ EXPORT_SYMBOL(do_splice_direct);
 
 static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 {
-	while (pipe->nrbufs == pipe->buffers) {
+	for (;;) {
+		if (unlikely(!pipe->readers)) {
+			send_sig(SIGPIPE, current, 0);
+			return -EPIPE;
+		}
+		if (pipe->nrbufs != pipe->buffers)
+			return 0;
 		if (flags & SPLICE_F_NONBLOCK)
 			return -EAGAIN;
 		if (signal_pending(current))
@@ -1095,7 +1101,6 @@ static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 		pipe_wait(pipe);
 		pipe->waiting_writers--;
 	}
-	return 0;
 }
 
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
-- 
2.11.0


Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
