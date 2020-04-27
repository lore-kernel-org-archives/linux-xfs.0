Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19ACC4CECD
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 20:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99FAA2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 20:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgD0UjC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:39:02 -0400
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:60232 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgD0UjC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 16:39:02 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id E700318224D65;
        Mon, 27 Apr 2020 20:39:00 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: boat14_88b2a286d5402
X-Filterd-Recvd-Size: 2774
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Apr 2020 20:38:59 +0000 (UTC)
Message-ID: <fdcc8aa5a506ba9c6a3e6e68a7147161424985bf.camel@perches.com>
Subject: Re: [PATCH] xfs: Use the correct style for SPDX License Identifier
From:   Joe Perches <joe@perches.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Mon, 27 Apr 2020 13:38:58 -0700
In-Reply-To: <CAHk-=wgN=Ox112_O=GQ-kwMxYduix9gZFsr1GXXJWLpDpNDm5g@mail.gmail.com>
References: <20200425133504.GA11354@nishad> <20200427155617.GY6749@magnolia>
         <20200427172959.GB3936841@kroah.com>
         <515362d10c06567f35f0d5b7c3f2e121769fb04b.camel@perches.com>
         <20200427174611.GA4035548@kroah.com>
         <791a97d5d4dfd11af533a0bbd6ae27d1a2d479ee.camel@perches.com>
         <20200427183629.GA20158@kroah.com>
         <16b209d0b0c8034db62f8d4d0a260a00f0aa5d5e.camel@perches.com>
         <CAHk-=wgN=Ox112_O=GQ-kwMxYduix9gZFsr1GXXJWLpDpNDm5g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2020-04-27 at 12:40 -0700, Linus Torvalds wrote:
> On Mon, Apr 27, 2020 at 11:59 AM Joe Perches <joe@perches.com> wrote:
> > There's no real reason not to prefer the latest versions
> > over the deprecated ones.
> 
> Joe, your pedantic approach is really hard to work with. Please work on it.

License text especially _should_ be pedantic and precise.

> The fact is, there *is * a reason to avoid the pedantic "change to new
> version" - pointless churn.

Have you *looked* at this proposed change?

It just changes // SPDX comments to /* */ in .h files.

It's generically useless churn as using the // style in .h files
was only for old and now unsupported compiler versions.

> We have a lot of the original style spdx markers, because those are
> what we started with. And changing them is pointless.

You and I (and apparently the SPDX group too as they deprecated it)
disagree a bit here.

> I know you love your scripts to change things around, but to everybody
> else it tends to be just extra work and noise.

Piecemeal changes aren't great.

Scripted changes can be very useful and I believe they
are significantly underutilized in this source tree.

cheers, Joe

