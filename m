Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FCAC2D0F6
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 02:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D955206F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 02:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgEMCgX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 22:36:23 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:58636 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726078AbgEMCgW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 22:36:22 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id D1151D58C3B
        for <linux-xfs@vger.kernel.org>; Wed, 13 May 2020 12:36:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYhFq-0001y1-6Y
        for linux-xfs@vger.kernel.org; Wed, 13 May 2020 12:36:18 +1000
Date:   Wed, 13 May 2020 12:36:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [XFS SUMMIT] Deprecating V4 on-disk format
Message-ID: <20200513023618.GA2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=mOfOdFaok2WxlZ-8K1wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Topic: Deprecating V4 On-disk Format

Scope:
	Long term life cycle planning
	Supporting old filesystems with new kernels.
	Unfixable integrity issues in v4 format.
	Reducing feature matrix for testing

Proposal:

The CRC-enabled V5 format has been the upstream default format now
since commit 566ebd5ae5fa ("mkfs: default to CRC enabled
filesystems") dated May 11 2015 (5 years ago!) and released in
xfsprogs v3.2.3. It is the default in all major distros, and has
been for some time.

We know that the v4 format has unfixable integrity issues apart from
the obvious lack of CRCs and self-describing metadata structures; it
has race conditions in log recovery realted to inode creation and
other such issues that could only be solved with an on-disk format
change of some kind. We are not adding new features to v4 formats,
so anyone wanting to use new XFS features must use v5 format
filesystems.

We also know that the number of v4 filesysetms in production is
slowly decreasing as systems are replaced as part of the natural
life cycle of production systems.

All this adds up to the realisation that existing v4 filesystems are
effectively in the "Maintenance Mode" era of the software life
cycle. The next stage in the life cycle is "Phasing Out" before we
drop support for it altogether, also know around here as
"deprecated" which is a sign that support will "soon" cease.

I'd like to move the v4 format to the "deprecated" state as a signal
to users that it should really not be considered viable for new
systems. New systems running modern kernels and userspace should
all be using the v5 format, so this mostly only affects existing
filesystems.

Note: I am not proposing that we drop support for the v4 format any
time soon. What I am proposing is an "end of lifecycle" tag similar
to the way we use EXPERIMENTAL to indicate that the functionality is
available but we don't recommend it for production systems yet.

Hence what I am proposing is that we introduce a DEPRECATED alert at
mount time to inform users that the functionality exists, but it
will not be maintained indefinitely into the future. For distros
with a ten year support life, this means that a near-future release
will pick up the DEPRECATED tag but still support the filesystem for
the support life of that release. A "future +1" release may not
support the v4 format at all.

Discussion points:

- How practical is this?
- What should we have mkfs do when directed to create a v4 format
  filesystem?
- How long before we decide to remove v4 support from the upstream
  kernel and tools? 5 years after deprecation? 10 years?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
