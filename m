Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC83EC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 21:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B60D561988
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 21:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhC2VGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 17:06:37 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:50300 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231157AbhC2VGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 17:06:14 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id AD6763ED4;
        Tue, 30 Mar 2021 08:06:12 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lQz5P-008ErT-Vo; Tue, 30 Mar 2021 08:06:12 +1100
Date:   Tue, 30 Mar 2021 08:06:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: attr fork related fstests failures on for-next
Message-ID: <20210329210611.GQ63242@dread.disaster.area>
References: <YGIZZLoiyULTaUev@bfoster>
 <20210329183120.GH4090233@magnolia>
 <20210329204828.GP63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329204828.GP63242@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=fnpdIiE9j488gzRDYpwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 07:48:28AM +1100, Dave Chinner wrote:
> On Mon, Mar 29, 2021 at 11:31:20AM -0700, Darrick J. Wong wrote:
> > On Mon, Mar 29, 2021 at 02:16:04PM -0400, Brian Foster wrote:
> > > Hi,
> > > 
> > > I'm seeing a couple different fstests failures on current for-next that
> > > appear to be associated with e6a688c33238 ("xfs: initialise attr fork on
> > > inode create"). The first is xfs_check complaining about sb versionnum
> > > bits on various tests:
> > > 
> > > generic/003 16s ... _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (c)
> > > (see /root/xfstests-dev/results//generic/003.full for details)
> > > # cat results/generic/003.full
> > > ...
> > > _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (c)
> > > *** xfs_check output ***
> > > sb versionnum missing attr bit 10
> > > *** end xfs_check output
> > 
> > FWIW I think this because that commit sets up an attr fork without
> > setting ATTR and ATTR2 in sb_version like xfs_bmap_add_attrfork does...
> 
> Maybe, but mkfs.xfs sets ATTR2 by default and has for a long time.
> I'm not seeing this fail on either v4 or v5 filesystems on for-next
> with a current xfsprogs (5.11.0), so what environment is this test
> failing in?
> 
> SECTION       -- xfs
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test3 5.12.0-rc5-dgc+ #3074 SMP
> PREEMPT Tue Mar 30 07:37:47 AEDT 2021
> MKFS_OPTIONS  -- -f -m rmapbt=1,reflink=1 -i sparse=1 /dev/pmem1
> MOUNT_OPTIONS -- /dev/pmem1 /mnt/scratch

Ok, this regression test VM had selinux set to permissive so it
should have been using selinux. But at some time in the past,
"selinux=0" had been added to the kernel CLI, hence turning it off
and so not actually testing this path.  I have a mix of selinux
enabled and disabled test VMs (because test matrix) and it looks
like this never made it to a VM that had selinux enabled...

Ok, I can reproduce it now, will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
