Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12062C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D583664E85
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhBWUx0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:53:26 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:33864 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233671AbhBWUwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 15:52:15 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 901A01025D5;
        Wed, 24 Feb 2021 07:51:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEeeX-0018y9-Be; Wed, 24 Feb 2021 07:51:29 +1100
Date:   Wed, 24 Feb 2021 07:51:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Steve Langasek <steve.langasek@canonical.com>,
        Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] debian: Regenerate config.guess using debhelper
Message-ID: <20210223205129.GY4662@dread.disaster.area>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-4-bastiangermann@fishpost.de>
 <20210221041139.GL4662@dread.disaster.area>
 <840CCF3D-7A20-4E35-BA9C-DEC9C05EE70A@canonical.com>
 <20210221220443.GO4662@dread.disaster.area>
 <20210222001639.GA1737229@homer.dodds.net>
 <20210222024425.GP4662@dread.disaster.area>
 <957b9913-bcdb-b64c-4c33-6493a91b3838@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <957b9913-bcdb-b64c-4c33-6493a91b3838@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=MIvDQeynTPKDQ_eNKvIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 22, 2021 at 01:23:12PM -0600, Eric Sandeen wrote:
> On 2/21/21 8:44 PM, Dave Chinner wrote:
> > On Sun, Feb 21, 2021 at 04:16:39PM -0800, Steve Langasek wrote:
> >> On Mon, Feb 22, 2021 at 09:04:43AM +1100, Dave Chinner wrote:
> >>
> >>>> This upstream release ended up with an older version of config.guess in
> >>>> the tarball.  Specifically, it was too old to recognize RISC-V as an
> >>>> architecture.
> >>
> >>> So was the RISC-V architecture added to the ubuntu build between the
> >>> uploads of the previous version of xfsprogs and xfsprogs-5.10.0? Or
> >>> is this an actual regression where the maintainer signed tarball had
> >>> RISC-V support in it and now it doesn't?
> >>
> >> This is a regression.  The previous tarball (5.6.0) had a newer config.guess
> >> that recognized RISC-V, the newer one (5.10.0) had an older config.guess.
> > 
> > Ok.
> > 
> > Eric, did you change the machine you did the release build from?
> 
> I don't recall doing so, but I must have. I guess I remember this coming up
> a while ago and maybe I failed to change process in a sticky way.  :/
> 
> But - if my local toolchain can cause a regression in a major distro, it seems
> like this patch to regenerate is the obvious path forward, to control
> the distro-specific build, and not be subject to my personal toolchain whims.

I think it's on the package maintainer to ensure what is uploaded as
the official distro package contains the correct tarball contents
for their distro. If the distro build overrides shipped config
files, then there shouldn't be any problems at all with just using
the upstream tarball.

> Is that not best practice? (I honestly don't know.)

Honestly, I think building packages from tarballs is an anachronism
of a time gone by. Debian xfsprogs packages can be build directly
from a clean git tree and none of these problems exist in that case.
i.e. a clean git tree requires the build to libtoolize/autoconf and
set up the source tree from it's environment before anything else,
hence there's nothing that needs to be overridden...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
