Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A14CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 01:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiBGBFr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Feb 2022 20:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiBGBFq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Feb 2022 20:05:46 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2CC4C06173B
        for <linux-xfs@vger.kernel.org>; Sun,  6 Feb 2022 17:05:45 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D40F010C6035;
        Mon,  7 Feb 2022 12:05:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nGsTN-008yZS-Tv; Mon, 07 Feb 2022 12:05:41 +1100
Date:   Mon, 7 Feb 2022 12:05:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 04/17] libfrog: move the GETFSMAP definitions into libfrog
Message-ID: <20220207010541.GE59729@dread.disaster.area>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263811682.863810.12064586264139896800.stgit@magnolia>
 <bb88560e-bbdf-80c5-b4d6-6c00f4ab3ef1@sandeen.net>
 <20220205003618.GU8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205003618.GU8313@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62007068
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=nlQgCtCLTCGONM5pK3IA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 04, 2022 at 04:36:18PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 04, 2022 at 05:18:12PM -0600, Eric Sandeen wrote:
> > On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Move our private copy of the GETFSMAP definition into a libfrog header
> > > file that (preferentially) uses the system header files.  We have no
> > > business shipping kernel headers in the xfslibs package, but this shim
> > > is still needed to build fully functional xfsprogs on old userspace.
> > 
> > Hm. Fine, but I wonder if we can get a bit more intentional about how
> > we handle this kind of thing, I understand why we copy this stuff into
> > xfsprogs early, but then we never know how to get rid of it.
> > 
> > Do we /need/ to build fully functional xfsprogs on old userspace?
> > (really: systems with old kernel headers?)  How far back do we go,
> > I wonder?  Anyway...
> 
> TBH we could probably get rid of these entirely, assuming nobody is
> building xfsprogs with old kernel headers for a system with a newer
> kernel?

Just fiddle the autoconf rules to refuse to build if the system
headers we need aren't present. It just means that build systems
need to have the userspace they intend to target installed in the
build environment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
