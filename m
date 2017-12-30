Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36762 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750790AbdL3EQI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Dec 2017 23:16:08 -0500
Date: Fri, 29 Dec 2017 23:15:35 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch V5 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171230041535.GA3393@thunk.org>
References: <20171228152710.891701433@linutronix.de>
 <20171228153308.286787253@linutronix.de>
 <alpine.DEB.2.20.1712282315030.1899@nanos>
 <CAOFm3uG_Sj1+jf32CvCeuWZV_nK1f-8B6POd_nZXAEJghnB08w@mail.gmail.com>
 <1514564399.10256.7.camel@perches.com>
 <20171229185404.GD11757@thunk.org>
 <CAOFm3uHm5ye7VdbVYcu+a_-3paO7phazNSGzhRL3wzGFcx-MkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFm3uHm5ye7VdbVYcu+a_-3paO7phazNSGzhRL3wzGFcx-MkQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andreas Dilger <adilger@dilger.ca>

On Fri, Dec 29, 2017 at 11:17:54PM +0100, Philippe Ombredanne wrote:
> > As far as I know, none of the licenses explicitly say
> > copyright license must be on each file.  Just that the distribution of
> > source must include the copyright and license statement.  Exactly how
> > that is done is not explicitly specified.
> 
> This is also my take. What is done here is not much different than
> refactoring duplicated code so it leaves in a single place:
> 
> - by "value" at the root in COPYING and in the Documentation.
> - by "reference" in the code proper as SPDX ids.
> 
> Therefore essential and common requirements to include the license
> text is fulfilled in the kernel.
> 
> Note that there are a few offenders that will need to clean up their
> acts as they came up will both long and "un-removable and
> un-alterable" crazy legalese blurbs [1] prefix this:
> 
> "DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER"
> 
> These will have to be taken care on a case by case basis. These are
> pretty stupid and IMHO should have never been allowed to be added to
> the kernel in the first place and are ugly warts. It could very well
> be that these are not really GPL-compliant notices FWIW: keeping
> notices and copyrights is quite different from a restriction of
> altering things by moving them around which is exactly what is
> happening with the SPDX-ification here.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/staging/lustre/include/linux/libcfs/libcfs.h?h=v4.15-rc5#n5

Lustre is now owned by Intel so I suspect that some throat clearing
noises in the right direction could easily take care of the issue with
those files....

					- Ted
