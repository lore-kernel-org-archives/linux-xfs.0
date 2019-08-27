Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA45FC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB3F42070B
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfH0PTk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 11:19:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44131 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfH0PTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 11:19:40 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i2dFo-0000uH-Ac; Tue, 27 Aug 2019 17:19:28 +0200
Date:   Tue, 27 Aug 2019 17:19:27 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
cc:     Eryu Guan <guaneryu@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        fstests <fstests@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] generic: test for failure to unlock inode after chgrp
 fails with EDQUOT
In-Reply-To: <20190827150451.GY1037350@magnolia>
Message-ID: <alpine.DEB.2.21.1908271707400.1939@nanos.tec.linutronix.de>
References: <20190827041816.GB1037528@magnolia> <alpine.DEB.2.21.1908270811030.1939@nanos.tec.linutronix.de> <20190827150451.GY1037350@magnolia>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick,

On Tue, 27 Aug 2019, Darrick J. Wong wrote:

> On Tue, Aug 27, 2019 at 08:13:19AM +0200, Thomas Gleixner wrote:
> > On Mon, 26 Aug 2019, Darrick J. Wong wrote:
> > > +++ b/tests/generic/719
> > > @@ -0,0 +1,59 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0-or-newer
> > 
> > Please run scripts/spdxcheck.py on that file and consult the licensing
> > documentation.
> 
> -or-later, sorry.
> 
> So .... now that everyone who wanted these SPDX identifiers have spread
> "GPL-2.0+" around the kernel and related projects (xfsprogs, xfstests)
> just in time for SPDX 3.0 to deprecate the "+" syntax, what are we
> supposed to do?  Another treewide change to fiddle with SPDX syntax?
> Can we just put:
> 
> Valid-License-Identifier: GPL-2.0+
> Valid-License-Identifier: GPL-2.0-or-later
> 
> in the LICENSES/GPL-2.0 file like the kernel does?

The kernel is not going to change that because we have started with this
before the s/+/-or-later/ happened. Tools need to read both.
 
> Is that even going to stay that way?  I thought I heard that Greg was
> working on phasing out the "2.0+" tags since SPDX deprecated that?

For new stuff we should use -or-later methinks.

> I think xfsprogs and xfstests just follow whatever the kernel does, but
> AFAICT this whole initiative /continues/ to communicate poorly with the
> maintainers about (1) how this is supposed to benefit us and (2) what we
> are supposed to do to maintain all of it.

We wrote lengthy documentation and a long explanation on LKML. So what's
missing?

Maintaining it is easy. All new files need a valid SPDX identifier which is
documented in one of the licenses in the LICENSES directory. Preferrably
the SPDX identifier comes without all that boiler plate nonsense which got
copied and pasted, fatfingered and broken in the past.
 
> Do we have to get lawyers involved to roll to a new SPDX version?  Will
> LF do that for (at least) the projects hosted on kernel.org?  Should we
> just do it and hope for the best since IANAFL?  I know how to review
> code.  I don't know how to review licensing and all the tiny
> implications that go along with things like this.  I don't even feel
> confident that the two identifiers above are exactly the same, because
> all I know is that I read it on a webpage somewhere.

We have layers helping with that. 
 
> I for one still have heard abso-f*cking-lutely nothing about what is
> this SPDX change other than Greg shoving treewide changes in the kernel.
> That sufficed to get the mechanical work done (at the cost of a lot of
> frustration for Greg) but this doesn't help me sustain our community.
> 
> Guidance needed.  Apologies all around if this rant is misdirected, but
> I have no idea who (if anyone) is maintaining SPDX tags.  There's no
> entry for LICENSES/ in MAINTAINERS, which is where I looked first.

The SPDX identifiers are maintained by the SPDX group which is independent
of us. We use them and we document how to use them proper so tooling can do
proper license identification.

Yeah, we should add a MAINTAINERS entry for LICENSES. Greg and myself are
going to be volunteered I fear.

Thanks,

	tglx
