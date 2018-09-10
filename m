Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f54.google.com ([209.85.208.54]:35633 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbeIJXDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Sep 2018 19:03:17 -0400
Received: by mail-ed1-f54.google.com with SMTP id y20-v6so17249242edq.2
        for <linux-xfs@vger.kernel.org>; Mon, 10 Sep 2018 11:07:59 -0700 (PDT)
MIME-Version: 1.0
From: Joshi <joshiiitr@gmail.com>
Date: Mon, 10 Sep 2018 23:37:45 +0530
Message-ID: <CA+1E3r+crZ6suDtTheOysm_dzZ2FeU=z4R-aQQw7etk1yuxOLQ@mail.gmail.com>
Subject: Strange behavior with log IO fake-completions
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,
I wanted to check log IO speed impact during fsync-heavy workload.
To obtain theoretical maximum performance data, I did fake-completion
of all log IOs (i.e. log IO cost is made 0).

Test: iozone, single-thread, 1GiB file, 4K record, sync for each 4K (
'-eo' option).
Disk: 800GB NVMe disk. XFS based on 4.15, default options except log size = 184M
Machine: Intel Xeon E5-2690 @2.6 GHz, 2 NUMA nodes, 24 cpus each

And results are :
------------------------------------------------
baseline                log fake-completion
109,845                 45,538
------------------------------------------------
I wondered why fake-completion turned out to be ~50% slower!
May I know if anyone encountered this before, or knows why this can happen?

For fake-completion, I just tag all log IOs bufer-pointers (in
xlog_sync). And later in xfs_buf_submit, I just complete those tagged
log IOs without any real bio-formation (comment call to
_xfs_bio_ioapply). Hope this is correct/enough to do nothing!

It seems to me that CPU count/frequency is playing a role here.
Above data was obtained with CPU frequency set to higher values. In
order to keep running CPU at nearly constant high frequency, I tried
things such as - performance governor, bios-based performance
settings, explicit setting of cpu scaling max frequency etc. However,
results did not differ much. Moreover frequency did not remain
constant/high.

But when I used "affine/bind" option of iozone (-P option), iozone
runs on single cpu all the time, and I get to see expected result -
-------------------------------------------------------------
baseline (affine)         log fake-completion(affine)
125,253                     163,367
-------------------------------------------------------------

Also, during above episode, I felt the need to discover best way to
eliminate cpu frequency variations out of benchmarking. I'd be
thankful knowing about it.


Thanks,
-- 
Joshi
