Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8162EC3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJXEpP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJXEpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:45:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EBE46DB9
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:45:05 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mwj6q2hfPzVj2C;
        Mon, 24 Oct 2022 12:40:19 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 12:45:03 +0800
Date:   Mon, 24 Oct 2022 13:06:59 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>,
        <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <guoxuenan@huawei.com>
Subject: Re: [PATCH v1] xfs: fix sb write verify for lazysbcount
Message-ID: <20221024050659.GA338324@ceph-admin>
References: <20221022020345.GA2699923@ceph-admin>
 <Y1NSBMwgUYxhW4PE@magnolia>
 <20221022120125.GA2052581@ceph-admin>
 <20221022211613.GW3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221022211613.GW3600936@dread.disaster.area>
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 23, 2022 at 08:16:13AM +1100, Dave Chinner wrote:
> On Sat, Oct 22, 2022 at 08:01:25PM +0800, Long Li wrote:
> > On Fri, Oct 21, 2022 at 07:14:28PM -0700, Darrick J. Wong wrote:
> > > On Sat, Oct 22, 2022 at 10:03:45AM +0800, Long Li wrote:
> > > > When lazysbcount is enabled, multiple threads stress test the xfs report
> > > > the following problems:
> 
> We've had lazy sb counters for 15 years and just about every XFS
> filesystem in production uses them, so providing us with some idea
> of the scope of the problem and how to reproduce it would be greatly
> appreciated.

Ok, here is my simplified script that could reproducer the bug:

#!/bin/bash

device=/dev/sda
testdir=/mnt/test
round=0

function fail()
{
	echo "$*"
	exit 1
}

while [ $round -lt 10000 ]
do
	echo "******* round $round ********"
	mkfs.xfs -f $device
	mkdir -p $testdir
	mount $device $testdir || fail "mount failed!"
	fsstress -d $testdir -l 0 -n 10000 -p 4 >/dev/null &
	sleep 4
	killall -w fsstress
	umount $testdir
	xfs_repair -e $device > /dev/null
	if [ $? -eq 2 ];then
		echo "ERR CODE 2: Dirty log exception encountered during repair."
		exit 1
	fi
	sleep 1
	round=$(($round+1))
done

> 
> What stress test are you running? What filesystem config does it
> manifest on (other than lazysbcount=1)?  How long does the stress
> test run for, and where/why does log recovery get run in this stress
> test?

I tested with the fsstress tool and used the default mount options. 
More configuration are as follows:

CONFIG_XFS_FS=y
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y

xfs_db> info
meta-data=/dev/sda               isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
	 =                       crc=1        finobt=1, sparse=1, rmapbt=0
	 =                       reflink=1
data     =                       bsize=4096   blocks=262144, imaxpct=25
	 =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
	 =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

With the above test script, it will take several days to reproduce the bug.
If we add a delay in xfs_log_sb(), this will quickly reproduce the problem:

 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		udelay(2000);
 		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 	}

> 
> > > > XFS (loop0): SB summary counter sanity check failed
> > > > XFS (loop0): Metadata corruption detected at xfs_sb_write_verify
> > > > 	     +0x13b/0x460, xfs_sb block 0x0
> > > > XFS (loop0): Unmount and run xfs_repair
> > > > XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > > > 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 28 00 00  XFSB.........(..
> > > > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > > 00000020: 69 fb 7c cd 5f dc 44 af 85 74 e0 cc d4 e3 34 5a  i.|._.D..t....4Z
> > > > 00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
> > > > 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> > > > 00000050: 00 00 00 01 00 0a 00 00 00 00 00 04 00 00 00 00  ................
> > > > 00000060: 00 00 0a 00 b4 b5 02 00 02 00 00 08 00 00 00 00  ................
> > > > 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
> > > > XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply
> > > > 	+0xe1e/0x10e0 (fs/xfs/xfs_buf.c:1580).  Shutting down filesystem.
> > > > XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> > > > XFS (loop0): log mount/recovery failed: error -117
> > > > XFS (loop0): log mount failed
> > > > 
> > > > The cause of the problem is that during the log recovery process, incorrect
> > > > icount and ifree are recovered from the log and fail to pass the size check
> > > 
> > > Are you saying that the log contained a transaction in which ifree >
> > > icount?
> > 
> > Yes, this situation is possible. For example consider the following sequence:
> > 
> >  CPU0				    CPU1
> >  xfs_log_sb			    xfs_trans_unreserve_and_mod_sb
> >  ----------			    ------------------------------
> >  percpu_counter_sum(&mp->m_icount)
> > 				    percpu_counter_add(&mp->m_icount, idelta)
> > 				    percpu_counter_add_batch(&mp->m_icount,
> > 						  idelta, XFS_ICOUNT_BATCH)
> >  percpu_counter_sum(&mp->m_ifree)
> 
> What caused the xfs_log_sb() to be called? Very few things
> actually log the superblock this way at runtime - it's generally
> only logged directly like this when a feature bit changes during a
> transaction (rare) or at a synchronisation point when everything
> else is idle and there's no chance of a race like this occurring...
> 
> I can see a couple of routes to this occurring via feature bit
> modification, but I don't see them being easy to hit or something
> that would exist for very long in the journal. Hence I'm wondering
> if there should be runtime protection for xfs_log_sb() to avoid
> these problems....
> 
> > > > in xfs_validate_sb_write().
> > > > 
> > > > With lazysbcount is enabled, There is no additional lock protection for
> > > > reading m_ifree and m_icount in xfs_log_sb(), if other threads modifies
> > > > the m_ifree between the read m_icount and the m_ifree, this will make the
> > > > m_ifree larger than m_icount and written to the log. If we have an unclean
> > > > shutdown, this will be corrected by xfs_initialize_perag_data() rebuilding
> > > > the counters from the AGF block counts, and the correction is later than
> > > > log recovery. During log recovery, incorrect ifree/icount may be restored
> > > > from the log and written to the super block, since ifree and icount have
> > > > not been corrected at this time, the relationship between ifree and icount
> > > > cannot be checked in xfs_validate_sb_write().
> > > > 
> > > > So, don't check the size between ifree and icount in xfs_validate_sb_write()
> > > > when lazysbcount is enabled.
> > > 
> > > Um, doesn't that neuter a sanity check on all V5 filesystems?
> >
> > Yes, such modifications don't look like the best way, all sb write checks 
> > will be affect. Maybe it can increase the judgment of clean mount and reduce
> > the scope of influence, but this requires setting the XFS_OPSTATE_CLEAN after
> > re-initialise incore superblock counters, like this:
> 
> I'm not sure that silencing the warning and continuing log recovery
> with an invalid accounting state is the best way to proceed. We
> haven't yet recovered unlinked inodes at the time this warning
> fires. If ifree really is larger than icount, then we've got a
> real problem at this point in log recovery.
> 
> Hence I suspect that we should be looking at fixing the runtime race
> condition that leads to the problem, not trying to work around
> inconsistency in the recovery code.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
