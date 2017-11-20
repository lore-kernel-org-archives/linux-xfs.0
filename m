Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:57405 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbdKTJmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 04:42:49 -0500
Date: Mon, 20 Nov 2017 10:42:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch V2 02/11] LICENSES: Add the GPL 2.0 license
In-Reply-To: <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1711201030470.1734@nanos>
References: <20171116183306.103584007@linutronix.de> <20171116184358.475929943@linutronix.de> <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Charlemagne Lasse <charlemagnelasse@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Sat, 18 Nov 2017, Charlemagne Lasse wrote:
> 2017-11-16 19:33 GMT+01:00 Thomas Gleixner <tglx@linutronix.de>:
> > Add the full text of the GPL 2.0 license to the kernel tree.  It was
> > copied directly from:
> >
> >    https://spdx.org/licenses/GPL-2.0.html#licenseText
> >
> > Add the required tags for reference and tooling.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> NACKed-by: Charlemagne Lasse <charlemagnelasse@gmail.com>
> 
> This is neither the GPL-2.0 from https://www.gnu.org/licenses/gpl-2.0.txt
> (which you should have used) or
> https://spdx.org/licenses/GPL-2.0.html#licenseText
> 
> Please download the correct ASCII version from gnu.org and add your SPDX
> info in front of it. But I have also added detailed info about
> non-whitespace changes in your patch.

Indeed. I messed that up when I noticed that the license from the SPDX site
is indeed different from the COPYING file in a few minor aspects.

I started to rumage around to find out why and found the matching one on

  https://opensource.org/licenses/GPL-2.0

which is linked to from the SPDX page. I downloaded that version to check
the differences. The opensource page has the original version of the GPLv2
and not the one which got modified by FSF later on without changing the
version number.

I then decided to copy the text from COPYING, which is the right thing to
do as Jonas pointed, got dragged into dealing with a regression and forgot
about it. Neither did I update the changelog.

Thanks for spotting it!

I'll send out a revised version later.

Thanks,

	tglx


