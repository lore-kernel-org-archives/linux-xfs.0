Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06384ECAAA1
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Oct 2022 13:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiJaNzt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 09:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiJaNzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2022 09:55:47 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA091101F3
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 06:55:46 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N1F2P5gDjzpW6K;
        Mon, 31 Oct 2022 21:52:13 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 31 Oct
 2022 21:55:44 +0800
Date:   Mon, 31 Oct 2022 22:17:31 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>, <billodo@redhat.com>,
        <chandan.babu@oracle.com>, <dchinner@redhat.com>,
        <guoxuenan@huawei.com>, <houtao1@huawei.com>,
        <linux-xfs@vger.kernel.org>, <sandeen@redhat.com>,
        <yi.zhang@huawei.com>
Subject: Re: [PATCH v2] xfs: fix sb write verify for lazysbcount
Message-ID: <20221031141731.GB1277642@ceph-admin>
References: <20221022020345.GA2699923@ceph-admin>
 <20221025091527.377976-1-leo.lilong@huawei.com>
 <Y1goB8GfadlYSL9T@magnolia>
 <20221026091344.GA490040@ceph-admin>
 <Y1mB7VfIOms3J2Rj@magnolia>
 <20221027132504.GB490040@ceph-admin>
 <Y1qsQaDA3wcCN+K8@magnolia>
 <20221029071601.GA1277642@ceph-admin>
 <20221030220441.GH3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221030220441.GH3600936@dread.disaster.area>
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 31, 2022 at 09:04:41AM +1100, Dave Chinner wrote:
> On Sat, Oct 29, 2022 at 03:16:01PM +0800, Long Li wrote:
> > On Thu, Oct 27, 2022 at 09:05:21AM -0700, Darrick J. Wong wrote:
> > > On Thu, Oct 27, 2022 at 09:25:04PM +0800, Long Li wrote:
> > > > not pass, therefore it will not write a clean umount record
> > > > at umount. I also haven't found a code suitable for adding
> > > > such checks.
> > > 
> > > xfs_unmountfs just prior to unmounting the log.
> > 
> > 
> > I tried to add an extra check in xfs_log_unmount_write, when m_icount <
> > m_ifree, it will not write a umount log record, after which the summary
> > counters will be recalculated at next mount. If m_ifree greater than
> > m_icount in memory, sb_i{count,free} (the ondisk superblock inode counters)
> > maybe incorrect even after unmount filesystem. After adding such checks,
> > it can be corrected on the next mount, instead of going undetected in
> > subsequent mounts.
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index f1f44c006ab3..e4903c15019e 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1038,7 +1038,9 @@ xfs_log_unmount_write(
> >  	 * more details.
> >  	 */
> >  	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
> > -			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
> > +			XFS_ERRTAG_FORCE_SUMMARY_RECALC) ||
> > +			(percpu_counter_sum(&mp->m_icount) <
> > +			 percpu_counter_sum(&mp->m_ifree))) {
> >  		xfs_alert(mp, "%s: will fix summary counters at next mount",
> >  				__func__);
> >  		return;
> 
> The log code is not the layer at which the mount structures
> should be verified. xfs_unmountfs() is where the mount is cleaned up
> and all activity is flushed and waited on. THis is where the mount
> counters should be checked, before we unmount the log.
> 
> Indeed, if you check the mount counters prior to calling
> xfs_log_unmount_write(), you could call this:
> 
> 	xfs_alert(mp, "ifree/icount mismatch at unmount");
> 	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
> 
> i.e. check the mount state at the correct level and propagate the
> sickness into the mount state and the log code will just do the
> right thing....
> 
> Cheers,
> 
> Dave.
 
Ok, I'll resend a patch and fix the above issue, thanks a lot.
