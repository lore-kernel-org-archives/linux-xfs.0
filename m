Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:48848 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965526AbdKQWit (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 17:38:49 -0500
Date: Fri, 17 Nov 2017 15:38:47 -0700
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [patch V3 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171117153847.251e578d@lwn.net>
In-Reply-To: <alpine.DEB.2.20.1711171040290.1709@nanos>
References: <20171116183306.103584007@linutronix.de>
        <20171116184358.398030394@linutronix.de>
        <20171116135730.265a8323@lwn.net>
        <alpine.DEB.2.20.1711171040290.1709@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Fri, 17 Nov 2017 10:48:57 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> > > +The following describes the license of the Linux kernel source code
> > > +(GPLv2), how to properly mark the license of individual files in the source
> > > +tree, as well as links to the full license text.
> > > +
> > > +.. toctree::
> > > +   :maxdepth: 2
> > > +
> > > +   process/license-rules.rst
> > > +  
> > 
> > I'll confess that I'm not convinced that information on license identifiers
> > is the very first thing readers should encounter when entering the kernel's
> > documentation.  But I'll not quibble about it for now, we can always move
> > it later :)  
> 
> Any suggestions for a better place?

I'd put it into Documentation/process/index.rst.  That is where we have
put the rest of that kind of information - stuff that people who want to
do kernel development need to know.

Other than that quibble, V4 looks good to me; toss in a

	Reviewed-by: Jonathan Corbet <corbet@lwn.net>

if you like.

Thanks,

jon
