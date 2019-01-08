Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45902 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727587AbfAHFzY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 00:55:24 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A79F628B37
        for <linux-xfs@vger.kernel.org>; Tue,  8 Jan 2019 05:55:23 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202053] [xfstests generic/464]: XFS corruption and Assertion
 failed: 0, file: fs/xfs/xfs_super.c, line: 985
Date: Tue, 08 Jan 2019 05:55:23 +0000
Message-ID: <bug-202053-201763-DrvPJaWINk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202053-201763@https.bugzilla.kernel.org/>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202053

--- Comment #15 from Dave Chinner (david@fromorbit.com) ---
On Mon, Jan 07, 2019 at 02:11:01PM -0500, Brian Foster wrote:
> On Mon, Jan 07, 2019 at 09:41:14AM -0500, Brian Foster wrote:
> > On Mon, Jan 07, 2019 at 08:57:37AM +1100, Dave Chinner wrote:
> > For example, I'm concerned that something like sustained buffered writes
> > could completely break the writeback imap cache by continuously
> > invalidating it. I think speculative preallocation should help with this
> > in the common case by already spreading those writes over fewer
> > allocations, but do we care enough about the case where preallocation
> > might be turned down/off to try and restrict where we bump the sequence
> > number (to > i_size changes, for example)? Maybe it's not worth the
> > trouble just to optimize out a shared ilock cycle and lookup, since the
> > extent list is still in-core after all.
> > 
> 
> A follow up FWIW... a quick test of some changes to reuse the existing
> mechanism doesn't appear to show much of a problem in this regard, even
> with allocsize=4k. I think another thing that minimizes impact is that
> even if we end up revalidating the same imap over and over, the ioend
> construction logic is distinct and based on contiguity. IOW, writeback
> is still sending the same sized I/Os for contiguous blocks...

Ah, I think you discovered that the delay between write(),
->writepages() and the incoming write throttling in
balance_dirty_pages() creates a large enough dirty page window that
we avoid lock-stepping write and writepage in a determental way....

AFAICT, the only time we have to worry about this is if we are so
short of memory the kernel is cleaning every page as soon as it is
dirtied. If we get into that situation, invalidating the cached map
is the least of our worries :P

Cheers,

dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
