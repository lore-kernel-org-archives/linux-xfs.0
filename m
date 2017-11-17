Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49903 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750869AbdKQSjs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 13:39:48 -0500
Date: Fri, 17 Nov 2017 19:39:46 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to
        describe how to properly identify file licenses
Message-ID: <20171117183946.GA28533@lst.de>
References: <20171116183306.103584007@linutronix.de> <20171116184358.398030394@linutronix.de> <alpine.DEB.2.20.1711171057240.1709@nanos> <20171117150639.0e706421@vento.lan> <alpine.DEB.2.20.1711171850330.2186@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1711171850330.2186@nanos>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Fri, Nov 17, 2017 at 07:11:41PM +0100, Thomas Gleixner wrote:
> Introcude a MODULE_LICENSE_SPDX macro which flags the module info storage
> as 'SPDXIFY' and let the postprocessor do:

Shouldn;t this be a FILE_LICENSE_SPDX?  I'd also much prefer that over
the nasty C99 comments to start with.  And while I'm a bit behind on
email I still haven't managed to find a good rationale for those to
start with.

So it would be good to figure this out before people start spamming
the lists with all kinds of mass conversions and checkpatch fixes
for licensing..
