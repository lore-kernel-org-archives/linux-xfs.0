Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0382C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 20:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC9861987
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 20:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhC2UtL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 16:49:11 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47241 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230381AbhC2Usk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 16:48:40 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 62F70104259E;
        Tue, 30 Mar 2021 07:48:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lQyoG-008EW5-Ob; Tue, 30 Mar 2021 07:48:28 +1100
Date:   Tue, 30 Mar 2021 07:48:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: attr fork related fstests failures on for-next
Message-ID: <20210329204828.GP63242@dread.disaster.area>
References: <YGIZZLoiyULTaUev@bfoster>
 <20210329183120.GH4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329183120.GH4090233@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=P77MS-LFfjdNp39cgL0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 11:31:20AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 29, 2021 at 02:16:04PM -0400, Brian Foster wrote:
> > Hi,
> > 
> > I'm seeing a couple different fstests failures on current for-next that
> > appear to be associated with e6a688c33238 ("xfs: initialise attr fork on
> > inode create"). The first is xfs_check complaining about sb versionnum
> > bits on various tests:
> > 
> > generic/003 16s ... _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (c)
> > (see /root/xfstests-dev/results//generic/003.full for details)
> > # cat results/generic/003.full
> > ...
> > _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (c)
> > *** xfs_check output ***
> > sb versionnum missing attr bit 10
> > *** end xfs_check output
> 
> FWIW I think this because that commit sets up an attr fork without
> setting ATTR and ATTR2 in sb_version like xfs_bmap_add_attrfork does...

Maybe, but mkfs.xfs sets ATTR2 by default and has for a long time.
I'm not seeing this fail on either v4 or v5 filesystems on for-next
with a current xfsprogs (5.11.0), so what environment is this test
failing in?

SECTION       -- xfs
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test3 5.12.0-rc5-dgc+ #3074 SMP
PREEMPT Tue Mar 30 07:37:47 AEDT 2021
MKFS_OPTIONS  -- -f -m rmapbt=1,reflink=1 -i sparse=1 /dev/pmem1
MOUNT_OPTIONS -- /dev/pmem1 /mnt/scratch

generic/003 11s ...  11s
Passed all 1 tests
Xunit report: /home/dave/src/xfstests-dev/results//xfs/result.xml

SECTION       -- xfs_v4
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test3 5.12.0-rc5-dgc+ #3074 SMP
PREEMPT Tue Mar 30 07:37:47 AEDT 2021
MKFS_OPTIONS  -- -f -m crc=0 /dev/pmem1
MOUNT_OPTIONS -- /dev/pmem1 /mnt/scratch

generic/003 11s ...  11s
Passed all 1 tests

> > With xfs_check bypassed, repair eventually complains about some attr
> > forks. The first point I hit this variant is generic/117:
> > 
> > generic/117 9s ... _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (r)
> > (see /root/xfstests-dev/results//generic/117.full for details)
> > # cat results//generic/117.full
> > ...
> > _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (r)
> > *** xfs_repair -n output ***
> > ...
> > Phase 3 - for each AG...
> >         - scan (but don't clear) agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> > bad attr fork offset 24 in dev inode 135, should be 1
> > would have cleared inode 135
> > bad attr fork offset 24 in dev inode 142, should be 1
> > would have cleared inode 142
> 
> ...and I think this is because xfs_default_attroffset doesn't set the
> correct value for device files.  For those kinds of files, xfs_repair
> requires the data fork to be exactly 8 bytes.

Again, doesn't fail with xfsprogs 5.11.0 here for either v4 or v5
filesystems...

SECTION       -- xfs
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test3 5.12.0-rc5-dgc+ #3074 SMP
PREEMPT Tue Mar 30 07:37:47 AEDT 2021
MKFS_OPTIONS  -- -f -m rmapbt=1,reflink=1 -i sparse=1 /dev/pmem1
MOUNT_OPTIONS -- /dev/pmem1 /mnt/scratch

generic/117 1s ...  2s
Passed all 1 tests
Xunit report: /home/dave/src/xfstests-dev/results//xfs/result.xml

SECTION       -- xfs_v4
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test3 5.12.0-rc5-dgc+ #3074 SMP
PREEMPT Tue Mar 30 07:37:47 AEDT 2021
MKFS_OPTIONS  -- -f -m crc=0 /dev/pmem1
MOUNT_OPTIONS -- /dev/pmem1 /mnt/scratch

generic/117 2s ...  2s
Passed all 1 tests

I'm going to need more information on what environment these
failures are being generated in.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
