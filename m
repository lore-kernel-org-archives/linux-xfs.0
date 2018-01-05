Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56642 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbeAESz6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jan 2018 13:55:58 -0500
Date: Fri, 5 Jan 2018 18:55:44 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [V4, 01/11] Documentation: Add license-rules.rst to describe how
 to properly identify file licenses
Message-ID: <20180105185544.GD17719@n2100.armlinux.org.uk>
References: <alpine.DEB.2.20.1711171057240.1709@nanos>
 <20180105130526.GA31648@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180105130526.GA31648@piout.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Fri, Jan 05, 2018 at 02:05:26PM +0100, Alexandre Belloni wrote:
> Hi,
> 
> I'm definitively late to the party but...
> 
> On 17/11/2017 at 11:00:33 +0100, Thomas Gleixner wrote:
> > +2. Style:
> > +
> > +   The SPDX license identifier is added in form of a comment.  The comment
> > +   style depends on the file type::
> > +
> > +      C source:   // SPDX-License-Identifier: <SPDX License Expression>
> > +      C header:   /* SPDX-License-Identifier: <SPDX License Expression> */
> > +      ASM:        /* SPDX-License-Identifier: <SPDX License Expression> */
> > +      scripts:    # SPDX-License-Identifier: <SPDX License Expression>
> > +      .rst:	  .. SPDX-License-Identifier: <SPDX License Expression>
> > +      .dts{i}:	  // SPDX-License-Identifier: <SPDX License Expression>
> 
> dtc doesn't handle // comments. This works in the kernel tree because
> dts files are preprocessed by CPP. But this doesn't work when using dtc
> directly (most likely when compiling DT overlays). So, the choice is
> between making dtc handle // comments or changing the documentation.

Does all the CPP macros that we use for things like GPIOs work when you
avoid CPP?

What I'm saying is that preprocessing the DTS in the kernel tree with
CPP appears to be a necessity, and doing so will deal with the C++
comments.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
