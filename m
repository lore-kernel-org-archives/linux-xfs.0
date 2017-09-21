Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:54401 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751898AbdIUGnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 02:43:42 -0400
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 21 Sep 2017 09:43:41 +0300
Message-ID: <CAOQ4uxixLMRU2YT-3csTr_684vNUZ=2CazKKD-ojO68fC4f6tA@mail.gmail.com>
Subject: Re: false positive lockdep splat with loop device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Byungchul Park <byungchul.park@lge.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Sep 21, 2017 at 1:22 AM, Dave Chinner <david@fromorbit.com> wrote:
> [cc lkml, PeterZ and Byungchul]
...
> The thing is, this IO completion has nothing to do with the lower
> filesystem - it's the IO completion for the filesystem on the loop
> device (the upper filesystem) and is not in any way related to the
> IO completion from the dax device the lower filesystem is waiting
> on.
>
> IOWs, this is a false positive.
>
> Peter, this is the sort of false positive I mentioned were likely to
> occur without some serious work to annotate the IO stack to prevent
> them.  We can nest multiple layers of IO completions and locking in
> the IO stack via things like loop and RAID devices.  They can be
> nested to arbitrary depths, too (e.g. loop on fs on loop on fs on
> dm-raid on n * (loop on fs) on bdev) so this new completion lockdep
> checking is going to be a source of false positives until there is
> an effective (and simple!) way of providing context based completion
> annotations to avoid them...
>

IMO, the way to handle this is to add 'nesting_depth' information
on blockdev (or bdi?). 'nesting' in the sense of blockdev->fs->blockdev->fs.
AFAIK, the only blockdev drivers that need to bump nesting_depth
are loop and nbd??
Not sure if the kernel should limit loop blockdev nesting depth??
One problem that lack of loop blockdev nesting information causes is
incorrect emergency remount dependencies:
https://patchwork.kernel.org/patch/6266791/

When blockdev carries the nesting_depth information it should be
trivial to annotate "nested fs" inode locks, the same way we handled
"stackable fs"  inode locks in overlayfs:
https://patchwork.kernel.org/patch/9460919/

Cheers,
Amir.
