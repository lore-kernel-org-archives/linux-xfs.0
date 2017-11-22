Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45149 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751258AbdKVNfg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Nov 2017 08:35:36 -0500
Date: Wed, 22 Nov 2017 11:35:28 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171122113528.3f69fab6@vento.lan>
In-Reply-To: <20171122132328.GA26023@lst.de>
References: <20171116183306.103584007@linutronix.de>
        <20171116184358.398030394@linutronix.de>
        <alpine.DEB.2.20.1711171057240.1709@nanos>
        <20171117150639.0e706421@vento.lan>
        <alpine.DEB.2.20.1711171850330.2186@nanos>
        <20171117183946.GA28533@lst.de>
        <alpine.DEB.2.20.1711221207460.1751@nanos>
        <20171122095117.49c558a4@vento.lan>
        <20171122132328.GA26023@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Em Wed, 22 Nov 2017 14:23:29 +0100
Christoph Hellwig <hch@lst.de> escreveu:

> On Wed, Nov 22, 2017 at 09:51:17AM -0200, Mauro Carvalho Chehab wrote:
> > Also, one may forget that headers use /**/ and end by doing the wrong
> > thing, as a common practice is to just cut-and-paste the same copyright
> > header on both C and H files at development time.  
> 
> Yes.
> 
> > Make headers_install could replace such macros by SPDX comments when
> > installing on userspace.  
> 
> Agreed.  Or for that matter we could simply stick to the comment version
> for UAPI headers only, and have a macro for everything else.
> 
> > >    - Breaks in assembly, boot and other special source files. There was no
> > >      easy solution to that and the result would have been to have macros in
> > >      some files and not in others.  
> > 
> > At the end, we have different markups, depending on the file type.
> > I guess the main problem of using a macro is that a module composed
> > by multiple C files will end by defining it multiple times. Not sure
> > if gcc would do the right thing on grouping everything altogether
> > and producing the right equivalent to MODULE_LICENSE().  
> 
> We'd basically need to add a new entry to a section, similar to how
> say __setup works in the core kernel.  But I think the important bit
> is to start with a macro now, even if it has zero functionality to
> start with - at least that enables us to fill the functionality once
> needed.
> 
> > Also, at least on media, I found cases where the same module
> > has multiple licenses, e. g. some files that are grouped together on
> > a module are GPL v2 only, while others are GPL v2+.  
> 
> A module always has the least permissive license of all files.

Yes, but I'm not sure how a macro would work. I mean, if a driver
foo has, let's say:

	foo-core.h: FILE_LICENSE_SPDX("SPDX-License-Identifier: GPL-2.0");
	foo-core.c: FILE_LICENSE_SPDX("SPDX-License-Identifier: GPL-2.0");
	foo-driver.c: FILE_LICENSE_SPDX("SPDX-License-Identifier: GPL-2.0+");

I can't see how to write such macro in a way that it would be
discovering the license interception.

Thanks,
Mauro
