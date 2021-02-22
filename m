Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B378AC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 02:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7526564EE6
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 02:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhBVCpO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Feb 2021 21:45:14 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46923 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhBVCpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Feb 2021 21:45:09 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 917121040CEB;
        Mon, 22 Feb 2021 13:44:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lE1Cz-00G1S2-7n; Mon, 22 Feb 2021 13:44:25 +1100
Date:   Mon, 22 Feb 2021 13:44:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Steve Langasek <steve.langasek@canonical.com>
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] debian: Regenerate config.guess using debhelper
Message-ID: <20210222024425.GP4662@dread.disaster.area>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-4-bastiangermann@fishpost.de>
 <20210221041139.GL4662@dread.disaster.area>
 <840CCF3D-7A20-4E35-BA9C-DEC9C05EE70A@canonical.com>
 <20210221220443.GO4662@dread.disaster.area>
 <20210222001639.GA1737229@homer.dodds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222001639.GA1737229@homer.dodds.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=danhDmx_AAAA:8 a=7-415B0cAAAA:8
        a=oy259ajWkAEbgt-2ajEA:9 a=CjuIK1q_8ugA:10 a=P4VdviVPEcjfz_PVVggX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 21, 2021 at 04:16:39PM -0800, Steve Langasek wrote:
> On Mon, Feb 22, 2021 at 09:04:43AM +1100, Dave Chinner wrote:
> 
> > > This upstream release ended up with an older version of config.guess in
> > > the tarball.  Specifically, it was too old to recognize RISC-V as an
> > > architecture.
> 
> > So was the RISC-V architecture added to the ubuntu build between the
> > uploads of the previous version of xfsprogs and xfsprogs-5.10.0? Or
> > is this an actual regression where the maintainer signed tarball had
> > RISC-V support in it and now it doesn't?
> 
> This is a regression.  The previous tarball (5.6.0) had a newer config.guess
> that recognized RISC-V, the newer one (5.10.0) had an older config.guess.

Ok.

Eric, did you change the machine you did the release build from?

> > $ man 7 dh-autoreconf
> > ....
> > CAVEATS
> >        dh_autoreconf is mostly a superset of the
> >        dh_update_autotools_config debhelper command included in
> >        debhelper since version 9.20160115. When using the dh
> >        sequencer, dh_update_autotools_config is run before
> >        dh_autoreconf and updates the config.guess and config.sub
> >        files. This is required in cases where autoreconf does not
> >        update config.guess and config.sub itself.
> 
> > So isn't the dh_update_autotools_config call in the wrong place
> > here?
> 
> Documentation notwithstanding, dh_autoreconf was definitively NOT copying in
> the newer config.guess, and we have the build logs to prove it.
> 
> https://launchpad.net/ubuntu/+source/xfsprogs/5.10.0-2ubuntu1/+build/20952006

I'm not denying that it fixed your problem. As a reviewer, I'm
supposed to point out where the proposed fix doesn't match with
expected usage. And as a reviewer, I expect that patched get changed
to address problems that are found before they are committed, not to
be told:

> I don't know in what sense this would be the "wrong" place to call it,
> because it fixes the build failure, which is what I care about.

"It made my problem go away, so my job is done."

You didn't report it upstream so we could avoid the regression in
future, to either the debian package maintainers or the XFS lists.
Nor do you seem to care if the fix is correct or whether anyone else
might need it.

In future, if there is a regression in the upstream xfsprogs
package, please report it upstream and not just keep it to yourself
and hack around it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
