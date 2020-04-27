Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E55C4CECC
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6500214AF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgD0S7U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 14:59:20 -0400
Received: from smtprelay0161.hostedemail.com ([216.40.44.161]:59244 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726260AbgD0S7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 14:59:20 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 437DD182CF668;
        Mon, 27 Apr 2020 18:59:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: price03_8b5bd9a9cf130
X-Filterd-Recvd-Size: 4152
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Apr 2020 18:59:17 +0000 (UTC)
Message-ID: <16b209d0b0c8034db62f8d4d0a260a00f0aa5d5e.camel@perches.com>
Subject: Re: [PATCH] xfs: Use the correct style for SPDX License Identifier
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 27 Apr 2020 11:59:16 -0700
In-Reply-To: <20200427183629.GA20158@kroah.com>
References: <20200425133504.GA11354@nishad> <20200427155617.GY6749@magnolia>
         <20200427172959.GB3936841@kroah.com>
         <515362d10c06567f35f0d5b7c3f2e121769fb04b.camel@perches.com>
         <20200427174611.GA4035548@kroah.com>
         <791a97d5d4dfd11af533a0bbd6ae27d1a2d479ee.camel@perches.com>
         <20200427183629.GA20158@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2020-04-27 at 20:36 +0200, Greg Kroah-Hartman wrote:
> On Mon, Apr 27, 2020 at 11:01:38AM -0700, Joe Perches wrote:
> > On Mon, 2020-04-27 at 19:46 +0200, Greg Kroah-Hartman wrote:
> > > On Mon, Apr 27, 2020 at 10:41:58AM -0700, Joe Perches wrote:
> > > > On Mon, 2020-04-27 at 19:29 +0200, Greg Kroah-Hartman wrote:
[]
> > > > > I thought we were supposed to use 'GPL-2.0-or-newer' because 'GPL-2.0+'
> > > > > > is deprecated in some newer version of the SPDX standard?
> > > > > > 
> > > > > > <shrug>
> > > > > 
> > > > > The kernel follows the "older" SPDX standard, but will accept either,
> > > > > it's up to the author.  It is all documented in LICENSES/ if people
> > > > > really want to make sure.
> > > > 
> > > > I think the kernel should prefer the "newer" SPDX standard
> > > > for any/all changes to these lines.
> > > > ---
> > > >  LICENSES/preferred/GPL-2.0 | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/LICENSES/preferred/GPL-2.0 b/LICENSES/preferred/GPL-2.0
> > > > index ff0812..c50f93 100644
> > > > --- a/LICENSES/preferred/GPL-2.0
> > > > +++ b/LICENSES/preferred/GPL-2.0
> > > > @@ -8,13 +8,13 @@ Usage-Guide:
> > > >    tag/value pairs into a comment according to the placement
> > > >    guidelines in the licensing rules documentation.
> > > >    For 'GNU General Public License (GPL) version 2 only' use:
> > > > -    SPDX-License-Identifier: GPL-2.0
> > > > -  or
> > > >      SPDX-License-Identifier: GPL-2.0-only
> > > > +  or the deprecated alternative
> > > > +    SPDX-License-Identifier: GPL-2.0
> > > >    For 'GNU General Public License (GPL) version 2 or any later version' use:
> > > > -    SPDX-License-Identifier: GPL-2.0+
> > > > -  or
> > > >      SPDX-License-Identifier: GPL-2.0-or-later
> > > > +  or the deprecated alternative
> > > > +    SPDX-License-Identifier: GPL-2.0+
> > > >  License-Text:
> > > 
> > > At the moment, I do not, as the current ones are not "depreciated" at
> > > all.
> > 
> > https://spdx.org/licenses/
> > 
> > shows the GPL-2.0 and GPL-2.0+ as deprecated.
> > 
> > https://spdx.org/licenses/GPL-2.0.html
> > https://spdx.org/licenses/GPL-2.0+.html
> > 
> 
> Again, we are not using the "new" version of the SPDX specification just
> yet.  We started out using one specific version, let's get the whole
> kernel converted first before worrying about trying to keep up with
> their newer releases please.  We still have a ways to go...

It seems you refer to yourself using the majestic plural.

There's already ~80% use of SPDX-License-Identifier and the
-only versions are already about 25% of the existing uses.

There's no real reason not to prefer the latest versions
over the deprecated ones.


