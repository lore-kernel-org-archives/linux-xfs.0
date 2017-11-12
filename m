Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59412 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbdKLT57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Nov 2017 14:57:59 -0500
Date: Sun, 12 Nov 2017 20:57:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/7] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
In-Reply-To: <1510516474.10883.59.camel@perches.com>
Message-ID: <alpine.DEB.2.20.1711122057130.1993@nanos>
References: <20171112191821.240484206@linutronix.de>  <20171112192142.525567667@linutronix.de> <1510516474.10883.59.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

On Sun, 12 Nov 2017, Joe Perches wrote:

> On Sun, 2017-11-12 at 20:18 +0100, Thomas Gleixner wrote:
> > Add a file to the Documentation directory to describe how file licenses
> > should be described in all kernel files, using the SPDX identifier, as well
> > as where all licenses should be in the kernel source tree for people to
> > refer to (LICENSES/).
> > 
> > Thanks to Kate, Philippe and Greg for review and editing!
> p[
> > --- /dev/null
> > +++ b/Documentation/license-rules.rst
> []
> > +The common way of expressing the license of a source file is to add the
> > +matching boiler plate text into the top comment of the file.  Due to
> > +formatting, typos etc.  These "boiler plates" are hard to validate for
> > +tools, which are used in the context of license compliance.
> 
> There is bad sentence construction here and it is a
> little difficult to parse what is intended.
> 
> "These" should not be capitalized.

Indeed.

> This SPDX info should also be place in the Documentation/process
> content somewhere.

Works for me.

Thanks,

	tglx
