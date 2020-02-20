Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55E7C11D00
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 22:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 814B620801
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 22:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgBTWG6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 17:06:58 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58429 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727656AbgBTWG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 17:06:57 -0500
Received: from dread.disaster.area (pa49-195-185-106.pa.nsw.optusnet.com.au [49.195.185.106])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 625CD3A4653;
        Fri, 21 Feb 2020 09:06:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4ty8-0003xj-OY; Fri, 21 Feb 2020 09:06:52 +1100
Date:   Fri, 21 Feb 2020 09:06:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200220220652.GP10776@dread.disaster.area>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200220034106.GO10776@dread.disaster.area>
 <20200220142520.GF48977@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220142520.GF48977@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=bkRQb8bsQZKWSSj4M57YXw==:117 a=bkRQb8bsQZKWSSj4M57YXw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=2y6CqJFtbjmwZ1nhrgUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 09:25:20AM -0500, Brian Foster wrote:
> On Thu, Feb 20, 2020 at 02:41:06PM +1100, Dave Chinner wrote:
> > On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> > > I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> > > actual modern typical use case for it. I thought this was somewhat
> > > realted to DAX use but upon a quick code inspection I see direct
> > > realtionship.
> > 
> > Facebook use it in production systems to separate large file data
> > from metadata and small files. i.e. they use a small SSD based
> > partition for the filesytem metadata and a spinning disk for
> > the large scale data storage. Essentially simple teired storage.
> > 
> 
> Didn't this involve custom functionality? I thought they had posted
> something at one point that wasn't seen through to merge, but I could be
> misremembering (or maybe that was something else RT related). It doesn't

Yes, but that is largely irrelevant. It requires the RT device to
function, and the RT device functionality is entirely unchanged. All
that changed was the initial data allocation policy to select
whether the RT or data device would be used, and that really isn't
that controversial as we've always suggested this is a potential use
of the RT device (fast and slow storage in the one filesystem
namespace).

> matter that much as there are probably other users out there, but I'm
> not sure this serves as a great example use case if it did require
> downstream customizations

There are almost always downstream modifications in private cloud
storage kernels, even if it is just bug fixes. They aren't shipping
the code to anyone, so they don't have to publish those changes.
However, the presence of downstream changes doesn't mean the
upstreram functionality should be considered unused and can be
removed....

> that aren't going to be generalized/supported
> for the community.. Richard..?

IIRC, we were simply waiting on an updated patchset to address
review comments...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
