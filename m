Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 00:57:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M7v0Lq011089
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 00:57:01 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEF6C10C62F1
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 00:58:44 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id NtRglEoKjRKgGfGV for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 00:58:44 -0700 (PDT)
Date: Wed, 22 Oct 2008 18:58:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081022075838.GK18495@disturbed>
References: <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com> <20081017165738.GA20818@infradead.org> <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com> <20081017203710.GA27187@infradead.org> <20081017135510.7127c4e7@infradead.org> <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com> <20081020163327.GA15651@infradead.org> <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com> <20081020223549.GA21152@disturbed> <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: lachlan@sgi.com, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Tue, Oct 21, 2008 at 03:42:16PM +0400, Alexander Beregalov wrote:
> 2008/10/21 Dave Chinner <david@fromorbit.com>:
> > On Mon, Oct 20, 2008 at 09:13:05PM +0400, Alexander Beregalov wrote:
> >> 2008/10/20 Christoph Hellwig <hch@infradead.org>:
> >> > On Mon, Oct 20, 2008 at 06:58:09PM +0400, Alexander Beregalov wrote:
> >> >> Hi Christoph
> >> >>
> >> >> I have the same result with next-1020 and today's xfs-2.6.git/master
> >> >> (
> >> >> commit bfd2bd10da76378dc4afd87d7d204a1d3d70b347
> >> >> Author: David Chinner <david@fromorbit.com>
> >> >> Date:   Fri Oct 17 15:36:23 2008 +1000
> >> >>     Inode: Allow external list initialisation
> >> >> )
> >> Ha, that kernel (xfs/master) has made my system dead locked.
> >> SysRQ-d:
> >> Show all locks held in the system
> >> 1 lock held by pdflush
> >> (&type->s_umount_key#18{----}, at writeback_inodes
> >> 1 lock held by login
> >> (&(&ip->i_iolock)->mr_lock){----} at xfs_ilock
> >> and so on ( many locks at xfs_ilock)
> >
> > Curious. Can you post the full stack traces?
> I can not reproduce it, yet.
> 
> Bisected to:
> dd509097cb0b76d3836385f80d6b2d6fd3b97757 is first bad commit
> commit dd509097cb0b76d3836385f80d6b2d6fd3b97757
> Author: Lachlan McIlroy <lachlan@sgi.com>
> Date:   Mon Sep 29 14:56:40 2008 +1000
> 
>     [XFS] Unlock inode before calling xfs_idestroy()
> 
>     Lock debugging reported the ilock was being destroyed without being
>     unlocked. We don't need to lock the inode until we are going to insert it
>     into the radix tree.

Ah, OK, I see the problem, though I don't understand why I'm not
seeing the might_sleep() triggering all the time given that I always
build with:

$ grep SLEEP .config
CONFIG_DEBUG_SPINLOCK_SLEEP=y

Basically the above commit moved xfs_ilock() inside
radix_tree_preload()/radix_tree_preload_end(), which means we are
taking a rwsem() while we have an elevated preempt count. I'll
get a patch out to fix it.

The question is why isn't this triggering for me during QA runs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
