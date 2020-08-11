Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AF2C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 07:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3791C2078E
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 07:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgHKHFN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 03:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728294AbgHKHFN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Aug 2020 03:05:13 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Tue, 11 Aug 2020 07:05:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208827-201763-KDJXA0HeZ0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208827-201763@https.bugzilla.kernel.org/>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208827

--- Comment #14 from Dave Chinner (david@fromorbit.com) ---
On Mon, Aug 10, 2020 at 08:19:57PM -0600, Jens Axboe wrote:
> On 8/10/20 8:00 PM, Dave Chinner wrote:
> > On Mon, Aug 10, 2020 at 07:08:59PM +1000, Dave Chinner wrote:
> >> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
> >>> [cc Jens]
> >>>
> >>> [Jens, data corruption w/ io_uring and simple fio reproducer. see
> >>> the bz link below.]
> > 
> > Looks like a io_uring/fio bugs at this point, Jens. All your go fast
> > bits turns the buffered read into a short read, and neither fio nor
> > io_uring async buffered read path handle short reads. Details below.
> 
> It's a fio issue. The io_uring engine uses a different path for short
> IO completions, and that's being ignored by the backend... Hence the
> IO just gets completed and not retried for this case, and that'll then
> trigger verification as if it did complete. I'm fixing it up.

I just updated fio to:

cb7d7abb (HEAD -> master, origin/master, origin/HEAD) io_u: set
io_u->verify_offset in fill_io_u()

The workload still reports corruption almost instantly. Only this
time, the trace is not reporting a short read.

File is patterned with:

verify_pattern=0x33333333%o-16

Offset of "bad" data is 0x1240000.

Expected:

00000000:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000010:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000020:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000030:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000040:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000050:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000060:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000070:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
00000080:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff 3333............
.....
0000ffd0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
0000ffe0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............
0000fff0:  33 33 33 33 00 10 24 01 00 00 00 00 f0 ff ff ff  3333............


Received:

00000000:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000010:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000020:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000030:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000040:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000050:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000060:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000070:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
00000080:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff 3333............
.....
0000ffd0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
0000ffe0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............
0000fff0:  33 33 33 33 00 00 24 01 00 00 00 00 f0 ff ff ff  3333............


Looks like the data in the expected buffer is wrong - the data
pattern in the received buffer is correct according the defined
pattern.

Error is 100% reproducable from the same test case. Same bad byte in
the expected buffer dump every single time.

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
