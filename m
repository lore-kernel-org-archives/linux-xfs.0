Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCE1C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 22:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EFF2207CB
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 22:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgGPWGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 18:06:10 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:40099 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbgGPWGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 18:06:10 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 3C2C1D59DF1;
        Fri, 17 Jul 2020 08:06:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwC0z-0000p9-O4; Fri, 17 Jul 2020 08:06:05 +1000
Date:   Fri, 17 Jul 2020 08:06:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] repair: use fs root ino for dummy parent value
 instead of zero
Message-ID: <20200716220605.GM2005@dread.disaster.area>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-4-bfoster@redhat.com>
 <20200715222216.GH2005@dread.disaster.area>
 <20200716104103.GB26218@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716104103.GB26218@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=cVBLk4NVIW_AA7u7hokA:9 a=y3QdnymCw1F_V5lu:21 a=8AtYZZoPygbbD5fp:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 16, 2020 at 06:41:03AM -0400, Brian Foster wrote:
> On Thu, Jul 16, 2020 at 08:22:16AM +1000, Dave Chinner wrote:
> > On Wed, Jul 15, 2020 at 10:08:35AM -0400, Brian Foster wrote:
> > > If a directory inode has an invalid parent ino on disk, repair
> > > replaces the invalid value with a dummy value of zero in the buffer
> > > and NULLFSINO in the in-core parent tracking. The zero value serves
> > > no functional purpose as it is still an invalid value and the parent
> > > must be repaired by phase 6 based on the in-core state before the
> > > buffer can be written out.  Instead, use the root fs inode number as
> > > a catch all for invalid parent values so phase 6 doesn't have to
> > > create custom verifier infrastructure just to work around this
> > > behavior.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > 
> > Reasonale, but wouldn't it be better to use lost+found as the dummy
> > parent inode (i.e. the orphanage inode)? Because if the parent can't
> > be found and the inode reconnected correctly, we're going to put it
> > in lost+found, anyway?
> > 
> 
> That was my first thought when I originally wrote this, but there's
> several reasons I didn't end up doing that. The orphanage isn't created
> until much later in repair and only if we end up with orphaned inodes.
> We'd have to change that in order to use a dummy parent inode number
> that corresponds to a valid orphanage, and TBH I'm not even sure if it's
> always going to be safe to expect an inode allocation to work at this
> point in repair.
> 
> Further, it's still too early to tell whether these directories are
> orphaned because the directory scan in phase 6 can easily repair
> missing/broken parent information. The scenarios I used to test this
> functionality didn't involve the orphanage at all, so now we not only
> need to change when/how the orphanage is created, but need to free it if
> it ends up unused before we exit (which could be via any number of
> do_error() calls before we ever get close to phase 6).

Fair enough - can you please capture all this in the commit message
to preserve the explanation of why the root inode was chosen and
not lost+found?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
