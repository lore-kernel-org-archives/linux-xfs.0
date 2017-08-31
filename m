Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbdHaDiU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 23:38:20 -0400
Date: Thu, 31 Aug 2017 11:38:18 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 00/14] Crash consistency xfstest using dm-log-writes
Message-ID: <20170831033818.GH27835@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxh8av5H87SHdFw92BDTvCtYgd9chS2Nfv5fA4=upoqRfA@mail.gmail.com>
 <20170830152326.vil3fhsrecp2ccql@destiny>
 <CAOQ4uxjE20+vY4OPWM3Z=FU-+4oC1KrYtJ5e7-rQDW4xx5t4RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjE20+vY4OPWM3Z=FU-+4oC1KrYtJ5e7-rQDW4xx5t4RA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 30, 2017 at 09:39:39PM +0300, Amir Goldstein wrote:
> On Wed, Aug 30, 2017 at 6:23 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> > On Wed, Aug 30, 2017 at 06:04:26PM +0300, Amir Goldstein wrote:
> >> Sorry noise xfs list, I meant to CC fsdevel
> >>
> >> On Wed, Aug 30, 2017 at 5:51 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >> > Hi all,
> >> >
> >> > This is the 2nd revision of crash consistency patch set.
> >> > The main thing that changed since v1 is my confidence in the failures
> >> > reported by the test, along with some more debugging options for
> >> > running the test tools.
> >> >
> >> > I've collected these patches that have been sitting in Josef Bacik's
> >> > tree for a few years and kicked them a bit into shape.
> >> > The dm-log-writes target has been merged to kernel v4.1, see:
> >> > https://github.com/torvalds/linux/blob/master/Documentation/device-mapper/log-writes.txt
> >> >
> >> > For this posting, I kept the random seeds constant for the test.
> >> > I set these constant seeds after running with random seed for a little
> >> > while and getting failure reports. With the current values in the test
> >> > I was able to reproduce at high probablity failures with xfs, ext4 and btrfs.
> >> > The probablity of reproducing the failure is higher on a spinning disk.
> >> >
> >
> > I'd rather we make it as evil as possible.  As long as we're printing out the
> > seed that was used in the output then we can go in and manually change the test
> > to use the same seed over and over again if we need to debug a problem.
> 
> Yeh that's what I did, but then I found values that reproduce a problem,
> so maybe its worth clinging on to these values now until the bugs are fixed in
> upstream and then as regression tests.
> 
> Anyway, I can keep these presets commented out, or run the test twice,
> once with presets and once with random seed, whatever Eryu decides.

My thought on this with first glance is using random seed, if a specific
seed reproduce something, maybe another targeted regression test can be
added, as what you did for that ext4 corruption?

> 
> 
> >
> >> > There is an outstanding problem with the test - when I run it with
> >> > kvm-xfstests, the test halts and I get soft lockup of log_writes_kthread.
> >> > I suppose its a bug in dm-log-writes with some kernel config or with virtio
> >> > I wasn't able to determine the reason and have little time to debug this.
> >> >
> >> > Since dm-log-writes is anyway in upstream kernel, I don't think a bug
> >> > in dm-log-writes for a certain config is a reason to block this xfstest
> >> > from being merged.
> >> > Anyway, I would be glad if someone could take a look at the soft lockup
> >> > issue. Josef?
> >> >
> >
> > Yeah can you give this a try and see if the soft lockup goes away?
> >
> 
> It does go away. Thanks!
> Now something's wrong with the log.
> it get corrupted in most of the test runs, something like this:
> 
> replaying 17624@158946: sector 8651296, size 4096, flags 0
> replaying 17625@158955: sector 0, size 0, flags 0
> replaying 17626@158956: sector 72057596591815616, size 103079215104, flags 0
> Error allocating buffer 103079215104 entry 17626
> 
> I'll look into it
> 
> Amir.

The first 6 patches are all prepare work and seem fine, so I probably
will push them out this week. But I may need more time to look into all
these log-writes dm target and fsx changes.

But seems that there're still problems not sorted out (e.g. this
log-write bug), I'd prefer, when they get merged, removing the auto
group for now until things settle down a bit.

Thanks,
Eryu
