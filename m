Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52968 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbeAEXFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jan 2018 18:05:22 -0500
Date: Sat, 6 Jan 2018 00:05:20 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [V4, 01/11] Documentation: Add license-rules.rst to describe how
 to properly identify file licenses
Message-ID: <20180105230520.GA5545@piout.net>
References: <alpine.DEB.2.20.1711171057240.1709@nanos>
 <20180105130526.GA31648@piout.net>
 <7769bd49-146b-ea8c-3b2c-b5987653a665@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7769bd49-146b-ea8c-3b2c-b5987653a665@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Frank Rowand <frowand.list@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On 05/01/2018 at 14:48:04 -0800, Frank Rowand wrote:
> On 01/05/18 05:05, Alexandre Belloni wrote:
> > Hi,
> > 
> > I'm definitively late to the party but...
> > 
> > On 17/11/2017 at 11:00:33 +0100, Thomas Gleixner wrote:
> >> +2. Style:
> >> +
> >> +   The SPDX license identifier is added in form of a comment.  The comment
> >> +   style depends on the file type::
> >> +
> >> +      C source:   // SPDX-License-Identifier: <SPDX License Expression>
> >> +      C header:   /* SPDX-License-Identifier: <SPDX License Expression> */
> >> +      ASM:        /* SPDX-License-Identifier: <SPDX License Expression> */
> >> +      scripts:    # SPDX-License-Identifier: <SPDX License Expression>
> >> +      .rst:	  .. SPDX-License-Identifier: <SPDX License Expression>
> >> +      .dts{i}:	  // SPDX-License-Identifier: <SPDX License Expression>
> > 
> > dtc doesn't handle // comments. This works in the kernel tree because
> 
> dtc does handle // comments.
> 

Hum, correct. I got a report saying it didn't and when I only checked
the COMMENT line of dtc-lexer.l. For whatever reason, I missed the
following line handling c++ comments.

I'll get back to the original report, trying to find why it was not
compiling.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
