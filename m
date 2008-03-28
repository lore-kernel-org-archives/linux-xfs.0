Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Mar 2008 04:02:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2SB2dBc021424
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 04:02:40 -0700
Received: from tyo200.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 149FB6FF6C5
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 04:03:11 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50]) by cuda.sgi.com with ESMTP id 9HIN1Jk9H6seSCHi for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 04:03:11 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id m2S980RU000259
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 18:08:04 +0900 (JST)
Subject: Re: [RFC PATCH] freeze feature ver 1.0
Message-Id: <20080328180145t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 28 Mar 2008 18:01:45 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

David Chinner wrote:
> Can you please split this into two patches - one which introduces the
> generic functionality *without* the timeout stuff, and a second patch
> that introduces the timeouts.

OK.
I will send the split patches in subsequent mails. 
 
> I think this timeout stuff is dangerous - it adds significant
> complexity and really does not protect against anything that can't
> be done in userspace.  i.e. If your system is running well enough
> for the timer to fire and unfreeze the filesystem, it's running well
> enough for you to do "freeze X; sleep Y; unfreeze X".  

If the process is terminated at "sleep Y" by an unexpected
accident (e.g. signals),  the filesystem will be left frozen.
So, I think the timeout is needed to unfreeze more definitely.

> FWIW, there is nothing to guarantee that the filesystem has finished
> freezing when the timeout fires (it's not uncommon to see
> freeze_bdev() taking *minutes*) and unfreezing in the middle of a
> freeze operation will cause problems - either for the filesystem
> in the middle of a freeze operation, or for whatever is freezing the
> filesystem to get a consistent image.....

Do you mention the freeze_bdev()'s hang?
The salvage target of my timeout is freeze process's accident as below.
- It is killed before calling the unfreeze ioctl
- It causes a deadlock by accessing the frozen filesystem
So the delayed work for the timeout is set after all of freeze operations
in freeze_bdev() in my patches.
I think the filesystem dependent code (write_super_lockfs operation)
should be implemented not to cause a hang.

Cheers, Takashi
