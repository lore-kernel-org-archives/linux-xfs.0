Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34070 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751481AbdHNQcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 12:32:43 -0400
MIME-Version: 1.0
From: Vijay Chidambaram <vvijay03@gmail.com>
Date: Mon, 14 Aug 2017 11:32:02 -0500
Message-ID: <CAPaz=E+-+C-LXtADm99epmVEszpfT70Ep39tKedfPi1AN-P7tA@mail.gmail.com>
Subject: CrashMonkey: A Framework to Systematically Test File-System Crash Consistency
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.og
Cc: vijay@cs.utexas.edu, Ashlie Martinez <ashmrtn@utexas.edu>

Hi,

I'm Vijay Chidambaram, an Assistant Professor at the University of
Texas at Austin. My research group is developing CrashMonkey, a
file-system agnostic framework to test file-system crash consistency
on power failures. We are developing CrashMonkey publicly at Github
[1]. This is very much a work-in-progress, so we welcome feedback.

CrashMonkey works by recording all the IO from running a given
workload, then *constructing* possible crash states (while honoring
FUA and FLUSH flags). A crash state is the state of storage after an
abrupt power failure or crash. For each crash state, CrashMonkey runs
the filesystem-provided fsck on top of the state, and checks if the
file-system recovers correctly. Once the file system mounts correctly,
we can run further tests to check data consistency.  The work was
presented at HotStorage 17. The workshop paper is available at [2] and
the slides at [3].

Our plan was to post on the mailing lists after reproducing an
existing bug. We are not there yet, but I saw some posts where others
were considering building something similar, so I thought I would post
about our work.

[1] https://github.com/utsaslab/crashmonkey
[2] http://www.cs.utexas.edu/~vijay/papers/hotstorage17-crashmonkey.pdf
[3] http://www.cs.utexas.edu/~vijay/papers/hotstorage17-crashmonkey-slides.pdf

Thanks,
Vijay Chidambaram
http://www.cs.utexas.edu/~vijay/
