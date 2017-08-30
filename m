Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:34994 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751722AbdH3PXb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 11:23:31 -0400
Received: by mail-qt0-f173.google.com with SMTP id x36so28619158qtx.2
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2017 08:23:31 -0700 (PDT)
Date: Wed, 30 Aug 2017 11:23:28 -0400
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 00/14] Crash consistency xfstest using dm-log-writes
Message-ID: <20170830152326.vil3fhsrecp2ccql@destiny>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxh8av5H87SHdFw92BDTvCtYgd9chS2Nfv5fA4=upoqRfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh8av5H87SHdFw92BDTvCtYgd9chS2Nfv5fA4=upoqRfA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 30, 2017 at 06:04:26PM +0300, Amir Goldstein wrote:
> Sorry noise xfs list, I meant to CC fsdevel
> 
> On Wed, Aug 30, 2017 at 5:51 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > Hi all,
> >
> > This is the 2nd revision of crash consistency patch set.
> > The main thing that changed since v1 is my confidence in the failures
> > reported by the test, along with some more debugging options for
> > running the test tools.
> >
> > I've collected these patches that have been sitting in Josef Bacik's
> > tree for a few years and kicked them a bit into shape.
> > The dm-log-writes target has been merged to kernel v4.1, see:
> > https://github.com/torvalds/linux/blob/master/Documentation/device-mapper/log-writes.txt
> >
> > For this posting, I kept the random seeds constant for the test.
> > I set these constant seeds after running with random seed for a little
> > while and getting failure reports. With the current values in the test
> > I was able to reproduce at high probablity failures with xfs, ext4 and btrfs.
> > The probablity of reproducing the failure is higher on a spinning disk.
> >

I'd rather we make it as evil as possible.  As long as we're printing out the
seed that was used in the output then we can go in and manually change the test
to use the same seed over and over again if we need to debug a problem.

> > For xfs, I posted a fix for potential data loss post fsync+crash.
> > For ext4, I posted a reliable reproducer using dm-flakey.
> > For btrfs, I shared the recorded log with Josef.
> >

I posted a patch to fix the problem you reported by the way, but my
git-send-email thing isn't set to cc people in the commit, sorry about that.

> > There is an outstanding problem with the test - when I run it with
> > kvm-xfstests, the test halts and I get soft lockup of log_writes_kthread.
> > I suppose its a bug in dm-log-writes with some kernel config or with virtio
> > I wasn't able to determine the reason and have little time to debug this.
> >
> > Since dm-log-writes is anyway in upstream kernel, I don't think a bug
> > in dm-log-writes for a certain config is a reason to block this xfstest
> > from being merged.
> > Anyway, I would be glad if someone could take a look at the soft lockup
> > issue. Josef?
> >

Yeah can you give this a try and see if the soft lockup goes away?

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index a1da0eb..b900758 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -345,6 +345,7 @@ static int log_writes_kthread(void *arg)
 		struct pending_block *block = NULL;
 		int ret;
 
+		cond_resched();
 		spin_lock_irq(&lc->blocks_lock);
 		if (!list_empty(&lc->logging_blocks)) {
 			block = list_first_entry(&lc->logging_blocks,
