Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459D7C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 04:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiFBENb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 00:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiFBENa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 00:13:30 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCE723283F;
        Wed,  1 Jun 2022 21:13:27 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2524CndX023801
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 2 Jun 2022 00:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1654143172; bh=CH4zgyw+r44uqQeumdtHJpdBNHEoDwelYiKs6MpZ4PQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=LUGqe9HtLw6kz65qrRaLZhjD2J2/kCUvc5LZdtjvyg/CEFx9xsLA5yoAJ4PhxQdnG
         b6+aGtD8yhQfKsbQCPqWDHbmi4wuyZcrM3+mRDbN/N5tMVqT5xROHfcwmek3jAfCq7
         akTrIbljZk+knWdvQAm203JDChIj4ZH/GxZj2cb2fqB9daxRibjXHENBAWBnILG6gA
         k/Ni9dMOWnohl6r9QjKNGMk9NuZMRY5na1y2BdDRm844A4cMpVAuFxagqJBWA/qCTN
         M9ulZwCq5bRq1L0OTiWjWU/ZV7ut38htB4IzjYqHI4tZitYN0kt4yHBBoUsUTBXtgk
         joAUcMe25ovRw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id BFABB15C3E1F; Thu,  2 Jun 2022 00:12:49 -0400 (EDT)
Date:   Thu, 2 Jun 2022 00:12:49 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Message-ID: <Ypg4wS3G42NSWWdQ@mit.edu>
References: <20220525111715.2769700-1-amir73il@gmail.com>
 <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
 <20220527090838.GD3923443@dread.disaster.area>
 <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
 <YpDw3uVFB7LjPquX@bombadil.infradead.org>
 <20220527234202.GF3923443@dread.disaster.area>
 <CAOQ4uxgYoK=mE=Fpt8BizgHxXmgajCk=t2k6nzHb2mM=C-HvAg@mail.gmail.com>
 <20220601043100.GD227878@dread.disaster.area>
 <CAOQ4uxgVTFjWrkpOMOTJ+dKu-YiwPi3dazrePzTzd-g6Tx1JQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgVTFjWrkpOMOTJ+dKu-YiwPi3dazrePzTzd-g6Tx1JQA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 01, 2022 at 10:10:11AM +0300, Amir Goldstein wrote:
> At a very high level, I would very much like the authors of patches
> and cover letters to consider the people working on backports
> when they are describing their work.
> 
> There are many people working on backports on every major
> company/distro so I think I am not alone in this request.

So while there are people on my time that are working on backports,
and need to support a variety of kernels for diffeernt varieties of
production, I'm also an upstream maintainer so I see both sides of the
issue.

Yes, there are a lot of people who are working on backports.  But at
the same time, many backport efforts are being done by companies that
have a profit motive for supporting these production/product kernels,
and so it is often easier to get funding, in the form of head count
allocations, for supporting these production/product kernels, than it
is to get funding to support upstream kernel work, from a comparative
point of view.  Take a look at how many kernel engineers at Red Hat,
SuSE, etc., work on supporting their revenue product, versus those who
work on the upstream kernel.

There is a reason why historically, we've optimized for the upstream
maintainers, and not for the product kernels.  After all, companies
are getting paid $$$ for the product kernels.  If companies funded a
more head count to work on making life easier for stable backports,
that would be great.  But otherwise, requests like this end up coming
as effective unfunded mandates on upstream developers' time.

(And it's not stable kernel backports; it's also Syzbot reports,
Luis's failures found by using loop devices, etc.  If I had an
infinite amount of time, or if I have personal time on weekends where
I'm looking for something extra to do for fun, great.  But otherwise,
someone has to fund these efforts, or it's just going to make upstream
developers get irritated at worst, and not pay a lot of attention to
these requests at best.)

The reality is that if a backport is associated with a revenue
product, it's much easier to justify getting headcount when it comes
time to fighting the company budget headcount wargames, and I've seen
this at many different companies.  It's just the way of the world.

> I was thinking later that there is another point of failure in the
> backport process that is demonstrated in this incident -
> An elephant in the room even -
> We have no *standard* way to mark a patch as a bug fix,
> so everyone is using their own scripts and regex magic.
> 
> Fixes: is a standard that works, but it does not apply in many
> cases, for example:
> 
> 1. Zero day (some mark those as Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2"))
> 2. Hard work to figure out the fix commit
> 3. Discourage AUTOSEL

For security fixes, just marking a bug as fixing a security bug, even
if you try to obfuscate the Fixes tag, is often enough to tip off a
potential attacker.   So I would consider:

    Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2"))

to Not Be A Solution for security related patches.  The real fix here
is to put the commit id in the CVE, and to have kernel security teams
monitoring the CVE feeds looking for bugs that need to be remediated
post haste.  If you sell to the US Federal government, FedRAMP RA-5d
has some interesting mitigation timeline requirements depending on the
CVE Security Score.  And for people who are getting paid to sell into
that particular set of customers, they presumably have built into
their pricing model the cost of having a security team do that work.

Given the tight requirements for mitigating CVE's with a CVESS > 7.0,
you probably can't afford to wait for a LTS kernel to get those
patches into a revenue product (especially once you include time to QA
the updated kernel), so it should hopefully be not that hard to find a
product security team willing to identify commits that need to be
backported into the LTS Stable kernel to address security issues.
Espceially for high severity CVE's, they won't need to worry about
unduly giving their competitors in that market segment a free ride.  :-)


The hard work to figure out the fix commit is a real one, and this is
an example of where the interests of upstream and people who want to
do backports come into partial conflict.  The more we do code cleanup,
refactoring, etc., to reduce technical debt --- something which is of
great interest to upstream developers --- the harder it is to
idetntify the fixes tag, and the harder it is to backport to bug and
security fixes after the tech debt reduction commit has gone in.  So
someone who only cares about backports into product kernels, to the
exclusion of all else, would want to discourage tech debt reudction
commits.  Except they know that won't fly, and they would be flamed to
a crisp if they try.  :-)

I suppose one workaround is if an upstream developer is too tired or
too harried to figure out the correct value of a fixes tag, one cheesy
way around it would be to use:

    Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2"))

to basically mean, this fixes a bug, but I'm not sure where it is, and
it's long enough ago that maybe it's better if we ask the backport
folks to figure out the dependency if the patch doesn't apply cleanly
as to whether or not they need to do the code archeology to figure out
if it applies to an ancient kernel like 4.19 or 5.10, because again,
the product backport folks are likely to outnumber the upstream
developers, and the product backport folks are linked to revenue
streams.

So I would argue that maybe a more sustainable approach is to find a
way for the product backport folks to work together to take load off
of the upstream developers.  I'm sure there will be times when there
are some easy things that upstream folks can do to make things better,
but trying to move all or most of the burden onto the upstream
developers is as much of an unfunded mandate as Syzbot is.  :-/

	      	      	    	     	     - Ted
