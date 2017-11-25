Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:40246 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdKYTMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 14:12:00 -0500
MIME-Version: 1.0
In-Reply-To: <20171125190447.GB5114@amd>
References: <20171116183306.103584007@linutronix.de> <20171116184358.398030394@linutronix.de>
 <alpine.DEB.2.20.1711171057240.1709@nanos> <20171117150639.0e706421@vento.lan>
 <alpine.DEB.2.20.1711171850330.2186@nanos> <20171117183946.GA28533@lst.de>
 <alpine.DEB.2.20.1711221207460.1751@nanos> <20171122095117.49c558a4@vento.lan>
 <20171122134804.GA30796@kroah.com> <20171125190447.GB5114@amd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Nov 2017 09:11:58 -1000
Message-ID: <CA+55aFyGDE1tB-5ms6yHFUujJ815FoQQE2SceXDybiT8xcvgpQ@mail.gmail.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@s-opensource.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Sat, Nov 25, 2017 at 9:04 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> That does not sound like he was deciding between /* */ and //. And
> actually this was in context of files with no existing license. You
> made the ugly patches. Stop hiding behind Linus.

No, Linus happily stands up for //.

I really don't like one-liner /* */ comments. Let's face it, // was
the _one_ thing C++ got right, among all the horrible bad decisions.

I think we should just start moving to // in general, but only when
adding new ones (ie I don't want to see any automatic conversion
patches).

And it's _particularly_ true for the whole case where we mix
one-liners like the SPDX line with block comments. That's where /* */
really sucks.

           Linus
