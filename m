Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50328 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdKVNsR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 08:48:17 -0500
Date: Wed, 22 Nov 2017 14:48:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171122134804.GA30796@kroah.com>
References: <20171116183306.103584007@linutronix.de>
 <20171116184358.398030394@linutronix.de>
 <alpine.DEB.2.20.1711171057240.1709@nanos>
 <20171117150639.0e706421@vento.lan>
 <alpine.DEB.2.20.1711171850330.2186@nanos>
 <20171117183946.GA28533@lst.de>
 <alpine.DEB.2.20.1711221207460.1751@nanos>
 <20171122095117.49c558a4@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171122095117.49c558a4@vento.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Wed, Nov 22, 2017 at 09:51:17AM -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 22 Nov 2017 12:12:04 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> escreveu:
> 
> > On Fri, 17 Nov 2017, Christoph Hellwig wrote:
> > > On Fri, Nov 17, 2017 at 07:11:41PM +0100, Thomas Gleixner wrote:  
> > > > Introcude a MODULE_LICENSE_SPDX macro which flags the module info storage
> > > > as 'SPDXIFY' and let the postprocessor do:  
> > > 
> > > Shouldn;t this be a FILE_LICENSE_SPDX?  I'd also much prefer that over
> > > the nasty C99 comments to start with.  And while I'm a bit behind on
> > > email I still haven't managed to find a good rationale for those to
> > > start with.
> 
> Yeah, I also find nasty to have things like this on each C file:
> 
> // SPDX-License-Identifier: GPL-2.0
> /*
>  * Copyright ...
>  * ...
>  */
> 
> Also, one may forget that headers use /**/ and end by doing the wrong
> thing, as a common practice is to just cut-and-paste the same copyright
> header on both C and H files at development time.

You break the build when you get it wrong, so you will notice it.  For
most "internal" .h files, using // is just fine.

Yes, it's "ugly", but again, that's what Linus said he wanted it to look
like, take it up with him :)

> > > So it would be good to figure this out before people start spamming
> > > the lists with all kinds of mass conversions and checkpatch fixes
> > > for licensing..  
> > 
> > I tried solving this with a macro in the first place and ran into issues:
> > 
> >    - Does not work in headers, especially not in UAPI ones
> 
> Make headers_install could replace such macros by SPDX comments when
> installing on userspace.

The big issue is when you build, putting those macros all into something
logical is a mess.  I too tried it and failed.

But feel to give it a go if you think it is possible :)

thanks,

greg k-h
