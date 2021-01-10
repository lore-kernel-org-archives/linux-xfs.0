Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4347C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 21:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A137322A85
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 21:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbhAJVFW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 16:05:22 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:38445 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726346AbhAJVFV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 16:05:21 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id CA479A726;
        Mon, 11 Jan 2021 08:04:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kyht6-0057nb-L1; Mon, 11 Jan 2021 08:04:36 +1100
Date:   Mon, 11 Jan 2021 08:04:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 2/4] xfs: get rid of xfs_growfs_{data,log}_t
Message-ID: <20210110210436.GM331610@dread.disaster.area>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-3-hsiangkao@redhat.com>
 <20210108212132.GS38809@magnolia>
 <f1b99677-aefa-a026-681a-e7d0ad515a8a@sandeen.net>
 <20210109004934.GB660098@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109004934.GB660098@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=QWR5TQ4p6ySmwqrg_OIA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 09, 2021 at 08:49:34AM +0800, Gao Xiang wrote:
> On Fri, Jan 08, 2021 at 03:27:21PM -0600, Eric Sandeen wrote:
> > On 1/8/21 3:21 PM, Darrick J. Wong wrote:
> > > On Sat, Jan 09, 2021 at 03:09:17AM +0800, Gao Xiang wrote:
> > >> Such usage isn't encouraged by the kernel coding style.
> > >>
> > >> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > >> ---
> > >>  fs/xfs/libxfs/xfs_fs.h |  4 ++--
> > >>  fs/xfs/xfs_fsops.c     | 12 ++++++------
> > >>  fs/xfs/xfs_fsops.h     |  4 ++--
> > >>  fs/xfs/xfs_ioctl.c     |  4 ++--
> > >>  4 files changed, 12 insertions(+), 12 deletions(-)
> > >>
> > >> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > >> index 2a2e3cfd94f0..a17313efc1fe 100644
> > >> --- a/fs/xfs/libxfs/xfs_fs.h
> > >> +++ b/fs/xfs/libxfs/xfs_fs.h
> > >> @@ -308,12 +308,12 @@ struct xfs_ag_geometry {
> > >>  typedef struct xfs_growfs_data {
> > >>  	__u64		newblocks;	/* new data subvol size, fsblocks */
> > >>  	__u32		imaxpct;	/* new inode space percentage limit */
> > >> -} xfs_growfs_data_t;
> > >> +};
> > > 
> > > So long as Eric is ok with fixing this up in xfs_fs_compat.h in
> > > userspace,
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Sure, why not :) (tho is growfs really a public interface?  I guess so,
> > technically, though not documented as such.)

They are not described in man pages, though they are listed in
xfsctl(3) so they are definitely public interfaces.

> Yeah, although I think nobody else uses it (I could leave the typedef
> definitions only if needed otherwise...)

It is used elsewhere - ISTR that it is used by a couple of third
party applications that integrate growing filesystems into their
other storage management tasks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
