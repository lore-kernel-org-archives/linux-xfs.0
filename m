Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC44CA9EAE
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 06:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C82CE21D7E
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 06:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbfJWGtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 02:49:14 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45070 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727574AbfJWGtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 02:49:14 -0400
Received: from dread.disaster.area (pa49-180-40-48.pa.nsw.optusnet.com.au [49.180.40.48])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0B81C364091;
        Wed, 23 Oct 2019 17:49:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iNAS9-0001C0-IG; Wed, 23 Oct 2019 17:49:05 +1100
Date:   Wed, 23 Oct 2019 17:49:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
        goodmirek@goodmirek.com, Hillf Danton <hillf.zj@alibaba-inc.com>,
        Dmitry Vyukov <dvyukov@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [Bug 205135] System hang up when memory swapping (kswapd
 deadlock)
Message-ID: <20191023064905.GC2044@dread.disaster.area>
References: <bug-205135-27@https.bugzilla.kernel.org/>
 <bug-205135-27-vbbrgnF9A3@https.bugzilla.kernel.org/>
 <20191022152422.e47fda82879dc7cd1f3cf5e5@linux-foundation.org>
 <20191023012228.GP913374@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023012228.GP913374@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=y881pOMu+B+mZdf5UrsJdA==:117 a=y881pOMu+B+mZdf5UrsJdA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=VwQbUJbxAAAA:8 a=58vdV8W1AAAA:8 a=QY18SFpNAAAA:8 a=vTr9H3xdAAAA:8
        a=7-415B0cAAAA:8 a=Sy3rG2stD7WaNId5fuIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=LkGzKdMokiVGLp8DTWHT:22
        a=LYL6_n6_bXSRrjLcjcND:22 a=7PCjnrUJ-F5voXmZD6jJ:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 22, 2019 at 06:22:28PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 22, 2019 at 03:24:22PM -0700, Andrew Morton wrote:
> > 
> > (switched to email.  Please respond via emailed reply-to-all, not via the
> > bugzilla web interface).
> > 
> > On Tue, 22 Oct 2019 09:02:22 +0000 bugzilla-daemon@bugzilla.kernel.org wrote:
> > 
> > > https://bugzilla.kernel.org/show_bug.cgi?id=205135
> > > 
> > > --- Comment #7 from goodmirek@goodmirek.com ---
> > > Everyone who uses a swapfile on XFS filesystem seem affected by this hang up.
> > > Not sure about other filesystems, I did not have a chance to test it elsewhere.
> > > 
> > > This unreproduced bot crash could be related:
> > > https://lore.kernel.org/linux-mm/20190910071804.2944-1-hdanton@sina.com/
> > 
> > Thanks.  Might be core MM, might be XFS, might be Fedora.
> > 
> > Hilf, does your patch look related?  That seems to have gone quiet?
> > 
> > Should we progress Tetsuo's patch?
> 
> Hmm...
> 
> Oct 09 15:44:52 kernel: Linux version 5.4.0-0.rc1.git1.1.fc32.x86_64 (mockbuild@bkernel03.phx2.fedoraproject.org) (gcc version 9.2.1 20190827 (Red Hat 9.2.1-1) (GCC)) #1 SMP Fri Oct 4 14:57:23 UTC 2019
> 
> ...istr 5.4-rc1 had some writeback bugs in it...
> 
>                         -> #1 (fs_reclaim){+.+.}:
> Oct 09 13:47:08 kernel:        fs_reclaim_acquire.part.0+0x25/0x30
> Oct 09 13:47:08 kernel:        __kmalloc+0x4f/0x330
> Oct 09 13:47:08 kernel:        kmem_alloc+0x83/0x1a0 [xfs]
> Oct 09 13:47:08 kernel:        kmem_alloc_large+0x3c/0x100 [xfs]
> Oct 09 13:47:08 kernel:        xfs_attr_copy_value+0x5d/0xa0 [xfs]
> Oct 09 13:47:08 kernel:        xfs_attr_get+0xe7/0x1d0 [xfs]
> Oct 09 13:47:08 kernel:        xfs_get_acl+0xad/0x1e0 [xfs]
> Oct 09 13:47:08 kernel:        get_acl+0x81/0x110
> Oct 09 13:47:08 kernel:        posix_acl_create+0x58/0x160
> Oct 09 13:47:08 kernel:        xfs_generic_create+0x7e/0x2f0 [xfs]
> Oct 09 13:47:08 kernel:        lookup_open+0x5bd/0x820
> Oct 09 13:47:08 kernel:        path_openat+0x340/0xcb0
> Oct 09 13:47:08 kernel:        do_filp_open+0x91/0x100
> Oct 09 13:47:08 kernel:        do_sys_open+0x184/0x220
> Oct 09 13:47:08 kernel:        do_syscall_64+0x5c/0xa0
> Oct 09 13:47:08 kernel:        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> That's XFS trying to allocate memory to load an acl off disk, only it
> looks this thread does a MAYFAIL allocation.  It's a GFP_FS (since we
> don't set KM_NOFS) allocation so we recurse into fs reclaim, and the
> ACL-getter has locked the inode (which is probably why lockdep
> triggers).  I wonder if that's really a deadlock vs. just super-slow
> behavior, but otoh I don't think we're supposed to allow reclaim to jump
> into the filesystems when the fs has locks held.
> 
> That kmem_alloc_large should probably be changed to KM_NOFS.  Dave?

I suspect it's a false positive, but without the rest of the lockdep
trace I don't have any context to determine if there is actually a
deadlock vector there.

i.e. the locked inode is referenced and we are not in a transaction
context, so the only reclaim recursion that could attempt to lock it
is dirty page writeback off the LRU from kswapd. i.e. direct
reclaim will never see that inode, nor can I see how it would block
on it. e.g. it's no different from doing memory allocation for BMBT
metadata blocks with the XFS_ILOCK held when reading in the extent
list on a data read or FIEMAP call.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
