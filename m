Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34446 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751819AbdHORdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 13:33:52 -0400
Received: by mail-yw0-f169.google.com with SMTP id s143so8780554ywg.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 10:33:52 -0700 (PDT)
Date: Tue, 15 Aug 2017 17:33:50 +0000
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: CrashMonkey: A Framework to Systematically Test File-System
 Crash Consistency
Message-ID: <20170815173349.GA17774@li70-116.members.linode.com>
References: <CAPaz=E+-+C-LXtADm99epmVEszpfT70Ep39tKedfPi1AN-P7tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPaz=E+-+C-LXtADm99epmVEszpfT70Ep39tKedfPi1AN-P7tA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vijay Chidambaram <vvijay03@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.og, vijay@cs.utexas.edu, Ashlie Martinez <ashmrtn@utexas.edu>

On Mon, Aug 14, 2017 at 11:32:02AM -0500, Vijay Chidambaram wrote:
> Hi,
> 
> I'm Vijay Chidambaram, an Assistant Professor at the University of
> Texas at Austin. My research group is developing CrashMonkey, a
> file-system agnostic framework to test file-system crash consistency
> on power failures. We are developing CrashMonkey publicly at Github
> [1]. This is very much a work-in-progress, so we welcome feedback.
> 
> CrashMonkey works by recording all the IO from running a given
> workload, then *constructing* possible crash states (while honoring
> FUA and FLUSH flags). A crash state is the state of storage after an
> abrupt power failure or crash. For each crash state, CrashMonkey runs
> the filesystem-provided fsck on top of the state, and checks if the
> file-system recovers correctly. Once the file system mounts correctly,
> we can run further tests to check data consistency.  The work was
> presented at HotStorage 17. The workshop paper is available at [2] and
> the slides at [3].
> 
> Our plan was to post on the mailing lists after reproducing an
> existing bug. We are not there yet, but I saw some posts where others
> were considering building something similar, so I thought I would post
> about our work.
> 
> [1] https://github.com/utsaslab/crashmonkey
> [2] http://www.cs.utexas.edu/~vijay/papers/hotstorage17-crashmonkey.pdf
> [3] http://www.cs.utexas.edu/~vijay/papers/hotstorage17-crashmonkey-slides.pdf
> 

I did this same work 3 years ago

https://github.com/torvalds/linux/blob/master/Documentation/device-mapper/log-writes.txt
https://github.com/josefbacik/log-writes

I have xfstests patches I need to get upstreamed at some point that does
fsstress and then replays the logs and verifies, and also one that makes fsx
store state so we can verify fsync() is doing the right thing.  We run this on
our major releases on xfs, ext4, and btrfs to make sure everything is working
right internally at Facebook.  You'll notice a bunch of commits recently because
we thought we found an xfs replay problem (we didn't).  This stuff is actively
used, I'd welcome contributions to it if you have anything to add.  One thing I
haven't done yet and have on my list is to randomly replay writes between
flush/fua, but it hasn't been a pressing priority yet.  Thanks,

Josef
