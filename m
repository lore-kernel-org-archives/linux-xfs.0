Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41205 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751630AbdKYTyH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 25 Nov 2017 14:54:07 -0500
Date: Sat, 25 Nov 2017 17:53:53 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171125175353.467b6e49@vento.lan>
In-Reply-To: <CA+55aFzPUi6En9tg+kZnDHQd3yuz5n99rDkk2tjAA=w4-K3uBg@mail.gmail.com>
References: <20171116184358.398030394@linutronix.de>
        <alpine.DEB.2.20.1711171057240.1709@nanos>
        <20171117150639.0e706421@vento.lan>
        <alpine.DEB.2.20.1711171850330.2186@nanos>
        <20171117183946.GA28533@lst.de>
        <alpine.DEB.2.20.1711221207460.1751@nanos>
        <20171122095117.49c558a4@vento.lan>
        <20171122134804.GA30796@kroah.com>
        <20171125190447.GB5114@amd>
        <CA+55aFyGDE1tB-5ms6yHFUujJ815FoQQE2SceXDybiT8xcvgpQ@mail.gmail.com>
        <20171125191726.GA6886@amd>
        <CA+55aFzPUi6En9tg+kZnDHQd3yuz5n99rDkk2tjAA=w4-K3uBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Em Sat, 25 Nov 2017 09:30:46 -1000
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Sat, Nov 25, 2017 at 9:17 AM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> > There's logical place in the comment, and it should look like this:
> >
> > /*
> >  * Driver for SMSC USB3503 USB 2.0 hub controller driver
> >  *
> >  * SPDX-License-Identifier:     GPL-2.0+
> >  * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
> >  */  
> 
> And this is *exactly* what I don't want o see, because now the SPDX
> placement is basically entirely random, and we'll get stupid conflicts
> that are must nastier, and people will get it wrong and we'll end up
> with two lines etc etc headaches.
> 
> Yes, the single line at the top _also_ causes conflicts, but they are
> really easy to resolve exactly because there is absolutely no
> ambiguity about what the resolution is, and there is no question that
> there could be two different SPDX lines in the file.
> 
> The "//" format is ambiguous and simple, and works well for the first line.
> 
> And if we have the long-term plan to move over to // (which I really
> hope for), it's also the cleanest of them all.

Let me see if I got it straight. At drivers/media/common/siano/smsir.c,
we have, currently:


	/****************************************************************

	 Siano Mobile Silicon, Inc.
	 MDTV receiver kernel modules.
	 Copyright (C) 2006-2009, Uri Shkolnik

	 Copyright (c) 2010 - Mauro Carvalho Chehab
		- Ported the driver to use rc-core
		- IR raw event decoding is now done at rc-core
		- Code almost re-written

	 This program is free software: you can redistribute it and/or modify
	 it under the terms of the GNU General Public License as published by
	 the Free Software Foundation, either version 2 of the License, or
	 (at your option) any later version.

	 This program is distributed in the hope that it will be useful,
	 but WITHOUT ANY WARRANTY; without even the implied warranty of
	 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	 GNU General Public License for more details.

	 You should have received a copy of the GNU General Public License
	 along with this program.  If not, see <http://www.gnu.org/licenses/>.

	 ****************************************************************/

With is completely out of standard. I'd like to add an SPDX tag there
and, while doing that, adjust the comments.

So, if I understand well, your preference would be to make it like:

	// SPDX-License-Identifier: GPL-2.0+
	//
	// Siano Mobile Silicon, Inc.
	// MDTV receiver kernel modules.
	// Copyright (C) 2006-2009, Uri Shkolnik
	//
	// Copyright (c) 2010 - Mauro Carvalho Chehab
	//	- Ported the driver to use rc-core
	//	- IR raw event decoding is now done at rc-core
	//	- Code almost re-written

Right?

Also, what about the header file (that, currently, has an identical header?

The way it was proposed (with /**/), it would be:

	/* SPDX-License-Identifier: GPL-2.0+ */
	/*
	 * Siano Mobile Silicon, Inc.
	 * MDTV receiver kernel modules.
	 * Copyright (C) 2006-2009, Uri Shkolnik
	 *
	 * Copyright (c) 2010 - Mauro Carvalho Chehab
	 *	- Ported the driver to use rc-core
	 *	- IR raw event decoding is now done at rc-core
	 *	- Code almost re-written
	 */

With, IMHO, looks really ugly.

Thanks,
Mauro
