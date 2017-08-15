Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35013 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752647AbdHORNb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 13:13:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAPaz=E+-+C-LXtADm99epmVEszpfT70Ep39tKedfPi1AN-P7tA@mail.gmail.com>
References: <CAPaz=E+-+C-LXtADm99epmVEszpfT70Ep39tKedfPi1AN-P7tA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 15 Aug 2017 19:13:29 +0200
Message-ID: <CAOQ4uxj0-Q-ZdDCPKP2oPDOtGq1bLTF=_edvkcwwLntMNvwLmg@mail.gmail.com>
Subject: Re: CrashMonkey: A Framework to Systematically Test File-System Crash Consistency
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vijay Chidambaram <vvijay03@gmail.com>
Cc: Ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.og, vijay@cs.utexas.edu, Ashlie Martinez <ashmrtn@utexas.edu>, Josef Bacik <jbacik@fb.com>, Christoph Hellwig <hch@lst.de>

On Mon, Aug 14, 2017 at 6:32 PM, Vijay Chidambaram <vvijay03@gmail.com> wrote:
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

Hi Vijay,

Thanks a lot for sharing your work.
Crash consistency is high on my TODO list.

Did you happen to run into this work by Joseph Bacik?

https://www.redhat.com/archives/dm-devel/2014-November/msg00083.html

I wonder if the disk_wrapper driver could be made into something more standard
like the suggested dm-power-fail target, so that it may be proposed
for upstream?

Thanks,
Amir.
