Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56190C5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 318CA21929
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733032AbfKGDq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:46:26 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59911 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727279AbfKGDq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:46:26 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 80BDD43FA56;
        Thu,  7 Nov 2019 14:46:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iSYkX-0000lV-HO; Thu, 07 Nov 2019 14:46:21 +1100
Date:   Thu, 7 Nov 2019 14:46:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v2] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
Message-ID: <20191107034621.GG4614@dread.disaster.area>
References: <1572947532-4972-1-git-send-email-kaixuxia@tencent.com>
 <20191106045630.GO15221@magnolia>
 <20191106124932.GA37080@bfoster>
 <20191106154612.GH4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106154612.GH4153244@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=GlDBiw74LckPmvPc9c8A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 07:46:12AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 07:49:32AM -0500, Brian Foster wrote:
> > > >  /*
> > > > + * Check whether the replace operation need more blocks.
> > > > + */
> > > > +bool
> > > > +xfs_dir2_sf_replace_needblock(
> > > 
> > > Urgggh.  This is a predicate that we only ever call from xfs_rename(),
> > > right?  And it addresses a particular quirk of the locking when the
> > > caller wants us to rename on top of an existing entry and drop the link
> > > count of the old inode, right?  So why can't this just be a predicate in
> > > xfs_inode.c ?  Nobody else needs to know this particular piece of
> > > information, AFAICT.
> > > 
> > > (Apologies, for Brian and I clearly aren't on the same page about
> > > that...)
> > > 
> > 
> > Hmm.. the crux of my feedback on the previous version was simply that if
> > we wanted to take this approach of pulling up lower level dir logic into
> > the higher level rename code, to simply factor out the existing checks
> > down in the dir replace code that currently trigger a format conversion,
> > and use that new helper in both places. That doesn't appear to be what
> > this patch does, and I'm not sure why there are now two new helpers that
> > each only have one caller instead of one new helper with two callers...
> 
> Aha, got it.  I'd wondered if that had been your intent. :)

So as a structural question: should this be folded into
xfs_dir_canenter(), which is the function used to check if the
directory modification can go ahead without allocating blocks....

This seems very much like it is a "do we need to allocate blocks
during the directory modification?" sort of question being asked
here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
