Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44231 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752205AbdKVLv0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Nov 2017 06:51:26 -0500
Date: Wed, 22 Nov 2017 09:51:17 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171122095117.49c558a4@vento.lan>
In-Reply-To: <alpine.DEB.2.20.1711221207460.1751@nanos>
References: <20171116183306.103584007@linutronix.de>
        <20171116184358.398030394@linutronix.de>
        <alpine.DEB.2.20.1711171057240.1709@nanos>
        <20171117150639.0e706421@vento.lan>
        <alpine.DEB.2.20.1711171850330.2186@nanos>
        <20171117183946.GA28533@lst.de>
        <alpine.DEB.2.20.1711221207460.1751@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Em Wed, 22 Nov 2017 12:12:04 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> escreveu:

> On Fri, 17 Nov 2017, Christoph Hellwig wrote:
> > On Fri, Nov 17, 2017 at 07:11:41PM +0100, Thomas Gleixner wrote:  
> > > Introcude a MODULE_LICENSE_SPDX macro which flags the module info storage
> > > as 'SPDXIFY' and let the postprocessor do:  
> > 
> > Shouldn;t this be a FILE_LICENSE_SPDX?  I'd also much prefer that over
> > the nasty C99 comments to start with.  And while I'm a bit behind on
> > email I still haven't managed to find a good rationale for those to
> > start with.

Yeah, I also find nasty to have things like this on each C file:

// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright ...
 * ...
 */

Also, one may forget that headers use /**/ and end by doing the wrong
thing, as a common practice is to just cut-and-paste the same copyright
header on both C and H files at development time.

> > 
> > So it would be good to figure this out before people start spamming
> > the lists with all kinds of mass conversions and checkpatch fixes
> > for licensing..  
> 
> I tried solving this with a macro in the first place and ran into issues:
> 
>    - Does not work in headers, especially not in UAPI ones

Make headers_install could replace such macros by SPDX comments when
installing on userspace.

>    - Breaks in assembly, boot and other special source files. There was no
>      easy solution to that and the result would have been to have macros in
>      some files and not in others.

At the end, we have different markups, depending on the file type.
I guess the main problem of using a macro is that a module composed
by multiple C files will end by defining it multiple times. Not sure
if gcc would do the right thing on grouping everything altogether
and producing the right equivalent to MODULE_LICENSE().

Also, at least on media, I found cases where the same module
has multiple licenses, e. g. some files that are grouped together on
a module are GPL v2 only, while others are GPL v2+.

> So the fallback was to use a comment and Linus decided the '//' style.
> 
> Thanks,
> 
> 	tglx
> 

Thanks,
Mauro
