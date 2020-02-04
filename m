Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE89BC35247
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 21:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 987C52082E
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 21:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgBDVGi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 16:06:38 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49958 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727537AbgBDVGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 16:06:37 -0500
Received: from dread.disaster.area (pa49-181-161-120.pa.nsw.optusnet.com.au [49.181.161.120])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A8F8A3A1896;
        Wed,  5 Feb 2020 08:06:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iz5Oy-0005gw-2Z; Wed, 05 Feb 2020 08:06:32 +1100
Date:   Wed, 5 Feb 2020 08:06:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 2/7] xfs: Update checking excl. locks for ilock
Message-ID: <20200204210632.GL20628@dread.disaster.area>
References: <20200203175850.171689-1-preichl@redhat.com>
 <20200203175850.171689-3-preichl@redhat.com>
 <20200204062118.GB2910@infradead.org>
 <80f1173e-9181-c8cc-c06f-cbbfaa46a138@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80f1173e-9181-c8cc-c06f-cbbfaa46a138@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=SkgQWeG3jiSQFIjTo4+liA==:117 a=SkgQWeG3jiSQFIjTo4+liA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=wjrQEC2q8vSFFpZmR8QA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 10:08:45AM -0600, Eric Sandeen wrote:
> On 2/4/20 12:21 AM, Christoph Hellwig wrote:
> >> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> >> +	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
> > 
> > I think this is a very bad interface.  Either we keep our good old
> > xfs_isilocked that just operates on the inode and lock flags, or
> > we use something that gets the actual lock passed.  But an interface
> > that encodes the lock in both the function called and the flags, and
> > one that doesn't follow neither the XFS lock flags conventions nor
> > the core kernel convention is just not very useful.
> 
> I think this came out of Dave's suggestion on the previous patchset,
> but I agree with you Chrisoph.  Even if there is a future reason to
> split it out into a function for each type, I don't see a reason to
> do it now, and this interface is awkward.
> 
> I'd prefer to keep xfs_isilocked() with the current calling convention and
> just change its internals to use lockdep.  Dave spotted a bug in the
> current implementation, but I think that can be fixed.
> 
> Splitting out the 3 lock testing functions seems to me like complexity
> creep that doesn't need to be in this series.
> 
> Dave, thoughts?

All I care about is that we get rid of the mrlock_t. I'm not
interested in bikeshedding the details to death. I've put my 2c
worth in, if you don't like it, then that's fine and I'm not going
to get upset about that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
