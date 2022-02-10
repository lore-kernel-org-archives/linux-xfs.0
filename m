Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5331C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Feb 2022 03:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiBJDdX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Feb 2022 22:33:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiBJDdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Feb 2022 22:33:20 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5812A1163
        for <linux-xfs@vger.kernel.org>; Wed,  9 Feb 2022 19:33:20 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5BD1952CB7F;
        Thu, 10 Feb 2022 14:33:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nI0Cp-00ACTw-NN; Thu, 10 Feb 2022 14:33:15 +1100
Date:   Thu, 10 Feb 2022 14:33:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 04/17] libfrog: move the GETFSMAP definitions into libfrog
Message-ID: <20220210033315.GL59729@dread.disaster.area>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263811682.863810.12064586264139896800.stgit@magnolia>
 <bb88560e-bbdf-80c5-b4d6-6c00f4ab3ef1@sandeen.net>
 <20220205003618.GU8313@magnolia>
 <20220207010541.GE59729@dread.disaster.area>
 <20220207170913.GA8313@magnolia>
 <fbe0bef1-a9a7-9670-1548-9792639ae2a2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbe0bef1-a9a7-9670-1548-9792639ae2a2@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6204877d
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=TrKQWF5WU7bv2lRiUR0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 07, 2022 at 03:32:10PM -0600, Eric Sandeen wrote:
> On 2/7/22 11:09 AM, Darrick J. Wong wrote:
> > On Mon, Feb 07, 2022 at 12:05:41PM +1100, Dave Chinner wrote:
> >> On Fri, Feb 04, 2022 at 04:36:18PM -0800, Darrick J. Wong wrote:
> >>> On Fri, Feb 04, 2022 at 05:18:12PM -0600, Eric Sandeen wrote:
> 
> ...
> 
> >>>> Do we /need/ to build fully functional xfsprogs on old userspace?
> >>>> (really: systems with old kernel headers?)  How far back do we go,
> >>>> I wonder?  Anyway...
> >>>
> >>> TBH we could probably get rid of these entirely, assuming nobody is
> >>> building xfsprogs with old kernel headers for a system with a newer
> >>> kernel?
> >>
> >> Just fiddle the autoconf rules to refuse to build if the system
> >> headers we need aren't present. It just means that build systems
> >> need to have the userspace they intend to target installed in the
> >> build environment.
> > 
> > GETFSMAP premiered in 4.12, so I'm going to take this response (and the
> > lack of any others) as a sign that I can respin this patch to require
> > recent kernel headers instead of providing our own copy.
> 
> Sounds reasonable, thanks. Maybe in the future when we add stuff like
> this for bleeding edge interfaces we can mark the date, and mark another
> one in what, a year or two, as a reminder for removal.

That's what we've done in the past - provide our own copy until the
system headers catch up and then remove our copy. Note that this may
cause angst with lesser used C libraries (like musl), but they need
to keep up with new kernel APIs to be really useful, anyway...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
