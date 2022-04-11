Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4B1C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 07:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245439AbiDKHdp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 03:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245436AbiDKHdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 03:33:37 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94456BF45
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 00:31:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A5E83534999;
        Mon, 11 Apr 2022 17:31:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndoW9-00GLhF-E4; Mon, 11 Apr 2022 17:31:21 +1000
Date:   Mon, 11 Apr 2022 17:31:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [5.19 cycle] Planning and goals
Message-ID: <20220411073121.GA1544202@dread.disaster.area>
References: <20220405020312.GU1544202@dread.disaster.area>
 <20220407031106.GB27690@magnolia>
 <20220407054939.GJ1544202@dread.disaster.area>
 <ff1aa185470226b5dac3b8e914277137a88e97e6.camel@oracle.com>
 <20220411015023.GV1544202@dread.disaster.area>
 <20220411035935.GZ1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411035935.GZ1544202@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6253d94a
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=VWJbn_kKE-rxfrB7xGYA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 01:59:35PM +1000, Dave Chinner wrote:
> On Mon, Apr 11, 2022 at 11:50:23AM +1000, Dave Chinner wrote:
> > On Thu, Apr 07, 2022 at 03:40:08PM -0700, Alli wrote:
> > > On Thu, 2022-04-07 at 15:49 +1000, Dave Chinner wrote:
> > > > On Wed, Apr 06, 2022 at 08:11:06PM -0700, Darrick J. Wong wrote:
> > > > > On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner wrote:
> > > > > > - Logged attributes V28 (Allison)
> > > > > > 	- I haven't looked at this since V24, so I'm not sure what
> > > > > > 	  the current status is. I will do that discovery later in
> > > > > > 	  the week.
> > > > > > 	- Merge criteria and status:
> > > > > > 		- review complete: Not sure
> > > So far each patch in v29 has at least 2 rvbs I think
> > 
> > OK.
> > 
> > > > > > 		- no regressions when not enabled: v24 was OK
> > > > > > 		- no major regressions when enabled: v24 had issues
> > > > > > 	- Open questions:
> > > > > > 		- not sure what review will uncover
> > > > > > 		- don't know what problems testing will show
> > > > > > 		- what other log fixes does it depend on?
> > > If it goes on top of whiteouts, it will need some modifications to
> > > follow the new log item changes that the whiteout set makes.
> > > 
> > > Alternately, if the white out set goes in after the larp set, then it
> > > will need to apply the new log item changes to xfs_attr_item.c as well
> > 
> > I figured as much, thanks for confirming!
> 
> Ok, so I've just gone through the process of merging the two
> branches to see where we stand. The modifications to the log code
> that are needed for the larp code - changes to log iovec processing
> and padding - are out of date in the LARP v29 patchset.
> 
> That is, the versions that are in the intent whiteout patchset are
> much more sophisticated and cleanly separated. The version of the
> "avoid extra transactions when no intents" patch in the LARP v29
> series is really only looking at whether the transaction is dirty,
> not whether there are intents in the transactions, which is what we
> really need to know when deciding whether to commit the transaction
> or not.
> 
> There are also a bunch of log iovec changes buried in patch 4 of the
> LARP patchset which is labelled as "infrastructure". Those changes
> are cleanly split out as patch 1 in the intent whiteout patchset and
> provide the xlog_calc_vec_len() function that the LARP code needs.
> 
> As such, the RVBs on the patches in the LARPv29 series don't carry
> over to the patches in the intent whiteout series - they are just
> too different for that to occur.
> 
> The additional changes needed to support intent whiteouts are
> relatively straight forward for the attri/attrd items, so at this
> point I'd much prefer that the two patchsets are ordered "intent
> whiteouts" then "LARP".
> 
> I've pushed the compose I just processed to get most of the pending
> patchsets as they stand into topic branches and onto test machines
> out to kernel.org. Have a look at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-5.19-compose
> 
> to see how I merged everything and maybe give it a run through your
> test cycle to see if there's anything I broke when LARP is enabled....

generic/642 producded this splat:

 XFS: Assertion failed: !list_empty(&cil->xc_cil), file: fs/xfs/xfs_log_cil.c, line: 1274
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU: 1 PID: 2187772 Comm: fsstress Not tainted 5.18.0-rc2-dgc+ #1108
 Call Trace:
  <TASK>
  xlog_cil_commit+0xa5a/0xad0
  __xfs_trans_commit+0xb8/0x330
  xfs_trans_commit+0x10/0x20
  xfs_attr_set+0x3e2/0x4c0
  xfs_xattr_set+0x8d/0xe0
  __vfs_setxattr+0x6b/0x90
  __vfs_setxattr_noperm+0x76/0x220
  __vfs_setxattr_locked+0xdf/0x100
  vfs_setxattr+0x94/0x170
  setxattr+0x110/0x200
  ? __might_fault+0x22/0x30
  ? strncpy_from_user+0x23/0x170
  ? getname_flags.part.0+0x4c/0x1b0
  ? kmem_cache_free+0x1fc/0x380
  ? __might_sleep+0x43/0x70
  path_setxattr+0xbf/0xe0
  __x64_sys_setxattr+0x2b/0x30
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Which implies a dirty transaction with nothing in it at the end of
a run through xfs_attr_set_iter() without LARP enabled. It raced
with a CIL push, so when the empty dirty transaction tries to push
the CIL, it assert fails because the CIL is empty....

I don't know how this happens yet, but there are no intents involved
here so it doesn't appear to have anything to do with intent logging
or intent whiteouts at this point.

I'll need to reproduce it to get more info about it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
