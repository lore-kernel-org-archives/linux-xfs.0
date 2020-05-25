Return-Path: <SRS0=1/fZ=7H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2031C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 03:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE4252073B
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 03:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388728AbgEYDX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 23:23:58 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52179 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388667AbgEYDX6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 23:23:58 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 0E6205AAE13;
        Mon, 25 May 2020 13:23:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jd3iU-0002KU-1m; Mon, 25 May 2020 13:23:54 +1000
Date:   Mon, 25 May 2020 13:23:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] Deprecating V4 on-disk format
Message-ID: <20200525032354.GV2040@dread.disaster.area>
References: <20200513023618.GA2040@dread.disaster.area>
 <20200519062338.GH17627@magnolia>
 <20200520011430.GS2040@dread.disaster.area>
 <20200520151510.11837539@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200520151510.11837539@harpe.intellique.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=8nJEP1OIZ-IA:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=RLQBQRi0TAGZ_z2De6sA:9 a=MSXr6ah4ekYLqOOf:21 a=bgxhWz7iBVJvvFqY:21
        a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 03:15:10PM +0200, Emmanuel Florac wrote:
> Le Wed, 20 May 2020 11:14:30 +1000
> Dave Chinner <david@fromorbit.com> écrivait:
> 
> > Well, there's a difference between what a distro that heavily
> > patches the upstream kernel is willing to support and what upstream
> > supports. And, realistically, v4 is going to be around for at least
> > one more major distro release, which means the distro support time
> > window is still going to be in the order of 15 years.
> 
> IIRC, RedHat/CentOS v.7.x shipped with a v5-capable mkfs.xfs, but
> defaulted to v4. That means that unless you were extremely cautious
> (like I am :) 99% of RH/COs v7 will be running v4 volumes for the
> coming years. How many years, would you ask?

Largely irrelevant to the question at hand, as support is dependent
on the distro lifecycle here. Essentially whatever is in RHEL7 is
supported by RH until the end of it's life.

In RHEL8, we default to v5 filesystems, but fully support v4. That
will be the case for the rest of it's life. Unless the user
specifically asks for it, no new v4 filesystems are being created on
current RHEL releases.

If we were to deprecate v4 now, then it will be marked as deprecated
in the next major RHEL release. That means it's still fully
supported in that release for it's entire life, but it will be
removed in the next major release after that. So we are still
talking about at least 15+ years of enterprise distro support for
the format, even if upstream drops it sooner...

> As for the lifecycle of a filesystem, I just ended support on a 40 TB
> archival server I set up back in 2007. I still have a number of
> supported systems from the years 2008-2010, and about a hundred from
> 2010-2013. That's how reliable XFS is, unfortunately :)

Yup, 10-15 years is pretty much the expected max life of storage
systems before the hardware really needs to be retired. We made v5
the default 5 years ago, so give it another 10 years (the sort of
timeframe we are talking about here) and just about
everything will be running v5 and that's when v4 can likely be
dropped.

The other thing to consider is that we need to drop v4 before we get
to y2038 support issues as the format will never support dates
beyond that. Essentially, we need to have the deprecation discussion
and take action in the near future so that people have stopped using
it before y2038 comes along and v4 filesystems break everything.

Not enough people think long term when it comes to computers - it
should be more obvious now why I brought this up for discussion...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
