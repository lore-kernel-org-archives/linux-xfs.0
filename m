Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D94E47F47
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 00:33:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ABDED8F8037
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 22:33:11 -0700 (PDT)
Received: from maiev.nerim.net (smtp-151-monday.nerim.net [194.79.134.151]) by
	cuda.sgi.com with ESMTP id zd0xjR1RwX2kxr6z for
	<xfs@oss.sgi.com>; Mon, 17 Aug 2015 22:33:09 -0700 (PDT)
Date: Tue, 18 Aug 2015 07:33:08 +0200
From: Damien Wyart <damien.wyart@gmail.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150818053308.GA3629@brouette>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150814151401.GA6906@brouette>
	<20150817200034.GF21075@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150817200034.GF21075@mtj.duckdns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

> > I had an unstable system when running latest Linus tree with Tejun's
> > patch applied on top. Nothing fishy in the logs after rebooting without
> > the patch, but remote access with ssh when patch applied did not work
> > (as if /home partition could not be read). This system has / as ext4 and
> > other partitions (including /home) as XFS. Trying to login on tty
> > instead of X resulted in hang of X. I could reboot with sysrq, but can't
> > do further tests at the moment.

> > Back to same tree without the patch resulted in normal system.
> > So just a heads up the patch doesn't seem OK in its current state.

Hi Tejun,

> Have you been able to reproduce the failure? That sounds like an
> unlikely failure mode for the patch.

Unfortunately (as it would be nice to understand what happened), no.
I reapplied the patch on top of rc7 and could not reproduce the
unstability after several reboots.

I will continue running with the patch and report if anything strange
appears again...

-- 
Damien

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
