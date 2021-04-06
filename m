Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789A4C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 21:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AFD9613BE
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 21:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhDFV3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 17:29:15 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:44346 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235382AbhDFV3P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 17:29:15 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 088391AEAEA;
        Wed,  7 Apr 2021 07:29:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lTtFx-00DQ7O-Fj; Wed, 07 Apr 2021 07:29:05 +1000
Date:   Wed, 7 Apr 2021 07:29:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: eager inode attr fork init needs attr feature
 awareness
Message-ID: <20210406212905.GB63242@dread.disaster.area>
References: <20210406115923.1738753-1-david@fromorbit.com>
 <20210406115923.1738753-2-david@fromorbit.com>
 <20210406154016.GA3104374@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406154016.GA3104374@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=mfH6F2gJkMvfHmfdzsgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 04:40:16PM +0100, Christoph Hellwig wrote:
> On Tue, Apr 06, 2021 at 09:59:20PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The pitfalls of regression testing on a machine without realising
> > that selinux was disabled. Only set the attr fork during inode
> > allocation if the attr feature bits are already set on the
> > superblock.
> 
> This doesn't apply to the current xfs/for-next tree to me, with
> rejects in xfs_default_attroffset.

Not sure why you'd get rejects in xfs_default_attroffset() given
this patch doesn't change that function at all.

The whole series applies fine here on 5.12-rc6 + xfs/for-next. Head
of the xfs/for-next branch I'm using is commit 25dfa65f8149 ("xfs:
fix xfs_trans slab cache name") which matches the head commit in the
kernel.org tree...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
