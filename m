Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6822C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 08:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8503A206F4
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 08:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfKRIWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 03:22:20 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60229 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726414AbfKRIWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 03:22:20 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 925993A173D;
        Mon, 18 Nov 2019 19:22:17 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iWcIa-0007er-RZ; Mon, 18 Nov 2019 19:22:16 +1100
Date:   Mon, 18 Nov 2019 19:22:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
Message-ID: <20191118082216.GU4614@dread.disaster.area>
References: <20191111213630.14680-1-amir73il@gmail.com>
 <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area>
 <20191113035611.GE6219@magnolia>
 <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com>
 <20191113045840.GR6219@magnolia>
 <CAOQ4uxh0T-cddZ9gwPcY6O=Eg=2g855jYbjic=VwihYPz2ZeBw@mail.gmail.com>
 <20191113052032.GU6219@magnolia>
 <CAOQ4uxiTRWkeM6i6tyMe5dzSN8nsR=1XZEMEwwwVJAcJNVimGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiTRWkeM6i6tyMe5dzSN8nsR=1XZEMEwwwVJAcJNVimGA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=VNH_mPWXY4d5qMcgPMcA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 18, 2019 at 06:52:39AM +0200, Amir Goldstein wrote:
> > >
> > > I wonder if your version has struct xfs_dinode_v3 or it could avoid it.
> > > There is a benefit in terms of code complexity and test coverage
> > > to keep the only difference between inode versions in the on-disk
> > > parsers, while reading into the same struct, the same way as
> > > old inode versions are read into struct xfs_dinode.
> > >
> > > Oh well, I can wait for tomorrow to see the polished version :-)
> >
> > Well now we noticed that Arnd also changed the disk quota structure
> > format too, so that'll slow things down as we try to figure out how to
> > reconcile 34-bit inode seconds vs. 40-bit quota timer seconds.
> >
> > (Or whatever happens with that)
> >
> 
> Sigh. FWIW, I liked Arnd's 40-bit inode time patch because it
> keeps the patch LoC for this conversion minimal.

We can extend the quota warning range without changing the on-disk
structures, and with much less code than changing the on-disk
structures.

We only need a ~500 year range for the warning expiry timestamp, and
we don't really care about fine grained resolution of the timer
expiry.

We've already got a 70 year range with the signed second counter. So
let's just redefine the timeout value on disk to use units of 10s
instead of 1s when the bigtime superblock feature bit is set. ANd
now we have our >500 year range requirement.

That shouldn't need much more than 5-10 lines of new code
translating the units when we read/write them from/to disk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
