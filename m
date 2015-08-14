Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8D8B7F37
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 10:14:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98EB78F804B
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 08:14:04 -0700 (PDT)
Received: from maiev.nerim.net (smtp-155-friday.nerim.net [194.79.134.155]) by
	cuda.sgi.com with ESMTP id zdxOXrBd5yHJYRG1 for
	<xfs@oss.sgi.com>; Fri, 14 Aug 2015 08:14:02 -0700 (PDT)
Date: Fri, 14 Aug 2015 17:14:01 +0200
From: Damien Wyart <damien.wyart@gmail.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150814151401.GA6906@brouette>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150814111408.GB8710@quack.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

> On Thu 13-08-15 18:44:15, Tejun Heo wrote:
> > e79729123f63 ("writeback: don't issue wb_writeback_work if clean")
> > updated writeback path to avoid kicking writeback work items if there
> > are no inodes to be written out; unfortunately, the avoidance logic
> > was too aggressive and made sync_inodes_sb() skip I_DIRTY_TIME inodes.
> > This patch fixes the breakage by

> > * Removing bdi_has_dirty_io() shortcut from bdi_split_work_to_wbs().
> >   The callers are already testing the condition.

> > * Removing bdi_has_dirty_io() shortcut from sync_inodes_sb() so that
> >   it always calls into bdi_split_work_to_wbs().

> > * Making bdi_split_work_to_wbs() consider the b_dirty_time list for
> >   WB_SYNC_ALL writebacks.

> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Fixes: e79729123f63 ("writeback: don't issue wb_writeback_work if clean")
> > Cc: Ted Ts'o <tytso@google.com>
> > Cc: Jan Kara <jack@suse.com>


* Jan Kara <jack@suse.cz> [2015-08-14 13:14]:
> So the patch looks good to me. But the fact that is fixes Eryu's problem
> means there is something fishy going on. Either inodes get wrongly attached
> to b_dirty_time list or bdi_has_dirty_io() somehow misbehaves only
> temporarily and we don't catch it with the debug patch.

> Can we add a test to wb_has_dirty_io() to also check whether it matches
> bdi_has_dirty_io()? Since Eryu doesn't use lazytime (I assume, Eryu, please
> speak up if you do), we could also warn if b_dirty_time lists get
> non-empty. Hmm?

Hi,

I had an unstable system when running latest Linus tree with Tejun's
patch applied on top. Nothing fishy in the logs after rebooting without
the patch, but remote access with ssh when patch applied did not work
(as if /home partition could not be read). This system has / as ext4 and
other partitions (including /home) as XFS. Trying to login on tty
instead of X resulted in hang of X. I could reboot with sysrq, but can't
do further tests at the moment.

Back to same tree without the patch resulted in normal system.

So just a heads up the patch doesn't seem OK in its current state.

Cheers

Damien

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
