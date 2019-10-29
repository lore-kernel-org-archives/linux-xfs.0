Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AFECA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD98720862
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfJ2Xyn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:54:43 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37804 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbfJ2Xyn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:54:43 -0400
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 07EA93A1D39;
        Wed, 30 Oct 2019 10:54:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iPbJv-00073b-Op; Wed, 30 Oct 2019 10:54:39 +1100
Date:   Wed, 30 Oct 2019 10:54:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191029235439.GP4614@dread.disaster.area>
References: <20191029223752.28562-1-david@fromorbit.com>
 <20191029233337.GH15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029233337.GH15222@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=2tdcmslYzAxlwHnCbwcA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 04:33:37PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 30, 2019 at 09:37:52AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > AIO+DIO can extend the file size on IO completion, and it holds
> > no inode locks while the IO is in flight. Therefore, a race
> > condition exists in file size updates if we do something like this:
> > 
> > aio-thread			fallocate-thread
> > 
> > lock inode
> > submit IO beyond inode->i_size
> > unlock inode
> > .....
> > 				lock inode
> > 				break layouts
> > 				if (off + len > inode->i_size)
> > 					new_size = off + len
> > 				.....
> > 				inode_dio_wait()
> > 				<blocks>
> > .....
> > completes
> > inode->i_size updated
> > inode_dio_done()
> > ....
> > 				<wakes>
> > 				<does stuff no long beyond EOF>
> > 				if (new_size)
> > 					xfs_vn_setattr(inode, new_size)
> > 
> > 
> > Yup, that attempt to extend the file size in the fallocate code
> > turns into a truncate - it removes the whatever the aio write
> > allocated and put to disk, and reduced the inode size back down to
> > where the fallocate operation ends.
> > 
> > Fundamentally, xfs_file_fallocate()  not compatible with racing
> > AIO+DIO completions, so we need to move the inode_dio_wait() call
> > up to where the lock the inode and break the layouts.
> > 
> > Secondly, storing the inode size and then using it unchecked without
> > holding the ILOCK is not safe; we can only do such a thing if we've
> > locked out and drained all IO and other modification operations,
> > which we don't do initially in xfs_file_fallocate.
> > 
> > It should be noted that some of the fallocate operations are
> > compound operations - they are made up of multiple manipulations
> > that may zero data, and so we may need to flush and invalidate the
> > file multiple times during an operation. However, we only need to
> > lock out IO and other space manipulation operations once, as that
> > lockout is maintained until the entire fallocate operation has been
> > completed.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks reasonable to me; what do you think of my regression test?

Looks reasonable at a first glance. Not much different what I was
using to test this patch. I haven't looked in more detail than that
yet...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
