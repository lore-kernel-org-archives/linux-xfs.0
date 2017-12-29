Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36056 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751159AbdL2Syu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Dec 2017 13:54:50 -0500
Date: Fri, 29 Dec 2017 13:54:04 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch V5 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171229185404.GD11757@thunk.org>
References: <20171228152710.891701433@linutronix.de>
 <20171228153308.286787253@linutronix.de>
 <alpine.DEB.2.20.1712282315030.1899@nanos>
 <CAOFm3uG_Sj1+jf32CvCeuWZV_nK1f-8B6POd_nZXAEJghnB08w@mail.gmail.com>
 <1514564399.10256.7.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514564399.10256.7.camel@perches.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>
Cc: Philippe Ombredanne <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On Fri, Dec 29, 2017 at 08:19:59AM -0800, Joe Perches wrote:
> 
> Has it been legally reviewed and accepted that removal
> of the BSD license text from individual source files is
> appropriate and meets the legal requirements of
> following the BSD license on a per-file basis?
> 
> And if so, who did this review?
> 
> Is there any license that does not allow removal of the
> license text and does not allow simple substitution of
> the SPDX license identifier in each individual file?

The work to use SPDX lines instead of individual licenses was done by
Greg K-H in close consultation with Linux Foundation counsels, so I
would assume that they did look at that particular issue.

IANAL, but I've talked to lawyers about this issue, and in my
experience if you talk to three lawyers you will easily get six
opinions.  As far as I know, none of the licenses explicitly say
copyright license must be on each file.  Just that the distribution of
source must include the copyright and license statement.  Exactly how
that is done is not explicitly specified.

						- Ted
