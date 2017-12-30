Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:34993 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdL3LC5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Dec 2017 06:02:57 -0500
Date: Sat, 30 Dec 2017 12:02:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch V5 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
In-Reply-To: <20171229185404.GD11757@thunk.org>
Message-ID: <alpine.DEB.2.20.1712301155260.1899@nanos>
References: <20171228152710.891701433@linutronix.de> <20171228153308.286787253@linutronix.de> <alpine.DEB.2.20.1712282315030.1899@nanos> <CAOFm3uG_Sj1+jf32CvCeuWZV_nK1f-8B6POd_nZXAEJghnB08w@mail.gmail.com> <1514564399.10256.7.camel@perches.com>
 <20171229185404.GD11757@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Joe Perches <joe@perches.com>, Philippe Ombredanne <pombredanne@nexb.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On Fri, 29 Dec 2017, Theodore Ts'o wrote:
> On Fri, Dec 29, 2017 at 08:19:59AM -0800, Joe Perches wrote:
> > 
> > Has it been legally reviewed and accepted that removal
> > of the BSD license text from individual source files is
> > appropriate and meets the legal requirements of
> > following the BSD license on a per-file basis?
> > 
> > And if so, who did this review?
> > 
> > Is there any license that does not allow removal of the
> > license text and does not allow simple substitution of
> > the SPDX license identifier in each individual file?
> 
> The work to use SPDX lines instead of individual licenses was done by
> Greg K-H in close consultation with Linux Foundation counsels, so I
> would assume that they did look at that particular issue.
> 
> IANAL, but I've talked to lawyers about this issue, and in my
> experience if you talk to three lawyers you will easily get six
> opinions.  As far as I know, none of the licenses explicitly say
> copyright license must be on each file.  Just that the distribution of
> source must include the copyright and license statement.  Exactly how
> that is done is not explicitly specified.

Aside of that we are not removing anything, except the obvious one liners
like

	This file is licensed under GPLV2

	For licensing see COPYING

and similar constructs. Replacing the full boilerplate text is done by
talking to the respective copyright holders, which usually involves lawyers
when the copyright holder is a corporate. See for example:

commit 987b154983f0e70b02edf6fc75fcc2f6e6d670b9
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Mon Dec 4 10:57:02 2017 +0100

    s390: Remove redudant license text

where the removal has been done by IBM in files copyrighted by IBM.

Thanks,

	tglx
