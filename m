Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246A9C83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 00:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1A520737
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 00:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgD2AUv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 20:20:51 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:34606 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726181AbgD2AUv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 20:20:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 4513B180A7348;
        Wed, 29 Apr 2020 00:20:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: wire97_5e685622e423d
X-Filterd-Recvd-Size: 2113
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Wed, 29 Apr 2020 00:20:48 +0000 (UTC)
Message-ID: <08eafcec5b92626e1ad7906b948419e7300e7684.camel@perches.com>
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
Date:   Tue, 28 Apr 2020 17:20:47 -0700
In-Reply-To: <CAHk-=wi2bdXuYhC9bd9FShtcf_u-6RUb3Qr_aXq3XtbCxR5NGQ@mail.gmail.com>
References: <20200425133504.GA11354@nishad> <20200427155617.GY6749@magnolia>
         <20200427172959.GB3936841@kroah.com>
         <515362d10c06567f35f0d5b7c3f2e121769fb04b.camel@perches.com>
         <20200427174611.GA4035548@kroah.com>
         <791a97d5d4dfd11af533a0bbd6ae27d1a2d479ee.camel@perches.com>
         <20200427183629.GA20158@kroah.com>
         <16b209d0b0c8034db62f8d4d0a260a00f0aa5d5e.camel@perches.com>
         <CAHk-=wgN=Ox112_O=GQ-kwMxYduix9gZFsr1GXXJWLpDpNDm5g@mail.gmail.com>
         <fdcc8aa5a506ba9c6a3e6e68a7147161424985bf.camel@perches.com>
         <CAHk-=wi2bdXuYhC9bd9FShtcf_u-6RUb3Qr_aXq3XtbCxR5NGQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2020-04-27 at 13:46 -0700, Linus Torvalds wrote:
> There is simply no point in EVER changing "GPL-2.0" into
> "GPL-2.0-only" etc, unless the thing is then touched for some other
> reason (which it may never be).

Which is _exactly_ what is happening here.

But the reason _not_ to touch it here is there would
be a difference between the SPDX license text in the
.c and .h files in the directory.


