Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDB2C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 06:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbiCJG43 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 01:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiCJG43 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 01:56:29 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BAB212F146
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 22:55:27 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 66E7B532102;
        Thu, 10 Mar 2022 17:55:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nSChp-003h4C-2W; Thu, 10 Mar 2022 17:55:25 +1100
Date:   Thu, 10 Mar 2022 17:55:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v28 00/15] xfs: Log Attribute Replay
Message-ID: <20220310065525.GB3927073@dread.disaster.area>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
 <20220301022920.GC117732@magnolia>
 <d93c3a9a-126b-058b-81e2-bdf2e675ad0a@oracle.com>
 <20220309035351.GA8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309035351.GA8224@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6229a0de
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=_UQgKQs2P3-MsYIPjYsA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 08, 2022 at 07:53:51PM -0800, Darrick J. Wong wrote:
> On Tue, Mar 01, 2022 at 01:39:36PM -0700, Allison Henderson wrote:
> > 
> > 
> > On 2/28/22 7:29 PM, Darrick J. Wong wrote:
> > > On Mon, Feb 28, 2022 at 12:51:32PM -0700, Allison Henderson wrote:
> > > > Hi all,
> > > > 
> > > > This set is a subset of a larger series parent pointers. Delayed attributes allow
> > > > attribute operations (set and remove) to be logged and committed in the same
> > > > way that other delayed operations do. This allows more complex operations (like
> > > > parent pointers) to be broken up into multiple smaller transactions. To do
> > > > this, the existing attr operations must be modified to operate as a delayed
> > > > operation.  This means that they cannot roll, commit, or finish transactions.
> > > > Instead, they return -EAGAIN to allow the calling function to handle the
> > > > transaction.  In this series, we focus on only the delayed attribute portion.
> > > > We will introduce parent pointers in a later set.
> > > > 
> > > > The set as a whole is a bit much to digest at once, so I usually send out the
> > > > smaller sub series to reduce reviewer burn out.  But the entire extended series
> > > > is visible through the included github links.
> > > > 
> > > > Updates since v27:
> > > > xfs: don't commit the first deferred transaction without intents
> > > >    Comment update
> > > 
> > > I applied this to 5.16-rc6, and turned on larp mode.  generic/476
> > > tripped over something, and this is what kasan had to say:
> > > 
> > > [  835.381655] run fstests generic/476 at 2022-02-28 18:22:04
> > > [  838.008485] XFS (sdb): Mounting V5 Filesystem
> > > [  838.035529] XFS (sdb): Ending clean mount
> > > [  838.040528] XFS (sdb): Quotacheck needed: Please wait.
> > > [  838.050866] XFS (sdb): Quotacheck: Done.
> > > [  838.092369] XFS (sdb): EXPERIMENTAL logged extended attributes feature added. Use at your own risk!
> > > [  838.092938] general protection fault, probably for non-canonical address 0xe012f573e6000046: 0000 [#1] PREEMPT SMP KASAN
> > > [  838.099085] KASAN: maybe wild-memory-access in range [0x0097cb9f30000230-0x0097cb9f30000237]
> > > [  838.101148] CPU: 2 PID: 4403 Comm: fsstress Not tainted 5.17.0-rc5-djwx #rc5 63f7e400b85b2245f2d4d3033e82ec8bc95c49fd
> > > [  838.103757] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > > [  838.105811] RIP: 0010:xlog_cil_commit+0x2f9/0x2800 [xfs]
> > > 
> > > 
> > > FWIW, gdb says this address is:
> > > 
> > > 0xffffffffa06e0739 is in xlog_cil_commit (fs/xfs/xfs_log_cil.c:237).
> > > 232
> > > 233                     /*
> > > 234                      * if we have no shadow buffer, or it is too small, we need to
> > > 235                      * reallocate it.
> > > 236                      */
> > > 237                     if (!lip->li_lv_shadow ||
> > > 238                         buf_size > lip->li_lv_shadow->lv_size) {
> > > 239                             /*
> > > 240                              * We free and allocate here as a realloc would copy
> > > 241                              * unnecessary data. We don't use kvzalloc() for the
> > > 
> > > I don't know what this is about, but my guess is that we freed something
> > > we weren't supposed to...?
> > > 
> > > (An overnight fstests run with v27 and larp=0 ran fine, though...)
> > > 
> > > --D
> > 
> > Hmm, ok, I will dig into this then.  I dont see anything between v27 and v28
> > that would have cause this though, so I'm thinking what ever it is must by
> > intermittent.  I'll stick it in a loop and see if I can get a recreate
> > today.  Thanks!
> 
> I think I've figured out two of the problems here --
> 
> The biggest problem is that xfs_attri_init isn't fully initializing the
> xattr log item structure, which is why the CIL would crash on my system
> when it tried to resize what it thought was the lv_shadow buffer
> attached to the log item.  I changed it to kmem_cache_zalloc and the
> problems went away; you might want to check if your kernel has some
> debugging kconfig feature enabled that auto-zeroes everything.
> 
> The other KASAN report has to do with the log iovec code -- it assumes
> that any buffer passed in has a size that is congruent with 4(?) bytes.
> This isn't necessarily true for the xattr name (and in principle also
> the value) buffer that we get from the VFS; if either is (say) 37 bytes
> long, you'll get 37 bytes, and KASAN will expect you to stick to that.
> I think with the way the slab works this isn't a real memory corruption
> vector, but I wouldn't put it past slob or someone to actually pack
> things in tightly.

This seems ... familiar. ISTR I fixed this issue and send out
patches to address it some time ago.

Ah, yes, I did - for v24 of the LARP patchset.

https://lore.kernel.org/linux-xfs/20210901073039.844617-1-david@fromorbit.com/

Patch 3 fixed the log iovec rounding constraint:

https://lore.kernel.org/linux-xfs/20210901073039.844617-1-david@fromorbit.com/

and patch 4 fixed the iovec sizing problems for attribute intents:

https://lore.kernel.org/linux-xfs/20210901073039.844617-1-david@fromorbit.com/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
