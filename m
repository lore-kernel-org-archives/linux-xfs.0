Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752010AbdF1DEl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 23:04:41 -0400
Date: Wed, 28 Jun 2017 11:04:39 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [v4.12-rc1 regression] nfs server crashed in fstests run
Message-ID: <20170628030439.GA23360@eguan.usersys.redhat.com>
References: <20170602060457.GG23805@eguan.usersys.redhat.com>
 <20170623072656.GI23360@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170623072656.GI23360@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nfs@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, jack@suse.cz, david@fromorbit.com

On Fri, Jun 23, 2017 at 03:26:56PM +0800, Eryu Guan wrote:
> [As this bug somehow involves in ext4/jbd2 changes, cc ext4 list too]
> 
> On Fri, Jun 02, 2017 at 02:04:57PM +0800, Eryu Guan wrote:
> > Hi all,
> > 
> > Starting from 4.12-rc1 kernel, I saw Linux nfs server crashes all the
> > time in my fstests (xfstests) runs, I appended the console log of an
> > NFSv3 crash to the end of this mail.
> 
> Some follow-up updates on this bug. *My* conclusion is, commit
> 81378da64de6 ("jbd2: mark the transaction context with the scope
> GFP_NOFS context") introduced this issue, and this is a bug that needs
> ext4, XFS and NFS to reproduce.
> 
> For more details please see below.
> 
> > 
> > I was exporting a directory resided on XFS, and loopback mounted the NFS
> > export on localhost. Both NFSv3 and NFSv4 could hit this crash. The
> > crash usually happens when running test case generic/029 or generic/095.
> > 
> > But the problem is, there's no easy and efficient way to reproduce it, I
> > tried run only generic/029 and generic/095 in a loop for 1000 times but
> > failed, I also tried run the 'quick' group tests only for 50 iterations
> > but failed again. It seems that the only reliable way to reproduce it is
> > run the 'auto' group tests for 20 iterations.
> > 
> > 	i=0
> > 	while [ $i -lt 20 ]; do
> > 		./check -nfs -g auto
> > 		((i++))
> > 	done
> > 
> > And usually server crashed within 5 iterations, but at times it could
> > survive 10 iterations and only crashed if you left it running for more
> > iterations. This makes it hard to bisect and bisecting is very
> > time-consuming.
> > 
> > (The bisecting is running now, it needs a few days to finish. My first
> > two attempts pointed first bad commit to some mm patches, but reverting
> > that patch didn't prevent server from crashing, so I enlarged the loop
> > count and started bisecting for the third time).
> 
> The third round of bisect finally finished after 2 weeks painful
> testings, git bisect pointed first bad to commit 81378da64de6 ("jbd2:
> mark the transaction context with the scope GFP_NOFS context"), which
> seemed very weird to me, because the crash always happens in XFS code.
> 
> But this reminded me that I was not only exporting XFS for NFS testing,
> but also ext4. So my full test setup is
> 
> # mount -t ext4 /dev/sda4 /export/test
> # showmount -e localhost
> Export list for localhost:
> /export/scratch *
> /export/test    *
> 
> (/export/scratch is on rootfs, which is XFS)
> 
> # cat local.config
> TEST_DEV=localhost:/export/test
> TEST_DIR=/mnt/testarea/test
> SCRATCH_DEV=localhost:/export/scratch
> SCRATCH_MNT=/mnt/testarea/scratch
> 
> 
> Then I did further confirmation tests:
> 1. switch to a new branch with that jbd2 patch as HEAD and compile
> kernel, run test with both ext4 and XFS exported on this newly compiled
> kernel, it crashed within 5 iterations.
> 
> 2. revert that jbd2 patch (when it was HEAD), run test with both ext4
> and XFS exported, kernel survived 20 iterations of full fstests run.
> 
> 3. kernel from step 1 survived 20 iterations of full fstests run, if I
> export XFS only (create XFS on /dev/sda4 and mount it at /export/test).
> 
> 4. 4.12-rc1 kernel survived the same test if I export ext4 only (both
> /export/test and /export/scratch were mounted as ext4, and this was done
> on another test host because I don't have another spare test partition)
> 
> 
> All these facts seem to confirm that commit 81378da64de6 really is the
> culprit, I just don't see how..
> 
> I attached git bisect log, and if you need more information please let
> me know. BTW, I'm testing 4.12-rc6 kernel now to see if it's already
> been fixed there.

4.12-rc6 kernel survived 30 iterations of full fstests run. Not sure if
it's been fixed or made even harder to reproduce.

Thanks,
Eryu
