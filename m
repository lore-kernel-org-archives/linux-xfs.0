Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77CCC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 21:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85E4C20786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 21:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgHRVmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 17:42:10 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:34411 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbgHRVmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 17:42:09 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id AFBFCD5AC3F;
        Wed, 19 Aug 2020 07:42:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k89Mn-0006TF-9K; Wed, 19 Aug 2020 07:42:01 +1000
Date:   Wed, 19 Aug 2020 07:42:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     hsiangkao@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/13] xfs: in memory inode unlink log items
Message-ID: <20200818214201.GA21744@dread.disaster.area>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200818181745.GL6107@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818181745.GL6107@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=RpiUhSTKKXIpIaWql-EA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 11:17:45AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 12, 2020 at 07:25:43PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is a cleaned up version of the original RFC I posted here:
> > 
> > https://lore.kernel.org/linux-xfs/20200623095015.1934171-1-david@fromorbit.com/
> > 
> > The original description is preserved below for quick reference,
> > I'll just walk though the changes in this version:
> > 
> > - rebased on current TOT and xfs/for-next
> > - split up into many smaller patches
> > - includes Xiang's single unlinked list bucket modification
> > - uses a list_head for the in memory double unlinked inode list
> >   rather than aginos and lockless inode lookups
> > - much simpler as it doesn't need to look up inodes from agino
> >   values
> > - iunlink log item changed to take an xfs_inode pointer rather than
> >   an imap and agino values
> > - a handful of small cleanups that breaking up into small patches
> >   allowed.
> 
> Two questions: How does this patchset intersect with the other one that
> changes the iunlink series?  I guess the v4 of that series (when it
> appears) is intended to be applied directly after this one?

*nod*

> The second is that I got this corruption warning on generic/043 with...

I haven't seen that. I'll see if I can reproduce it.

> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 ca-nfsdev6-mtr01 5.9.0-rc1-djw #rc1 SMP PREEMPT Mon Aug 17 20:13:04 PDT 2020
> MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1 -i sparse=1, -b size=1024, /dev/sdd
> MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdd /opt
>
> [16533.664277] run fstests generic/043 at 2020-08-18 00:50:48

I've run that config through fstests, too. I'll go run this test in
a loop, see if I can trigger it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
