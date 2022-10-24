Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF485ECAAA1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 12:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiJXMn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 08:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiJXMlY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 08:41:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835378C47E
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 05:08:19 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mwtvh3Jj0zmVJf;
        Mon, 24 Oct 2022 20:01:20 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 20:06:10 +0800
Date:   Mon, 24 Oct 2022 20:28:07 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
CC:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>,
        <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <guoxuenan@huawei.com>
Subject: Re: [PATCH v1] xfs: fix sb write verify for lazysbcount
Message-ID: <20221024122807.GA947523@ceph-admin>
References: <20221022020345.GA2699923@ceph-admin>
 <Y1NSBMwgUYxhW4PE@magnolia>
 <20221022120125.GA2052581@ceph-admin>
 <20221022211613.GW3600936@dread.disaster.area>
 <Y1YPjkiiN3FyMBfG@magnolia>
 <20221024054345.GZ3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221024054345.GZ3600936@dread.disaster.area>
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 04:43:45PM +1100, Dave Chinner wrote:
> On Sun, Oct 23, 2022 at 09:07:42PM -0700, Darrick J. Wong wrote:
> > On Sun, Oct 23, 2022 at 08:16:13AM +1100, Dave Chinner wrote:
> > > On Sat, Oct 22, 2022 at 08:01:25PM +0800, Long Li wrote:
> > > > On Fri, Oct 21, 2022 at 07:14:28PM -0700, Darrick J. Wong wrote:
> > > > > On Sat, Oct 22, 2022 at 10:03:45AM +0800, Long Li wrote:
> > > > > > When lazysbcount is enabled, multiple threads stress test the xfs report
> > > > > > the following problems:
> > > 
> > > We've had lazy sb counters for 15 years and just about every XFS
> > > filesystem in production uses them, so providing us with some idea
> > > of the scope of the problem and how to reproduce it would be greatly
> > > appreciated.
> > > 
> > > What stress test are you running? What filesystem config does it
> > > manifest on (other than lazysbcount=1)?  How long does the stress
> > > test run for, and where/why does log recovery get run in this stress
> > > test?
> > > 
> > > > > > XFS (loop0): SB summary counter sanity check failed
> > > > > > XFS (loop0): Metadata corruption detected at xfs_sb_write_verify
> > > > > > 	     +0x13b/0x460, xfs_sb block 0x0
> > > > > > XFS (loop0): Unmount and run xfs_repair
> > > > > > XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > > > > > 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 28 00 00  XFSB.........(..
> > > > > > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > > > > 00000020: 69 fb 7c cd 5f dc 44 af 85 74 e0 cc d4 e3 34 5a  i.|._.D..t....4Z
> > > > > > 00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
> > > > > > 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> > > > > > 00000050: 00 00 00 01 00 0a 00 00 00 00 00 04 00 00 00 00  ................
> > > > > > 00000060: 00 00 0a 00 b4 b5 02 00 02 00 00 08 00 00 00 00  ................
> > > > > > 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
> > > > > > XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply
> > > > > > 	+0xe1e/0x10e0 (fs/xfs/xfs_buf.c:1580).  Shutting down filesystem.
> > > > > > XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> > > > > > XFS (loop0): log mount/recovery failed: error -117
> > > > > > XFS (loop0): log mount failed
> > > > > > 
> > > > > > The cause of the problem is that during the log recovery process, incorrect
> > > > > > icount and ifree are recovered from the log and fail to pass the size check
> > > > > 
> > > > > Are you saying that the log contained a transaction in which ifree >
> > > > > icount?
> > > > 
> > > > Yes, this situation is possible. For example consider the following sequence:
> > > > 
> > > >  CPU0				    CPU1
> > > >  xfs_log_sb			    xfs_trans_unreserve_and_mod_sb
> > > >  ----------			    ------------------------------
> > > >  percpu_counter_sum(&mp->m_icount)
> > > > 				    percpu_counter_add(&mp->m_icount, idelta)
> > > > 				    percpu_counter_add_batch(&mp->m_icount,
> > > > 						  idelta, XFS_ICOUNT_BATCH)
> > > >  percpu_counter_sum(&mp->m_ifree)
> > > 
> > > What caused the xfs_log_sb() to be called? Very few things
> > > actually log the superblock this way at runtime - it's generally
> > > only logged directly like this when a feature bit changes during a
> > > transaction (rare) or at a synchronisation point when everything
> > > else is idle and there's no chance of a race like this occurring...
> > > 
> > > I can see a couple of routes to this occurring via feature bit
> > > modification, but I don't see them being easy to hit or something
> > > that would exist for very long in the journal. Hence I'm wondering
> > > if there should be runtime protection for xfs_log_sb() to avoid
> > > these problems....
> > 
> > Maybe.  Or perhaps we sample m_i{count,free} until they come up with a
> > value that will pass the verifier, and only then log the new values to
> > the primary super xfs_buf?
> 
> I suspect the simplest thing to do is this:
> 
> 	mp->m_sb.sb_ifree = min_t(uint64_t, percpu_counter_sum(&mp->m_ifree),
> 				mp->m_sb.sb.icount);
> 
> That way ifree will never be logged as being greater than icount.
> Neither icount or ifree will be accurate if we are racing with other
> updates, but it will guarantee that what we write to the journal
> won't trigger corruption warnings.
> 

Agree with you, this is the simplest and cleanest fix method, there will
be no more impact. This can be fixed at the point where the problem occurs
rather than after the problem has occurred. I would like to resend a patch
and attach the reproduce script. Thanks for your advice.

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
