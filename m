Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17938 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751054AbdIMJoB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 05:44:01 -0400
Date: Wed, 13 Sep 2017 19:43:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: Uninitialized memory read at xlog_write
Message-ID: <20170913094335.GV17782@dastard>
References: <201709042119.CDE26519.MtQJHFOSOFOLVF@I-love.SAKURA.ne.jp>
 <20170911150157.GA13400@bfoster.bfoster>
 <201709131614.FAG69217.MSHFFVOFLJtQOO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201709131614.FAG69217.MSHFFVOFLJtQOO@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: bfoster@redhat.com, sandeen@redhat.com, dchinner@redhat.com, linux-xfs@vger.kernel.org

On Wed, Sep 13, 2017 at 04:14:37PM +0900, Tetsuo Handa wrote:
> Brian Foster wrote:
> > I threw a kmemcheck enabled kernel on a couple boxes out of curiosity.
> > I didn't reproduce anything related to XFS with the "allow partially
> > uninit." option enabled, even after running a quick group run in
> > xfstests. Without that option, I did see an xlog_write() splat on a
> > rhel7 boot but it was preceded by a constant stream of other reports
> > (__d_lookup(), link_path_walk(), etc.) and ultimately resulted in a
> > failed/hung bootup (after quite some time). I'm in the process of seeing
> > a similar result on a Fedora vm running for-next. This isn't really
> > debuggable in the current form due to the volume of preceding errors,
> > the required boot time and the fact that my machines ultimately fall
> > over.
> > 
> > Do you see different behavior? Do you have the "allow partially
> > uninitialized memory" option enabled or disabled? I wonder if there are
> > fixes for these other errors I'm seeing in linux-next that XFS for-next
> > hasn't picked up yet..?
> 
> When I tested using linux-next-20170901, xlog_write() was the first splat
> (after I workarounded take_dentry_name_snapshot() splat).
> Today I retested using linux.git with a different VM and got a different result.
> 
> Here are console log and kernel config as of 6d8ef53e8b2fed8b ("Merge tag 'f2fs-for-4.14'
> of git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs") on linux.git .
> 
> http://I-love.SAKURA.ne.jp/tmp/serial-20170913.txt.xz
> http://I-love.SAKURA.ne.jp/tmp/config-4.13-20170913
> 
> 
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_KMEMCHECK=y
> # CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT is not set
> CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT=y
> # CONFIG_KMEMCHECK_ONESHOT_BY_DEFAULT is not set
> CONFIG_KMEMCHECK_QUEUE_SIZE=64
> CONFIG_KMEMCHECK_SHADOW_COPY_SHIFT=5
> CONFIG_KMEMCHECK_PARTIAL_OK=y
> # CONFIG_KMEMCHECK_BITOPS_OK is not set
> 
> ----------
>          Mounting Huge Pages File System...
> 
> [  OK  ] Stopped target Switch Root.
> 
> [  OK  ] Stopped target Initrd File Systems.[ 1054.691505] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff880135396660)
> [ 1054.691506] 000000000000000093050a200000000000000000000000000000000000000000
> [ 1054.691511]  u u u u u u u u i i i i i i i i u u u u u u u u u u u u u u u u
> [ 1054.691515]  ^
> [ 1054.691519] RIP: 0010:xlog_write+0x344/0x6b0

What line of code does this correspond to?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
