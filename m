Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D10AEC3A5A6
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CC56206BF
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="jKssSFAh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oxAqFmge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbfH0PYW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 11:24:22 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:49979 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726170AbfH0PYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 11:24:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6D0B02A17;
        Tue, 27 Aug 2019 11:24:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 27 Aug 2019 11:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=KfMc99lGXqZC8ZhCq4Ipq67ahLK
        fpmEK9PqV8bDoWH0=; b=jKssSFAhHgsCfh4sCRjIf3fjGPekH6QhVMAKp1g4mGT
        8kMRrpTNnsM3MgnfJQj3gJHA1Nd6B8HL3xVOJJIP7Yglg6tbpoMdnnvr6zIuuovO
        qrHp+SSiPChE6EqZVUaHsqwm7dsdtKRxsIif9m06SzZcUiSZLaspYlXqixhmltFG
        LRBfr50fevEni7z5yAbuBQ5ev5flAzGGsXa+AITVUp88y4lYMLE3KE8LYSr50llK
        +SGiGtg2LcgQgeEAgXupQCXIBiglA24hEqQVySqzHpjI4HK+9f0bAJTFP8zZ/6Gj
        f4DoTNIO8yZBFWuuJNPCKta6VJ5NsY6qrP/dddYGrAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KfMc99
        lGXqZC8ZhCq4Ipq67ahLKfpmEK9PqV8bDoWH0=; b=oxAqFmgelSVYiJflbCH/n2
        Wd9VPEFoT/4moKfGM68oooyzZNHBPEAD4BMfffJ1+31sxF9s7WZLcb3RkJA67Wj+
        ZSYBAkqKmCwIHehkr+kGqFjBBefCjhJUbdZnBD0OE7H31XQl3noMmIZK37CtvPcm
        vKNrg+PE5f0G1txp3Qr7OeFjRK0A/BXIcZKnTwn1JBn8Umb5VCIcP1BZW0XS1mv3
        SIL9zw8F/tiHDYY0Odd8qRdIXwSX3t0rVNZpHH11BEdi++SoED04pu8Qdp+OZhTV
        udkRqcPB+wpkYb5lLt8xO7lsbj11lexF4g7nkuUgtvs7fGy0vvGu93djbYJIrX2w
        ==
X-ME-Sender: <xms:I0tlXViEW1AKFPrkguo3mYSnOK_dGNC2ei9GreBaCyVve_d213me4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehkedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:I0tlXUe0d9pSxeENdzvdAHLfdDuizcnbLd6C65QuSxGFxtMt5sf32g>
    <xmx:I0tlXZDQYhyyqYbhk3iGcvbvZa1vQziuRX2ompE25t_tsoEMXceUTw>
    <xmx:I0tlXQ8HJZQiX6duEngT_VLt-XKfPJ5RbUJ4eU_BV-f4SJzq35EvjQ>
    <xmx:JEtlXSLBy4t_2OoAAlRPPGK8BUF6qHooDqk9QY4JRpFSHvW0kbpN3A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9AFA380061;
        Tue, 27 Aug 2019 11:24:18 -0400 (EDT)
Date:   Tue, 27 Aug 2019 17:24:16 +0200
From:   Greg KH <greg@kroah.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Eryu Guan <guaneryu@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH v2] generic: test for failure to unlock inode after chgrp
 fails with EDQUOT
Message-ID: <20190827152416.GA534@kroah.com>
References: <20190827041816.GB1037528@magnolia>
 <alpine.DEB.2.21.1908270811030.1939@nanos.tec.linutronix.de>
 <20190827150451.GY1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827150451.GY1037350@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 08:04:51AM -0700, Darrick J. Wong wrote:
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
> 
> Is that even going to stay that way?  I thought I heard that Greg was
> working on phasing out the "2.0+" tags since SPDX deprecated that?
> 
> I think xfsprogs and xfstests just follow whatever the kernel does, but
> AFAICT this whole initiative /continues/ to communicate poorly with the
> maintainers about (1) how this is supposed to benefit us and (2) what we
> are supposed to do to maintain all of it.
> 
> Do we have to get lawyers involved to roll to a new SPDX version?  Will
> LF do that for (at least) the projects hosted on kernel.org?  Should we
> just do it and hope for the best since IANAFL?  I know how to review
> code.  I don't know how to review licensing and all the tiny
> implications that go along with things like this.  I don't even feel
> confident that the two identifiers above are exactly the same, because
> all I know is that I read it on a webpage somewhere.
> 
> I for one still have heard abso-f*cking-lutely nothing about what is
> this SPDX change other than Greg shoving treewide changes in the kernel.
> That sufficed to get the mechanical work done (at the cost of a lot of
> frustration for Greg) but this doesn't help me sustain our community.

It takes a lot more to get me frustrated :)

And I am _VERY_ supprised to hear you have not heard anything about this
given that Oracle has some lawyers who have been very involved in the
SPDX process.  One would have thought they had discussed it with their
developers.  They sure seem to come to me with questions that start,
"Our developers had a question about...", so I know they must talk to
someone...

> Guidance needed.  Apologies all around if this rant is misdirected, but
> I have no idea who (if anyone) is maintaining SPDX tags.  There's no
> entry for LICENSES/ in MAINTAINERS, which is where I looked first.

Thomas seems to have answered all of your questions, hopefully.

And yeah, Thomas and I should probably be listed in MAINTAINERS for
LICENSES as we somehow got tagged for all of this work.

thanks,

greg k-h
