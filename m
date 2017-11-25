Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:41659 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdKYUab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 15:30:31 -0500
MIME-Version: 1.0
In-Reply-To: <20171125175353.467b6e49@vento.lan>
References: <20171116184358.398030394@linutronix.de> <alpine.DEB.2.20.1711171057240.1709@nanos>
 <20171117150639.0e706421@vento.lan> <alpine.DEB.2.20.1711171850330.2186@nanos>
 <20171117183946.GA28533@lst.de> <alpine.DEB.2.20.1711221207460.1751@nanos>
 <20171122095117.49c558a4@vento.lan> <20171122134804.GA30796@kroah.com>
 <20171125190447.GB5114@amd> <CA+55aFyGDE1tB-5ms6yHFUujJ815FoQQE2SceXDybiT8xcvgpQ@mail.gmail.com>
 <20171125191726.GA6886@amd> <CA+55aFzPUi6En9tg+kZnDHQd3yuz5n99rDkk2tjAA=w4-K3uBg@mail.gmail.com>
 <20171125175353.467b6e49@vento.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Nov 2017 10:30:29 -1000
Message-ID: <CA+55aFzP+b2Vt=+ZZbkpuYi87gO+pZXVxKnySkiedn+SYN2CCw@mail.gmail.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Sat, Nov 25, 2017 at 9:53 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
>
> Let me see if I got it straight. At drivers/media/common/siano/smsir.c,
> we have, currently:

.. snip snip ..

> With is completely out of standard. I'd like to add an SPDX tag there
> and, while doing that, adjust the comments.
>
> So, if I understand well, your preference would be to make it like:
>
>         // SPDX-License-Identifier: GPL-2.0+
>         //
>         // Siano Mobile Silicon, Inc.
>         // MDTV receiver kernel modules.
>         // Copyright (C) 2006-2009, Uri Shkolnik
>         //
>         // Copyright (c) 2010 - Mauro Carvalho Chehab
>         //      - Ported the driver to use rc-core
>         //      - IR raw event decoding is now done at rc-core
>         //      - Code almost re-written
>
> Right?

Exactly.

I would also like to make clear that this is not a "let's do this in
bulk and automatically". But let's just say that if the "//" for the
SPDX line ends up encouraging people towards this kind of  format over
the long run, I think that would be lovely.

The /* */ format really  ends up encouraging some odd formatting. Your
example with the whole "box of stars" is not standard kernel format,
but it's surprisingly common. And you find various lopsided versions
of the multi-line thing, and even when you do *single* lines, the /*
*/ thing ends up being something where people try to align the closing
"*/" part.

Honestly now, how many people have seen things like

    struct somestruct {
        int member;    /* For Xyz         */
        int other;     /* For Abracadabra */
        ...

where people try to align that ending thing?

Or tell me you haven't seen block comments where  people do

    /*  This is a multi-line
     * thing that tries to be dense */

and other odd formats that are just ugly and unbalanced.

That's why I think "//" ends up being better in the end. And yes, I've
changed my mind over time. Had you asked me ten or fifteen years ago,
I probably would have said that "//" is not real C.

               Linus
