Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:38186 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdKVLMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 06:12:15 -0500
Date: Wed, 22 Nov 2017 12:12:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
In-Reply-To: <20171117183946.GA28533@lst.de>
Message-ID: <alpine.DEB.2.20.1711221207460.1751@nanos>
References: <20171116183306.103584007@linutronix.de> <20171116184358.398030394@linutronix.de> <alpine.DEB.2.20.1711171057240.1709@nanos> <20171117150639.0e706421@vento.lan> <alpine.DEB.2.20.1711171850330.2186@nanos> <20171117183946.GA28533@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Fri, 17 Nov 2017, Christoph Hellwig wrote:
> On Fri, Nov 17, 2017 at 07:11:41PM +0100, Thomas Gleixner wrote:
> > Introcude a MODULE_LICENSE_SPDX macro which flags the module info storage
> > as 'SPDXIFY' and let the postprocessor do:
> 
> Shouldn;t this be a FILE_LICENSE_SPDX?  I'd also much prefer that over
> the nasty C99 comments to start with.  And while I'm a bit behind on
> email I still haven't managed to find a good rationale for those to
> start with.
> 
> So it would be good to figure this out before people start spamming
> the lists with all kinds of mass conversions and checkpatch fixes
> for licensing..

I tried solving this with a macro in the first place and ran into issues:

   - Does not work in headers, especially not in UAPI ones

   - Breaks in assembly, boot and other special source files. There was no
     easy solution to that and the result would have been to have macros in
     some files and not in others.

So the fallback was to use a comment and Linus decided the '//' style.

Thanks,

	tglx

