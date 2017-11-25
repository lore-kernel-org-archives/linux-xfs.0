Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:39081 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbdKYThr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 14:37:47 -0500
MIME-Version: 1.0
In-Reply-To: <20171125191726.GA6886@amd>
References: <20171116184358.398030394@linutronix.de> <alpine.DEB.2.20.1711171057240.1709@nanos>
 <20171117150639.0e706421@vento.lan> <alpine.DEB.2.20.1711171850330.2186@nanos>
 <20171117183946.GA28533@lst.de> <alpine.DEB.2.20.1711221207460.1751@nanos>
 <20171122095117.49c558a4@vento.lan> <20171122134804.GA30796@kroah.com>
 <20171125190447.GB5114@amd> <CA+55aFyGDE1tB-5ms6yHFUujJ815FoQQE2SceXDybiT8xcvgpQ@mail.gmail.com>
 <20171125191726.GA6886@amd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Nov 2017 09:30:46 -1000
Message-ID: <CA+55aFzPUi6En9tg+kZnDHQd3yuz5n99rDkk2tjAA=w4-K3uBg@mail.gmail.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@s-opensource.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Sat, Nov 25, 2017 at 9:17 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> There's logical place in the comment, and it should look like this:
>
> /*
>  * Driver for SMSC USB3503 USB 2.0 hub controller driver
>  *
>  * SPDX-License-Identifier:     GPL-2.0+
>  * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
>  */

And this is *exactly* what I don't want o see, because now the SPDX
placement is basically entirely random, and we'll get stupid conflicts
that are must nastier, and people will get it wrong and we'll end up
with two lines etc etc headaches.

Yes, the single line at the top _also_ causes conflicts, but they are
really easy to resolve exactly because there is absolutely no
ambiguity about what the resolution is, and there is no question that
there could be two different SPDX lines in the file.

The "//" format is ambiguous and simple, and works well for the first line.

And if we have the long-term plan to move over to // (which I really
hope for), it's also the cleanest of them all.

Btw, your exact line is also an example of another thing I *never*
want to see: indentation of the identifier. I'm not sure what was
going on there, and what you tried to line up, but it has already
happened once in include/dt-bindings/clock/boston-clock.h, and I
suspect it was *exactly* because it was in a /* block comment and
people tried to make it match that comment.

THAT IS WRONG.

We already had the damn "random whitespace fixes" crap with the
existing license mess. Let's learn from our mistakes, AND NOT DO IT
AGAIN!

So I want the format to be _fixed_. On the very first line that the
file format allows, with no whitespace garbage, and no "let's try to
make it pretty and match the rest".

Seriously.

You should be able to do

    git grep -h SPDX-License-Identifier: | sort | uniq -c

and not get fifty different versions just because of stupid "let's
match things around it" crap.

If you want to match something, switch to using '//' at he top
copyright comment, and remove the garbage boilerplate.

              Linus
